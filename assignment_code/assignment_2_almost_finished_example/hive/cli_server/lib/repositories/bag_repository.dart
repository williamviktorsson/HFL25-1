import 'dart:convert';

import 'package:cli_server/router_config.dart';
import 'package:cli_shared/cli_shared.dart';


class BagRepository implements RepositoryInterface<Bag> {
  final bagBox = ServerConfig.instance.bagBox;

  @override
  Future<Bag> create(Bag bag) async {
    // above command did not error
    await bagBox.put(bag.id, jsonEncode(bag.toJson()));
    return bag;
  }

  @override
  Future<Bag?> getById(String id) async {
    final json = await bagBox.get(id);
    if (json != null) {
      return Bag.fromJson(jsonDecode(json));
    } else {
      return null;
    }
  }

  @override
  Future<List<Bag>> getAll() async {
    final map = await bagBox.getAllValues();

    final listOfJsonBags = map.values.toList();

    return listOfJsonBags
        .map((json) => Bag.fromJson(jsonDecode(json)))
        .toList();
  }

  @override
  Future<Bag?> update(String id, Bag newBag) async {
    await bagBox.put(id, jsonEncode(newBag.toJson()));
    return newBag;
  }

  @override
  Future<Bag?> delete(String id) async {
    final json = await bagBox.get(id);

    if (json != null) {
      await bagBox.delete(id);
      return Bag.fromJson(jsonDecode(json));
    }

    return null;
  }
}
