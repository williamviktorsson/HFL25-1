import 'package:app/repositories/item_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/shared.dart';

part 'items_state.dart';
part 'items_event.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final ItemRepository repository;

  ItemsBloc({required this.repository}) : super(ItemsInitial()) {
    on<ItemsEvent>((event, emit) async {
      try {
        switch (event) {

          case UpdateItem(item: final item):
            await onUpdateItem(item, emit);

          case CreateItem(item: final item):
            await onCreateItem(item, emit);

          case DeleteItem(item: final item):
            await onDeleteItem(emit, item);

          case SubScribeToItems():
            await emit.forEach(repository.subscribe(), onData: (items) {
              return ItemsLoaded(items: items);
            });
        }
      } catch (e) {
        emit(ItemsError(message: e.toString()));
      }
    });
  }


  Future<void> onDeleteItem(Emitter<ItemsState> emit, Item item) async {
    final currentItems = switch (state) {
      ItemsLoaded(:final items) => [...items],
      _ => <Item>[],
    };
    emit(ItemsLoaded(items: currentItems, pending: item));

    await repository.delete(item.id);

  }

  Future<void> onCreateItem(Item item, Emitter<ItemsState> emit) async {
    final currentItems = switch (state) {
      ItemsLoaded(:final items) => [...items],
      _ => <Item>[],
    };
    currentItems.add(item);
    emit(ItemsLoaded(items: currentItems, pending: item));

    await repository.create(item); // async operation mocked in test

  }

  Future<void> onUpdateItem(Item item, Emitter<ItemsState> emit) async {
    final currentItems = switch (state) {
      ItemsLoaded(:final items) => [...items],
      _ => <Item>[],
    };
    var index = currentItems.indexWhere((e) => item.id == e.id);
    currentItems.removeAt(index);
    currentItems.insert(index, item);
    emit(ItemsLoaded(items: currentItems, pending: item));
    await repository.update(item.id, item);

  }


}
