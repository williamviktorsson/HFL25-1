import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared/shared.dart';


class ItemRepository implements RepositoryInterface<Item> {
  @override
  Future<Item> getById(String id) async {
    final uri = Uri.parse("http://localhost:8080/items/${id}");

    Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return Item.fromJson(json);
  }

  @override
  Future<Item> create(Item item) async {
    // send item serialized as json over http to server at localhost:8080
    final uri = Uri.parse("http://localhost:8080/items");

    Response response = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(item.toJson()));

    final json = jsonDecode(response.body);

    return Item.fromJson(json);
  }

  @override
  Future<List<Item>> getAll() async {
    final uri = Uri.parse("http://localhost:8080/items");
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return (json as List).map((item) => Item.fromJson(item)).toList();
  }

  @override
  Future<Item> delete(String id) async {
    final uri = Uri.parse("http://localhost:8080/items/${id}");

    Response response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return Item.fromJson(json);
  }

  @override
  Future<Item> update(String id, Item item) async {
    // send item serialized as json over http to server at localhost:8080
    final uri = Uri.parse("http://localhost:8080/items/${id}");

    Response response = await http.put(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(item.toJson()));

    final json = jsonDecode(response.body);

    return Item.fromJson(json);
  }
}
