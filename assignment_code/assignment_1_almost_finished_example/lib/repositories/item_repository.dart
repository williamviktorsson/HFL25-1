import 'package:cli/models/item.dart';
import 'package:cli/repositories/repository_interface.dart';

class ItemRepository implements RepositoryInterface<Item> {
  // singleton

  ItemRepository._internal();

  static final ItemRepository _instance = ItemRepository._internal();

  static ItemRepository get instance => _instance;

  final _items = [];

  @override
  Item create(Item item) {
    if (item.id < 0) {
      item.id = _items.length;
    }
    _items.add(item);
    return item;
  }

  @override
  Item getById(int id) {
    return _items.firstWhere((e) => e.id == id);
  }

  @override
  List<Item> getAll() => List.from(_items);

  @override
  Item update(int id, Item newItem) {
    var index = _items.indexWhere((e) => e.id == id);
    if (index >= 0 && index < _items.length) {
      _items[index] = newItem;
      return newItem;
    }
    throw RangeError.index(index, _items);
  }

  @override
  Item delete(int id) {
    var index = _items.indexWhere((e) => e.id == id);
    if (index >= 0 && index < _items.length) {
      return _items.removeAt(index);
    }
    throw RangeError.index(index, _items);
  }
}
