import 'package:server/repositories/item_repository.dart';
import 'package:shared/shared.dart';

class BagEntity {
  final String description;
  final List<String> itemIds;
  final String id;

  BagEntity(
      {required this.description, required this.itemIds, required this.id});

  // tojson & fromjson

  factory BagEntity.fromJson(Map<String, dynamic> json) {
    return BagEntity(
      description: json['description'],
      itemIds: (json['itemIds'] as List).map((e) => e as String).toList(),
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "itemIds": itemIds,
      "id": id,
    };
  }

  Future<Bag> toModel() async {
    final items =
        await Future.wait(itemIds.map((id) => ItemRepository().getById(id)));
    return Bag(
        description: description, items: items.nonNulls.toList(), id: id);
  }
}

extension EntityCoversion on Bag {
  BagEntity toEntity() {
    return BagEntity(
        description: description,
        itemIds: items.map((item) => item.id).toList(),
        id: id);
  }
}
