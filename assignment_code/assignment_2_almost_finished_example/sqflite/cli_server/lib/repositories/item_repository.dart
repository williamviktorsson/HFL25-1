import 'dart:convert';

import 'package:cli_server/router_config.dart';
import 'package:cli_shared/cli_shared.dart';

class ItemRepository implements RepositoryInterface<Item> {
  final db = ServerConfig.instance.db;

  @override
  Future<Item> create(Item item) async {
    // above command did not error

    await db.insert("items", {
      "id": item.id,
      "blob": jsonEncode(item.toJson()),
    });

    return item;
  }

  @override
  Future<Item?> getById(String id) async {
    final List<Map<String, dynamic>> items =
        await db.query("items", where: "id = ?", whereArgs: [id]);

    if (items.isEmpty) {
      return null;
    }

    return Item.fromJson(jsonDecode(items.first["blob"]));
  }

  @override
  Future<List<Item>> getAll() async {
    final List<Map<String, dynamic>> items = await db.query("items");

    return items
        .map((item) => Item.fromJson(jsonDecode(item["blob"])))
        .toList();
  }

  @override
  Future<Item?> update(String id, Item newItem) async {
    final int affectedRows = await db.update(
      "items",
      {
        "id": newItem.id,
        "blob": jsonEncode(newItem.toJson()),
      },
      where: "id = ?",
      whereArgs: [id],
    );

    if (affectedRows == 0) {
      return null;
    }

    return newItem;
  }

  @override
  Future<Item?> delete(String id) async {
    // fetch the item

    final item = await getById(id);

    if (item == null) {
      return null;
    }

    final int affectedRows = await db.delete(
      "items",
      where: "id = ?",
      whereArgs: [id],
    );

    if (affectedRows == 0) {
      return null;
    } else {
      return item;
    }
  }
}
