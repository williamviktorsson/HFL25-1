import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import 'item.dart';


class Bag extends Equatable {
  String description;

  List<Item> items;

  String id;

  Bag(
      {required this.description,
      this.items = const [],
      String? id})
      : id = id ?? Uuid().v4();

  factory Bag.fromJson(Map<String, dynamic> json) {
    return Bag(
        description: json['description'],
        id: json['id'],
        items:
            (json['items'] as List).map((json) => Item.fromJson(json)).toList(),
       );
  }

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "id": id,
      'items': items.map((item) => item.toJson()).toList(),
     
    };
  }

  @override
  List<Object?> get props => [description, items, id];
}
