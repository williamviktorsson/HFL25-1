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

  var result = await repo.create(bag);

  switch (result) {
    case Success(data: var bag):
      return Response.ok(
        jsonEncode(bag),
        headers: {'Content-Type': 'application/json'},
      );

    case Failure(error: var error):
      return Response.badRequest(body: error);
  }
}

Future<Response> getBagsHandler(Request request) async {
  final result = await repo.getAll();

  switch (result) {
    case Success(data: var bags):
      final payload = bags.map((e) => e.toJson()).toList();

      print(payload);

      return Response.ok(
        jsonEncode(payload),
        headers: {'Content-Type': 'application/json'},
      );

    case Failure(error: var error):
      return Response.badRequest(body: error);
  }
}

Future<Response> getBagHandler(Request request) async {
  String? id = request.params["id"];

  if (id != null) {
    var result = await repo.getById(id);

    switch (result) {
      case Success(data: var bag):
        return Response.ok(
          jsonEncode(bag),
          headers: {'Content-Type': 'application/json'},
        );

      case Failure(error: var error):
        return Response.badRequest(body: error);
    }
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
    var result = await repo.update(id, bag);

    switch (result) {
      case Success(data: var bag):
        return Response.ok(
          jsonEncode(bag),
          headers: {'Content-Type': 'application/json'},
        );

      case Failure(error: var error):
        return Response.badRequest(body: error);
    }
  }

  // TODO: do better handling
  return Response.badRequest();
}

Future<Response> deleteBagHandler(Request request) async {
  String? id = request.params["id"];

  if (id != null) {
    var result = await repo.delete(id);

    switch (result) {
      case Success(data: var bag):
        return Response.ok(
          jsonEncode(bag),
          headers: {'Content-Type': 'application/json'},
        );

      case Failure(error: var error):
        return Response.badRequest(body: error);
    }
  }

  // TODO: do better handling
  return Response.badRequest();
}
