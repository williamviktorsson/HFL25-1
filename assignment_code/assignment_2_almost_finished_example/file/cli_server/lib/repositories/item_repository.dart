import 'dart:convert';
import 'dart:io';

import 'package:cli_shared/cli_shared.dart';

class ItemRepository implements RepositoryInterface<Item> {
  final String path = "./items.json";

  const ItemRepository();

  @override
  Future<Item> create(item) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
      // dont try to create a database file if it exists.
    }

    try {
      String content = await file.readAsString();

      var json = jsonDecode(content) as List;

      json = [...json, item.toJson()];

      await file.writeAsString(jsonEncode(json));
    } catch (e) {
      // TODO: Log error information so Dennis can check it later
      throw Exception("Error writing to file");
    }

    return item;
  }

  @override
  Future<Item> getById(String id) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
      // dont try to create a database file if it exists.
    }

    String content = await file.readAsString();

    List<Item> items = ((jsonDecode(content) as List)
        .map((json) => Item.fromJson(json))
        .toList());

    for (var item in items) {
      if (item.id == id) {
        return item;
      }
    }
    throw Exception("No item found with id ${id}");
  }

  @override
  Future<List<Item>> getAll() async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
      // dont try to create a database file if it exists.
    }

    String content = await file.readAsString();

    List<Item> items = (jsonDecode(content) as List)
        .map((json) => Item.fromJson(json))
        .toList();

    return items;
  }

  @override
  Future<Item> update(String id, Item newItem) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
      // dont try to create a database file if it exists.
    }

    String content = await file.readAsString();

    List<Item> items = (jsonDecode(content) as List)
        .map((json) => Item.fromJson(json))
        .toList();

    for (var i = 0; i < items.length; i++) {
      if (items[i].id == id) {
        items[i] = newItem;

        await file.writeAsString(
            jsonEncode(items.map((item) => item.toJson()).toList()));

        return newItem;
      }
    }

    throw Exception("No item found with id ${id}");
  }

  @override
  Future<Item> delete(String id) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
      // dont try to create a database file if it exists.
    }

    String content = await file.readAsString();

    List<Item> items = (jsonDecode(content) as List)
        .map((json) => Item.fromJson(json))
        .toList();

    for (var i = 0; i < items.length; i++) {
      if (items[i].id == id) {
        final item = items.removeAt(i);
        await file.writeAsString(
            jsonEncode(items.map((item) => item.toJson()).toList()));
        return item;
      }
    }

    throw Exception("No item found with id ${id}");
  }
}
