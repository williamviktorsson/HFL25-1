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

    if (document.data() == null) {
      throw Exception("data not found");
    }

    return Item.fromJson(document.data()!);
  }

  @override
  Future<Item> create(Item item) async {
    await FirebaseFirestore.instance
        .collection("items")
        .doc(item.id)
        .set(item.toJson());

    return item;
  }

  @override
  Future<List<Item>> getAll() async {
    final documents =
        await FirebaseFirestore.instance.collection("items").get();

    return (documents.docs).map((doc) => Item.fromJson(doc.data())).toList();
  }

  Stream<List<Item>> subscribe() {
    final snapshots =
        FirebaseFirestore.instance.collection("items").snapshots();

    return snapshots.map(
      (snapshot) {
        return (snapshot.docs).map((doc) => Item.fromJson(doc.data())).toList();
      },
    );
  }

  @override
  Future<Item> delete(String id) async {
    final document =
        await FirebaseFirestore.instance.collection("items").doc(id).get();

    if (document.data() == null) {
      throw Exception("data not found");
    }

    final item = Item.fromJson(document.data()!);
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
