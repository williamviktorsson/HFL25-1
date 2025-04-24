import 'package:app/bloc/items/items_bloc.dart';
import 'package:app/repositories/item_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared/shared.dart';

class MockItemRepository extends Mock implements ItemRepository {}

class FakeItem extends Fake implements Item {
  @override
  String description;
  @override
  String id;

  FakeItem(this.description, [this.id = "-1"]);
}

void main() {
  group('ItemsBloc', () {
    late ItemRepository itemRepository;

    setUpAll(() {
      // register the fake item to be used with mocked calls
      registerFallbackValue(FakeItem('fake description'));
    });

    setUp(() {
      itemRepository = MockItemRepository();
    });

    ItemsBloc buildBloc() {
      // fetch new bloc for each test

      return ItemsBloc(
        repository: itemRepository,
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(buildBloc, returnsNormally);
      });

      test('has correct initial state', () {
        expect(
          buildBloc().state,
          equals(ItemsInitial()),
        );
      });
    });
group('CreateItem', () {
      final newItem = Item('New item description', "3");
      final existingItems = [
        Item('First item description', "1"),
        Item('Second item description', "2"),
      ];

      blocTest<ItemsBloc, ItemsState>(
        'emits [ItemsReloading, ItemsLoaded] when successful',
        setUp: () {
          when(() => itemRepository.create(any())).thenAnswer((_) async {
            return newItem;
          });
          when(() => itemRepository.getAll())
              .thenAnswer((_) async => [...existingItems, newItem]);
        },
        build: buildBloc,
        seed: () => ItemsLoaded(
            items:
                existingItems), // setup the initial state of the bloc before calling act
        act: (bloc) => bloc.add(CreateItem(item: newItem)),
        expect: () => [
          ItemsLoaded(items: [...existingItems, newItem], pending: newItem),
          ItemsLoaded(items: [...existingItems, newItem]),
        ],
        verify: (_) {
          verify(() => itemRepository.create(newItem)).called(1);
          verify(() => itemRepository.getAll()).called(1);
        },
      );

      blocTest<ItemsBloc, ItemsState>(
        'emits [ItemsError] when create fails',
        setUp: () {
          when(() => itemRepository.create(any()))
              .thenThrow(Exception('Failed to create item'));
        },
        build: buildBloc,
        seed: () => ItemsLoaded(items: existingItems),
        act: (bloc) => bloc.add(CreateItem(item: newItem)),
        expect: () => [
          ItemsLoaded(items: [...existingItems, newItem], pending: newItem),
          ItemsError(message: 'Exception: Failed to create item'),
        ],
      );
    });

    group('UpdateItem', () {
      final updatedItem = Item('Updated item description', "1");
      final existingItems = [
        Item('First item description', "1"),
        Item('Second item description', "2"),
      ];

      blocTest<ItemsBloc, ItemsState>(
        'emits [ItemsReloading, ItemsLoaded] when successful',
        setUp: () {
          when(() => itemRepository.update(any(), any())).thenAnswer((_) async {
            return updatedItem;
          });
          when(() => itemRepository.getAll())
              .thenAnswer((_) async => [updatedItem, existingItems[1]]);
        },
        build: buildBloc,
        seed: () => ItemsLoaded(items: existingItems),
        act: (bloc) => bloc.add(UpdateItem(item: updatedItem)),
        expect: () => [
          ItemsLoaded(
              items: [updatedItem, existingItems[1]], pending: updatedItem),
          ItemsLoaded(items: [updatedItem, existingItems[1]]),
        ],
        verify: (_) {
          verify(() => itemRepository.update(updatedItem.id, updatedItem))
              .called(1);
          verify(() => itemRepository.getAll()).called(1);
        },
      );

      blocTest<ItemsBloc, ItemsState>(
        'emits [ItemsError] when update fails',
        setUp: () {
          when(() => itemRepository.update(any(), any()))
              .thenThrow(Exception('Failed to update item'));
        },
        build: buildBloc,
        seed: () => ItemsLoaded(items: existingItems),
        act: (bloc) => bloc.add(UpdateItem(item: updatedItem)),
        expect: () => [
          ItemsLoaded(
              items: [updatedItem, existingItems[1]], pending: updatedItem),
          ItemsError(message: 'Exception: Failed to update item'),
        ],
      );
    });

    group('DeleteItem', () {
      final itemToDelete = Item('First item description', "1");
      final existingItems = [
        Item('First item description', "1"),
        Item('Second item description', "2"),
      ];

      blocTest<ItemsBloc, ItemsState>(
        'emits [ItemsReloading, ItemsLoaded] when successful',
        setUp: () {
          when(() => itemRepository.delete(any())).thenAnswer((_) async {
            return itemToDelete;
          });
          when(() => itemRepository.getAll())
              .thenAnswer((_) async => [existingItems[1]]);
        },
        build: buildBloc,
        seed: () => ItemsLoaded(items: existingItems),
        act: (bloc) => bloc.add(DeleteItem(item: itemToDelete)),
        expect: () => [
          ItemsLoaded(items: existingItems, pending: itemToDelete),
          ItemsLoaded(items: [existingItems[1]]),
        ],
        verify: (_) {
          verify(() => itemRepository.delete(itemToDelete.id)).called(1);
          verify(() => itemRepository.getAll()).called(1);
        },
      );

      blocTest<ItemsBloc, ItemsState>(
        'emits [ItemsError] when delete fails',
        setUp: () {
          when(() => itemRepository.delete(any()))
              .thenThrow(Exception('Failed to delete item'));
        },
        build: buildBloc,
        seed: () => ItemsLoaded(items: existingItems),
        act: (bloc) => bloc.add(DeleteItem(item: itemToDelete)),
        expect: () => [
          ItemsLoaded(items: existingItems, pending: itemToDelete),
          ItemsError(message: 'Exception: Failed to delete item'),
        ],
      );
    });
  });
}
