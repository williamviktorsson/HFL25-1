import 'package:uuid/uuid.dart';

import 'item.dart';

class Bag {
  String description;
  List<Item> items;
  String id;

  Bag({required this.description, List<Item>? items, String? id})
      : items = items ?? [],
        id = id ?? Uuid().v4();

  // tojson & fromjson

  factory Bag.fromJson(Map<String, dynamic> json) {
    return Bag(
      description: json['description'],
      items: (json['items'] as List).map((e) => Item.fromJson(e)).toList(),
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "items": items.map((e) => e.toJson()).toList(),
      "id": id,
    };
  }
}
