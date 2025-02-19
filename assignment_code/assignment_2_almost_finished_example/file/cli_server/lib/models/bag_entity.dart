import 'package:cli_server/repositories/item_repository.dart';
import 'package:cli_shared/cli_shared.dart';
import 'package:equatable/equatable.dart';

class BagEntity extends Equatable {
  final String description;

  final List<String> itemIds;

  final String id;

  BagEntity(
      {required this.description, required this.itemIds, required this.id});

  factory BagEntity.fromJson(Map<String, dynamic> json) {
    return BagEntity(
        description: json['description'],
        id: json['id'],
        itemIds: (json['itemIds'] as List).map((e) => e as String).toList());
  }

  Map<String, dynamic> toJson() {
    return {"description": description, "id": id, 'itemIds': itemIds};
  }

  @override
  List<Object?> get props => [description, itemIds, id];
}

extension EntityConverter on Bag {
  BagEntity toBagEntity() {
    return BagEntity(
        description: description,
        id: id,
        itemIds: items.map((e) => e.id).toList());
  }
}

extension ModelConverter on BagEntity {
  Future<Bag> toBag() async {
    ItemRepository repository = const ItemRepository();
    final items = await Future.wait(itemIds.map((e) => repository.getById(e)));
    return Bag(description: description, id: id, items: items);
  }
}
