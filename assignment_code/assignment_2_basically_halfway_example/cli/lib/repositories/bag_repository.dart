import 'dart:convert';
import 'package:cli_shared/cli_shared.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';


class BagRepository implements RepositoryInterface<Bag> {
  @override
  Future<Bag> getById(int id) async {
    final uri = Uri.parse("http://localhost:8080/bags/${id}");

    Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return Bag.fromJson(json);
  }

  @override
  Future<Bag> create(Bag bag) async {
    // send bag serialized as json over http to server at localhost:8080
    final uri = Uri.parse("http://localhost:8080/bags");

    Response response = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bag.toJson()));

    final json = jsonDecode(response.body);

    return Bag.fromJson(json);
  }

  Future<List<Bag>> getAll() async {
    final uri = Uri.parse("http://localhost:8080/bags");
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return (json as List).map((bag) => Bag.fromJson(bag)).toList();
  }

  @override
  Future<Bag> delete(int id) async {
    final uri = Uri.parse("http://localhost:8080/bags/${id}");

    Response response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return Bag.fromJson(json);
  }

  @override
  Future<Bag> update(int id, Bag bag) async {
    // send bag serialized as json over http to server at localhost:8080
    final uri = Uri.parse("http://localhost:8080/bags/${id}");

    Response response = await http.put(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bag.toJson()));

    final json = jsonDecode(response.body);

    return Bag.fromJson(json);
  }
}
