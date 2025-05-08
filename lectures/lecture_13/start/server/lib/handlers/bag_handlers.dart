import 'dart:convert';

import 'package:server/models/bag_entity.dart';
import 'package:server/repositories/bag_repository.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

BagRepository repo = BagRepository();

Future<Response> postBagHandler(Request request) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  var bag = Bag.fromJson(json);

  var bagEntity = await repo.create(bag.toEntity());

  bag = await bagEntity.toModel();

  return Response.ok(
    jsonEncode(bag.toJson()),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> getBagsHandler(Request request) async {
  final entities = await repo.getAll();

  final bags = await Future.wait(entities.map((e) => e.toModel()));

  final payload = bags.map((e) => e.toJson()).toList();

  return Response.ok(
    jsonEncode(payload),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> getBagHandler(Request request) async {
  String? id = request.params["id"];

  if (id != null) {
    var entity = await repo.getById(id);

    var bag = await entity?.toModel();

    return Response.ok(
      jsonEncode(bag?.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  }

  // do better handling
  return Response.badRequest();
}

Future<Response> updateBagHandler(Request request) async {
  String? id = request.params["id"];

  if (id != null) {
    final data = await request.readAsString();
    final json = jsonDecode(data);
    Bag? bag = Bag.fromJson(json);
    var entity = bag.toEntity();
    entity = await repo.update(id, entity);
    bag = await entity.toModel();

    return Response.ok(
      jsonEncode(bag.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  }

  // TODO: do better handling
  return Response.badRequest();
}

Future<Response> deleteBagHandler(Request request) async {
  String? id = request.params["id"];

  if (id != null) {
    var entity = await repo.delete(id);

    var bag = await entity.toModel();

    return Response.ok(
      jsonEncode(bag.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  }

  // TODO: do better handling
  return Response.badRequest();
}
