import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared/shared.dart';
import 'package:http/http.dart' as http;

class ItemRepository implements RepositoryInterface<Item> {
  // singleton

  ItemRepository._internal();

  static final ItemRepository _instance = ItemRepository._internal();

  static ItemRepository get instance => _instance;

  final _items = [];

  @override
  Future<Item> create(Item item) async {
    final url = Uri.parse("http://localhost:8080/items");

    Response response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(item.toJson()));

    final json = await jsonDecode(response.body);

    return Item.fromJson(json);
  }

  @override
  Future<Item> getById(int id) async {
    return _items.firstWhere((e) => e.id == id);
  }

  @override
  Future<List<Item>> getAll() async {
    final url = Uri.parse("http://localhost:8080/items");

    Response response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    final json = await jsonDecode(response.body); // decoded json list

    final List<Item> items =
        (json as List<dynamic>).map((e) => Item.fromJson(e)).toList();

    return items;
  }

  @override
  Future<Item> update(int id, Item newItem) async {
    var index = _items.indexWhere((e) => e.id == id);
    if (index >= 0 && index < _items.length) {
      _items[index] = newItem;
      return newItem;
    }
    throw RangeError.index(index, _items);
  }

  @override
  Future<Item> delete(int id) async {
    var index = _items.indexWhere((e) => e.id == id);
    if (index >= 0 && index < _items.length) {
      return _items.removeAt(index);
    }
    throw RangeError.index(index, _items);
  }
}
