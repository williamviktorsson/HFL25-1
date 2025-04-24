import 'dart:convert';
import 'dart:io';

import 'package:shared/shared.dart';

abstract class FileRepository<T> implements RepositoryInterface<T> {
  final String filePath;

  FileRepository(this.filePath);

  T fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson(T item);

  String idFromType(T item);

  Future<List<T>> readFile() async {
    final file = File(filePath);

    if (!await file.exists()) {
      await file.writeAsString('[]');

      return [];
    }

    final content = await file.readAsString();

    final List<dynamic> jsonList = jsonDecode(content);

    return jsonList.map((json) => fromJson(json)).toList();
  }

  // Skriver till fil

  Future<void> writeFile(List<T> items) async {
    final file = File(filePath);

    final jsonList = items.map((item) => toJson(item)).toList();

    await file.writeAsString(jsonEncode(jsonList));
  }

  @override
  Future<T> create(T item) async {
    var items = await readFile();
    items.add(item);
    await writeFile(items);
    return item;
  }

  @override
  Future<List<T>> getAll() async {
    var items = await readFile();
    return items;
  }

  @override
  Future<T?> getById(String id) async {
    var items = await readFile();
    for (var item in items) {
      if (idFromType(item) == id) {
        return item;
      }
    }
    return null;
  }

  @override
  Future<T> update(String id, T newItem) async {
    var items = await readFile();
    for (var i = 0; i < items.length; i++) {
      if (idFromType(items[i]) == id) {
        items[i] = newItem;
        await writeFile(items);
        return newItem;
      }
    }
    throw Exception('Item not found');
  }

  @override
  Future<T> delete(String id) async {
    var items = await readFile();

    // sort items remove idFromType == id
    var index = items.indexWhere((item) => idFromType(item) == id);
    if (index == -1) {
      throw Exception('Item not found');
    } else {
      var item = items.removeAt(index);
      await writeFile(items);
      return item;
    }
  }
}
