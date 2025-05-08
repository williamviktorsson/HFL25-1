import 'package:app/bloc/items/items_bloc.dart';
import 'package:app/cubit/selected_item_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class ItemsView extends StatelessWidget {
  ItemsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<ItemsBloc, ItemsState>(
          builder: (context, itemsState) {
            return switch (itemsState) {
              ItemsInitial() || ItemsLoading() => const CircularProgressIndicator(),
              ItemsLoaded(:final items, :final pending) =>
                BlocBuilder<SelectedItemCubit, Item?>(
                    builder: (context, selectedItem) {
                  return ListView.builder(
                      // TODO #2: Add PageStorageKey to ListView.builder for scroll position preservation

                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        var item = items[index];
                        bool is_pending = item.id == pending?.id;
                        return Hero(
                            tag: item.id,
                            child: Material(
                                child: ListTile(
                              enabled: !is_pending,
                              selected: item.id == selectedItem?.id,
                              onTap: () {
                                context.read<SelectedItemCubit>().select(item);
                              },
                              trailing: is_pending
                                  ? const CircularProgressIndicator()
                                  : null,
                              title: Text(item.description),
                            )));
                      });
                }),
              ItemsError(message: final message) => Text('Error: $message'),
            };
          },
        ),
      ),
      // add gap to row items
      floatingActionButton: AnimatedActionButtons(
        onClear: () {
          context.read<SelectedItemCubit>().deselect();
        },
        onItemCreated: (item) async {
          context.read<ItemsBloc>().add(CreateItem(item: item));
        },
        onItemEdited: (item) async {
          context.read<ItemsBloc>().add(UpdateItem(item: item));
        },
        onItemDeleted: (item) async {
          context.read<ItemsBloc>().add(DeleteItem(item: item));
        },
      ),
    );
  }
}

class AnimatedActionButtons extends StatelessWidget {
  final VoidCallback onClear;
  final Function(Item item) onItemCreated;
  final Function(Item item) onItemEdited;
  final Function(Item item) onItemDeleted;

  const AnimatedActionButtons({
    required this.onClear,
    required this.onItemCreated,
    super.key,
    required this.onItemEdited,
    required this.onItemDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final selectedItem = context.watch<SelectedItemCubit>().state;

    return OverflowBar(
      alignment: MainAxisAlignment.end,
      spacing: 8,
      children: [
        AnimatedSize(
          alignment: Alignment.centerRight,
          duration: const Duration(milliseconds: 200),
          child: selectedItem != null
              ? FloatingActionButton(
                  heroTag: "edit_item",
                  onPressed: () async {
                    var item = await editItemDialog(context, selectedItem);

                    if (item != null) {
                      // show snackbar showing item description success message

                      onItemEdited(item);
                    }
                  },
                  child: const Icon(Icons.edit),
                )
              : const SizedBox.shrink(),
        ),
        AnimatedSize(
          alignment: Alignment.centerRight,
          duration: const Duration(milliseconds: 200),
          reverseDuration: const Duration(milliseconds: 200),
          child: selectedItem != null
              ? FloatingActionButton(
                  heroTag: "delete_item",
                  onPressed: () {
                    onItemDeleted(selectedItem!);
                  },
                  child: const Icon(Icons.delete),
                )
              : const SizedBox.shrink(),
        ),
        AnimatedSize(
          alignment: Alignment.centerRight,
          duration: const Duration(milliseconds: 200),
          child: selectedItem != null
              ? FloatingActionButton.extended(
                  heroTag: "clear_selection",
                  label: const Text("Clear selection"),
                  onPressed: onClear,
                )
              : FloatingActionButton.extended(
                  heroTag: "add_item",
                  label: const Text("Add item"),
                  onPressed: () async {
                    var item = await createItemDialog(context);

                    if (item != null) {
                      // show snackbar showing item description success message

                      onItemCreated(item);
                    }
                  },
                ),
        ),
        FloatingActionButton(
          heroTag: "undo",
          onPressed: () async {
            context.read<SelectedItemCubit>().undo();
          },
          child: const Icon(Icons.undo),
        ),
        FloatingActionButton(
          heroTag: "redo",
          onPressed: () async {
            context.read<SelectedItemCubit>().redo();
          },
          child: const Icon(Icons.redo),
        )
      ],
    );
  }

  Future<Item?> createItemDialog(BuildContext context) {
    // TODO #8: Create CustomPageRoute for edit dialog
    // - Replace MaterialPageRoute with CustomPageRoute
    // - Add rotation and scale transitions
    return showModalBottomSheet<Item>(
        context: context,
        builder: (context) {
          String? description;

          final key = GlobalKey<FormState>();

          final focusNode = FocusNode();

          save() {
            if (key.currentState!.validate()) {
              key.currentState!.save();
              Navigator.of(context).pop(Item(description!));
            }
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Create new item",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Form(
                  key: key,
                  child: Column(
                    children: [
                      TextFormField(
                        autofocus: true,
                        decoration:
                            InputDecoration(hintText: "Enter item description"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a description";
                          }
                          return null;
                        },
                        onSaved: (value) => description = value,
                        onFieldSubmitted: (value) {
                          save();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              OverflowBar(spacing: 8, children: [
                FilledButton.tonal(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel")),
                FilledButton(
                  onPressed: () {
                    save();
                  },
                  child: Text("Create"),
                )
              ]),
            ]),
          );
        });
  }
}

Future<Item?> editItemDialog(BuildContext context, Item item) {
  return Navigator.of(context).push<Item>(
      CustomPageRouteBuilder<Item>(child: Builder(builder: (context) {
    String? description = item.description;

    final key = GlobalKey<FormState>();

    save() {
      if (key.currentState!.validate()) {
        key.currentState!.save();

        Navigator.of(context).pop(Item(description!, item.id));
      }
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Hero(
            tag: item.id,
            child: AppBar(
              automaticallyImplyLeading: false,
              title: Text(item.description),
              // No need to specify styles here anymore
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Form(
              key: key,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: item.description,
                    autofocus: true,
                    // add tooltip to description field
                    decoration: InputDecoration(
                        hintText: "Enter item description",
                        labelText: "Description"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a description";
                      }
                      return null;
                    },
                    onSaved: (value) => description = value,
                    onFieldSubmitted: (value) {
                      save();
                    },
                  ),
                ],
              ),
            ),
          ),
          OverflowBar(spacing: 8, children: [
            FilledButton.tonal(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel")),
            FilledButton(
              onPressed: () {
                save();
              },
              child: Text("Update"),
            )
          ]),
        ]),
      ),
    );
  })));
}

class CustomPageRouteBuilder<T> extends PageRouteBuilder<T> {
  final Widget child;

  CustomPageRouteBuilder({required this.child})
      : super(
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            /* rotate transition spin */
            final rotateTween = Tween<double>(begin: 0, end: 1);
            final rotateAnimation = rotateTween.animate(animation);

            return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child));
          },
        );
}


// se om det finns något enhetligare sätt att göra theming på






























