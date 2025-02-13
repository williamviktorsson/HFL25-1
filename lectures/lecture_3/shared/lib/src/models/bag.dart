import 'item.dart';

class Bag {
  String description;
  List<Item> items;
  int id;

  Bag({required this.description, List<Item>? items, this.id = -1})
      : items = items ?? [];

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
