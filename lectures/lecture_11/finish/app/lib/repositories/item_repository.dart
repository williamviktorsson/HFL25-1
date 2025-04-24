import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared/shared.dart';

class ItemRepository implements RepositoryInterface<Item> {
  @override
  Future<Item> getById(String id) async {
    final document =
        await FirebaseFirestore.instance.collection("items").doc(id).get();

    final json = document.data();

    if (json == null) {
      throw Exception("item ${id} not found");
    }

    return Item.fromJson(json);
  }

  @override
  Future<Item> create(Item item) async {
    // send item serialized as json over http to server at localhost:8080

    await FirebaseFirestore.instance
        .collection("items")
        .doc(item.id)
        .set(item.toJson());

    return item;
  }

  @override
  Future<List<Item>> getAll() async {
    final snapshot = await FirebaseFirestore.instance.collection("items").get();

    final documents = snapshot.docs;

    return (documents)
        .map((document) => Item.fromJson(document.data()))
        .toList();
  }

  Stream<List<Item>> subscribe() {
    final snapshots =
        FirebaseFirestore.instance.collection("items").snapshots();

    return snapshots.map((snapshot) {
      final documents = snapshot.docs;
      return documents
          .map((document) => Item.fromJson(document.data()))
          .toList();
    });
  }

  @override
  Future<Item> delete(String id) async {
    final item = await getById(id);

    await FirebaseFirestore.instance.collection("items").doc(id).delete();

    return item;
  }

  @override
  Future<Item> update(String id, Item item) async {
    await FirebaseFirestore.instance
        .collection("items")
        .doc(id)
        .set(item.toJson());

    return item;
  }
}
