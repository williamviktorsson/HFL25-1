import 'dart:convert';
import 'dart:io';

import 'package:cli_server/router_config.dart';
import 'package:cli_shared/cli_shared.dart';

class ItemRepository implements RepositoryInterface<Item, String> {
  String path = "./items.json";

  @override
  Future<Result<Item, String>> create(item) async {
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
      return Result.failure(reason: "failed to write item to database");
    }

    return Result.success(value: item);
  }

  @override
  Future<Result<Item, String>> getById(String id) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
      return Result.failure(reason: "file already exists");
    }

    String content = await file.readAsString();

    List<Item> items = ((jsonDecode(content) as List)
        .map((json) => Item.fromJson(json))
        .toList());

    for (var item in items) {
      if (item.id == id) {
        return Result.success(value: item);
      }
    }
    return Result.failure(reason: "no item found with id ${id}");
  }

  @override
  Future<Result<List<Item>, String>> getAll() async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
    }

    String content = await file.readAsString();

    List<Item> items = (jsonDecode(content) as List)
        .map((json) => Item.fromJson(json))
        .toList();

    return Result.success(value: items);
  }

  @override
  Future<Result<Item, String>> update(String id, Item newItem) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
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

        return Result.success(value: newItem);
      }
    }

    return Result.failure(reason: "no item found with id ${id}");
  }

  @override
  Future<Result<Item, String>> delete(String id) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
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
        return Result.success(value: item);
      }
    }

    return Result.failure(reason: "no item found with id ${id}");
  }
}
