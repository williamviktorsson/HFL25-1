import 'dart:convert';

import 'package:cli_server/router_config.dart';
import 'package:cli_shared/cli_shared.dart';

class ItemRepository implements RepositoryInterface<Item> {
  final itemBox = ServerConfig.instance.itemBox;

  @override
  Future<Item> create(Item item) async {
    // above command did not error
    await itemBox.put(item.id, jsonEncode(item.toJson()));
    return item;
  }

  @override
  Future<Item?> getById(String id) async {
    final json = await itemBox.get(id);
    if (json != null) {
      return Item.fromJson(jsonDecode(json));
    } else {
      return null;
    }
  }

  @override
  Future<List<Item>> getAll() async {
    final map = await itemBox.getAllValues();

    final listOfJsonItems = map.values.toList();

    return listOfJsonItems
        .map((json) => Item.fromJson(jsonDecode(json)))
        .toList();
  }

  @override
  Future<Item?> update(String id, Item newItem) async {
    await itemBox.put(id, jsonEncode(newItem.toJson()));
    return newItem;
  }

  @override
  Future<Item?> delete(String id) async {
    final json = await itemBox.get(id);

    if (json != null) {
      await itemBox.delete(id);
      return Item.fromJson(jsonDecode(json));
    }

    return null;
  }
}
