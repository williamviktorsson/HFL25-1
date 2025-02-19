import 'package:uuid/uuid.dart';

import 'item.dart';

class Brand {
  String id;
  String name;
  Brand({required this.name, String? id}) : id = id ?? Uuid().v4();

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      name: json['name'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "id": id,
    };
  }
}

class Bag {
  String description;

  List<Item> items;

  Brand
      brand; // make nullable because we cant assign it in the constructor when creating from database

  String id;

  Bag(
      {required this.description,
      this.items = const [],
      required this.brand,
      String? id})
      : id = id ?? Uuid().v4();

  factory Bag.fromJson(Map<String, dynamic> json) {
    return Bag(
        description: json['description'],
        id: json['id'],
        items:
            (json['items'] as List).map((json) => Item.fromJson(json)).toList(),
        brand: Brand.fromJson(json['brand']));
  }

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "id": id,
      'items': items.map((item) => item.toJson()).toList(),
      'brand': brand.toJson()
    };
  }
}
