import 'dart:convert';

import 'package:cli_server/repositories/item_repository.dart';
import 'package:cli_shared/cli_shared.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

ItemRepository repo = ItemRepository();

Future<Response> postItemHandler(Request request) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  var item = Item.fromJson(json);

  var result = await repo.create(item);

  switch (result) {
    case Success(data: var item):
      return Response.ok(
        jsonEncode(item),
        headers: {'Content-Type': 'application/json'},
      );

    case Failure(error: var error):
      return Response.badRequest(body: error);
  }
}

Future<Response> getItemsHandler(Request request) async {
  final result = await repo.getAll();

  switch (result) {
    case Success(data: var items):
      final payload = items.map((e) => e.toJson()).toList();

      print(payload);

      return Response.ok(
        jsonEncode(payload),
        headers: {'Content-Type': 'application/json'},
      );

    case Failure(error: var error):
      return Response.badRequest(body: error);
  }
}

Future<Response> getItemHandler(Request request) async {
  String? id = request.params["id"];

  if (id != null) {
    var result = await repo.getById(id);

    switch (result) {
      case Success(data: var item):
        return Response.ok(
          jsonEncode(item),
          headers: {'Content-Type': 'application/json'},
        );

      case Failure(error: var error):
        return Response.badRequest(body: error);
    }
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
    var result = await repo.update(id, item);

    switch (result) {
      case Success(data: var item):
        return Response.ok(
          jsonEncode(item),
          headers: {'Content-Type': 'application/json'},
        );

      case Failure(error: var error):
        return Response.badRequest(body: error);
    }
  }

  // TODO: do better handling
  return Response.badRequest();
}

Future<Response> deleteItemHandler(Request request) async {
  String? id = request.params["id"];

  if (id != null) {
    var result = await repo.delete(id);

    switch (result) {
      case Success(data: var item):
        return Response.ok(
          jsonEncode(item),
          headers: {'Content-Type': 'application/json'},
        );

      case Failure(error: var error):
        return Response.badRequest(body: error);
    }
  }

  // TODO: do better handling
  return Response.badRequest();
}
