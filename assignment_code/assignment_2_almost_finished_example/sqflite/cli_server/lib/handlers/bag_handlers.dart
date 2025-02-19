import 'dart:convert';

import 'package:cli_server/repositories/bag_repository.dart';
import 'package:cli_shared/cli_shared.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

BagRepository repo = BagRepository();

Future<Response> postBagHandler(Request request) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  var bag = Bag.fromJson(json);

  bag = await repo.create(bag);

  return Response.ok(
    jsonEncode(bag),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> getBagsHandler(Request request) async {
  final bags = await repo.getAll();

  final payload = bags.map((e) => e.toJson()).toList();

  print(payload);

  return Response.ok(
    jsonEncode(payload),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> getBagHandler(Request request) async {
  String? id = request.params["id"];

  if (id != null) {
    Bag? bag = await repo.getById(id);
    return Response.ok(
      jsonEncode(bag),
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
    bag = await repo.update(id, bag);
    return Response.ok(
      jsonEncode(bag),
      headers: {'Content-Type': 'application/json'},
    );
  }

  // TODO: do better handling
  return Response.badRequest();
}

Future<Response> deleteBagHandler(Request request) async {
  String? id = request.params["id"];

  if (id != null) {
    Bag? bag = await repo.delete(id);
    return Response.ok(
      jsonEncode(bag),
      headers: {'Content-Type': 'application/json'},
    );
  }

  // TODO: do better handling
  return Response.badRequest();
}
