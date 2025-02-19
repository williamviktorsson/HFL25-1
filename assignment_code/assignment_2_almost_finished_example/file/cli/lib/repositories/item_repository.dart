import 'dart:convert';
import 'package:cli_shared/cli_shared.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ItemRepository implements RepositoryInterface<Item, String> {
  @override
  getById(String id) async {
    final uri = Uri.parse("http://localhost:8080/items/${id}");

    Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return Result.success(value: Item.fromJson(json));
  }

  @override
  create(Item item) async {
    // send item serialized as json over http to server at localhost:8080
    final uri = Uri.parse("http://localhost:8080/items");

    Response response = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(item.toJson()));

    final json = jsonDecode(response.body);

    return Result.success(value: Item.fromJson(json));
  }

  @override
  getAll() async {
    final uri = Uri.parse("http://localhost:8080/items");
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return Result.success(
        value: (json as List).map((item) => Item.fromJson(item)).toList());
  }

  @override
  delete(String id) async {
    final uri = Uri.parse("http://localhost:8080/items/${id}");

    Response response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return Result.success(value: Item.fromJson(json));
  }

  @override
  update(String id, Item item) async {
    // send item serialized as json over http to server at localhost:8080
    final uri = Uri.parse("http://localhost:8080/items/${id}");

    Response response = await http.put(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(item.toJson()));

    final json = jsonDecode(response.body);

    return Result.success(value: Item.fromJson(json));
  }
}
