import 'dart:convert';

import 'package:server/repositories/item_repository.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

ItemRepository repo = ItemRepository();

Future<Response> postItemHandler(Request request) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  var item = Item.fromJson(json);

  item = await repo.create(item);

  return Response.ok(
    jsonEncode(item),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> getItemsHandler(Request request) async {
  final items = await repo.getAll();

  final payload = items.map((e) => e.toJson()).toList();

  return Response.ok(
    jsonEncode(payload),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> getItemHandler(Request request) async {
  String? id = request.params["id"];

  if (id != null) {
    var item = await repo.getById(id);

    return Response.ok(
      jsonEncode(item),
      headers: {'Content-Type': 'application/json'},
    );
  }

  // do better handling
  return Response.badRequest();
}

Future<Response> updateItemHandler(Request request) async {
  String? id = request.params["id"];

  if (id != null) {
    final data = await request.readAsString();
    final json = jsonDecode(data);
    Item? item = Item.fromJson(json);
    item = await repo.update(id, item);

    return Response.ok(
      jsonEncode(item),
      headers: {'Content-Type': 'application/json'},
    );
  }

  // TODO: do better handling
  return Response.badRequest();
}

Future<Response> deleteItemHandler(Request request) async {
  String? id = request.params["id"];

  if (id != null) {
    var item = await repo.delete(id);

    return Response.ok(
      jsonEncode(item),
      headers: {'Content-Type': 'application/json'},
    );
  }

  // TODO: do better handling
  return Response.badRequest();
}
