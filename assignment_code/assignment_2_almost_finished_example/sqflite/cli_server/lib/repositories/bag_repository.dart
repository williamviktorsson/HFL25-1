import 'dart:convert';

import 'package:cli_server/router_config.dart';
import 'package:cli_shared/cli_shared.dart';

class BagRepository implements RepositoryInterface<Bag> {
  final db = ServerConfig.instance.db;

  @override
  Future<Bag> create(Bag bag) async {
    // above command did not error

    await db.insert("bags", {
      "id": bag.id,
      "blob": jsonEncode(bag.toJson()),
    });

    return bag;
  }

  @override
  Future<Bag?> getById(String id) async {
    final List<Map<String, dynamic>> bags =
        await db.query("bags", where: "id = ?", whereArgs: [id]);

    if (bags.isEmpty) {
      return null;
    }

    return Bag.fromJson(jsonDecode(bags.first["blob"]));
  }

  @override
  Future<List<Bag>> getAll() async {
    final List<Map<String, dynamic>> bags = await db.query("bags");

    return bags
        .map((bag) => Bag.fromJson(jsonDecode(bag["blob"])))
        .toList();
  }

  @override
  Future<Bag?> update(String id, Bag newBag) async {
    final int affectedRows = await db.update(
      "bags",
      {
        "id": newBag.id,
        "blob": jsonEncode(newBag.toJson()),
      },
      where: "id = ?",
      whereArgs: [id],
    );

    if (affectedRows == 0) {
      return null;
    }

    return newBag;
  }

  @override
  Future<Bag?> delete(String id) async {
    // fetch the bag

    final bag = await getById(id);

    if (bag == null) {
      return null;
    }

    final int affectedRows = await db.delete(
      "bags",
      where: "id = ?",
      whereArgs: [id],
    );

    if (affectedRows == 0) {
      return null;
    } else {
      return bag;
    }
  }
}
