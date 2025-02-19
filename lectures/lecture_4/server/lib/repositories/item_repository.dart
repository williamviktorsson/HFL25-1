import 'package:shared/shared.dart';

class ItemRepository implements RepositoryInterface<Item> {
  final List<Item> _items = [];


  @override
  Future<Item> create(Item item) async {
    _items.add(item);
    return item;
  }

  @override
  Future<Item> getById(String id) async {
    return _items.firstWhere((e) => e.id == id);
  }

  @override
  Future<List<Item>> getAll() async => List.from(_items);

  @override
  Future<Item> update(String id, Item newItem) async {
    var index = _items.indexWhere((e) => e.id == id);
    if (index >= 0 && index < _items.length) {
      _items[index] = newItem;
      return newItem;
    }
    throw RangeError.index(index, _items);
  }

  @override
  Future<Item> delete(String id) async {
    var index = _items.indexWhere((e) => e.id == id);
    if (index >= 0 && index < _items.length) {
      return _items.removeAt(index);
    }
    throw RangeError.index(index, _items);
  }
}
