import 'dart:convert';
import 'dart:io';

import 'package:cli_server/repositories/bag_repository.dart';
import 'package:cli_shared/cli_shared.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';

void main() {
  final port = '10057';
  final host = 'http://localhost:$port';

  test('create_bag_repository', () async {
    Bag bag = Bag(description: "description");

    BagRepository().create(bag);

    var returnedBag = await BagRepository().create(bag);

    expect(
      returnedBag,
      bag,
    );
  });

  test('create_bag_handler', () async {
    final uri = Uri.parse("$host/bags");

    Bag bag = Bag(description: "description");

    Response response = await post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bag.toJson()));

    expect(response.statusCode, 200);
    final json = jsonDecode(response.body);
    var returnedBag = Bag.fromJson(json);
    expect(
      returnedBag,
      bag,
    );
  });

/*   test('Echo', () async {
    final response = await get(Uri.parse('$host/echo/hello'));
    expect(response.statusCode, 200);
    expect(response.body, 'hello\n');
  });

  test('404', () async {
    final response = await get(Uri.parse('$host/foobar'));
    expect(response.statusCode, 404);
  }); */
}
