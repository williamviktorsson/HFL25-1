import 'dart:convert';
import 'dart:io';

import 'package:cli_shared/cli_shared.dart';
import 'package:cli_server/models/bag.dart';

class BagRepository implements RepositoryInterface<Bag, String> {
  String path = "./bags.json";

  @override
  Future<Result<Bag, String>> create(bag) async {
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

      json = [...json, BagFactory.toJsonServer(bag)];

      await file.writeAsString(jsonEncode(json));
    } catch (e) {
      // TODO: Log error information so Dennis can check it later
      return Result.failure(reason: "failed to write bag to database");
    }

    return Result.success(value: bag);
  }

  @override
  Future<Result<Bag, String>> getById(String id) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
      return Result.failure(reason: "file already exists");
    }

    String content = await file.readAsString();

    List<Bag> bags = await Future.wait((jsonDecode(content) as List)
        .map((json) => BagFactory.fromJsonServer(json))
        .toList());

    for (var bag in bags) {
      if (bag.id == id) {
        return Result.success(value: bag);
      }
    }
    return Result.failure(reason: "no bag found with id ${id}");
  }

  @override
  Future<Result<List<Bag>, String>> getAll() async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
    }

    String content = await file.readAsString();

    List<Bag> bags = await Future.wait((jsonDecode(content) as List)
        .map((json) => BagFactory.fromJsonServer(json))
        .toList());

    return Result.success(value: bags);
  }

  @override
  Future<Result<Bag, String>> update(String id, Bag newBag) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
    }

    String content = await file.readAsString();

    List<Bag> bags = await Future.wait((jsonDecode(content) as List)
        .map((json) => BagFactory.fromJsonServer(json))
        .toList());

    for (var i = 0; i < bags.length; i++) {
      if (bags[i].id == id) {
        bags[i] = newBag;

        await file.writeAsString(jsonEncode(
            bags.map((bag) => BagFactory.toJsonServer(bag)).toList()));

        return Result.success(value: newBag);
      }
    }

    return Result.failure(reason: "no bag found with id ${id}");
  }

  @override
  Future<Result<Bag, String>> delete(String id) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
    }

    String content = await file.readAsString();

    List<Bag> bags = await Future.wait((jsonDecode(content) as List)
        .map((json) => BagFactory.fromJsonServer(json))
        .toList());

    for (var i = 0; i < bags.length; i++) {
      if (bags[i].id == id) {
        final bag = bags.removeAt(i);
        await file.writeAsString(jsonEncode(
            bags.map((bag) => BagFactory.toJsonServer(bag)).toList()));
        return Result.success(value: bag);
      }
    }

    return Result.failure(reason: "no bag found with id ${id}");
  }
}
