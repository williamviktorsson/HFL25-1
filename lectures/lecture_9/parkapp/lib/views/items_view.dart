import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkapp/repositories/item_repository.dart';
import 'package:shared/shared.dart';

class ItemsView extends StatefulWidget {
  const ItemsView({super.key});

  @override
  State<ItemsView> createState() => _ItemsViewState();
}

class _ItemsViewState extends State<ItemsView> {
  Future future = ItemRepository().getAll();

  @override
  Widget build(BuildContext context) {
    return HeroControllerScope(
      controller: MaterialApp.createMaterialHeroController(),
      child: Navigator(
        onGenerateRoute:
            (settings) => CustomPageRoute(
              builder:
                  (context) => Scaffold(
                    body: FutureBuilder(
                      future: future,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          return RefreshIndicator(
                            onRefresh: () async {
                              future = ItemRepository().getAll();
                              await future;
                              setState(() {});
                            },
                            child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      CustomPageRoute(
                                        builder: (context) {
                                          return ItemWidget(
                                            item: snapshot.data![index],
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  title: Hero(
                                    tag:
                                        snapshot.data![index].id +
                                        snapshot.data![index].id,
                                    child: Text(snapshot.data![index].id),
                                  ),
                                  subtitle: Hero(
                                    tag:
                                        snapshot.data![index].id +
                                        snapshot.data![index].description,
                                    child: Text(
                                      snapshot.data![index].description,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () async {
                                      await ItemRepository().delete(
                                        snapshot.data![index].id,
                                      );
                                      setState(() {
                                        future = ItemRepository().getAll();
                                      });
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                );
                              },
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text("Error: ${snapshot.error}"),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                    floatingActionButton:
                        true
                            ? null
                            : FloatingActionButton(
                              onPressed: () async {
                                Item? created = await createItem(context);
                                if (created != null) {
                                  // dispatch create item event
                                  await ItemRepository().create(created);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.greenAccent,

                                      content: Text(
                                        '${created.description} skapat!',
                                      ),
                                      action: SnackBarAction(
                                        label: 'Ångra',

                                        onPressed: () async {
                                          // Återställ skapandet
                                          await ItemRepository().delete(
                                            created.id,
                                          );
                                          setState(() {
                                            future = ItemRepository().getAll();
                                          });
                                        },
                                      ),
                                    ),
                                  );

                                  setState(() {
                                    future = ItemRepository().getAll();
                                  });
                                }
                              },
                              child: Icon(Icons.add),
                            ),
                  ),
            ),
      ),
    );
  }

  Future<Item?> createItem(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final costFocusNode = FocusNode();
    final createButtonFocusNode = FocusNode();

    return showModalBottomSheet<Item>(
      context: context,
      builder: (context) {
        String description = "";

        return Container(
          padding: EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Create new item'),
                Divider(),
                Expanded(
                  child: Column(
                    children: [
                      TextFormField(
                        autofocus: true,
                        decoration: InputDecoration(labelText: 'Description'),
                        onSaved: (value) {
                          description = value!;
                        },
                        validator: (value) {
                          if (value == null || value.length == 0) {
                            return "Write a description";
                          } else {
                            return null;
                          }
                        },
                        onFieldSubmitted: (value) {
                          costFocusNode.requestFocus();
                        },
                      ),
                      TextFormField(
                        focusNode: costFocusNode,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Cost'),
                        validator: (value) {
                          if (value == null || value.length == 0) {
                            return "Write a cost";
                          } else {
                            return null;
                          }
                        },
                        onFieldSubmitted: (value) {
                          createButtonFocusNode.requestFocus();
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  spacing: 16,
                  children: [
                    FilledButton.tonal(
                      onPressed: () => Navigator.pop(context),

                      child: Text('Cancel'),
                    ),

                    TextButton(
                      focusNode: createButtonFocusNode,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          Navigator.pop(context, Item(description));
                        }
                      },

                      child: Text('Create'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: true,
            title: Hero(
              tag: item.id + item.description,
              child: Material(child: Text(item.description)),
            ),
          ),
          Expanded(
            child: Center(
              child: Hero(
                tag: item.id + item.id,
                child: Material(child: Text(item.id)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomPageRoute extends MaterialPageRoute {
  CustomPageRoute({required super.builder});

  @override
  Duration get transitionDuration => Duration(milliseconds: 1000);
}
