import 'dart:convert';
import 'dart:io';

import 'package:server/repositories/item_repository.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..get('/echo/<message>', _echoHandler)
  ..post('/items', _createItemHandler)
  ..get('/items', _getItemsHandler);

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

final item_repository = ItemRepository();

Future<Response> _createItemHandler(Request request) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  Item item = Item.fromJson(json);

  Item created = await item_repository.create(item);

  return Response.ok(jsonEncode(created.toJson()));
}

Future<Response> _getItemsHandler(Request request) async {
  List<Item> items = await item_repository.getAll();

  List<dynamic> itemsList = items.map((e) => e.toJson()).toList();

  return Response.ok(jsonEncode(itemsList));
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler =
      Pipeline().addMiddleware(logRequests()).addHandler(_router.call);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
