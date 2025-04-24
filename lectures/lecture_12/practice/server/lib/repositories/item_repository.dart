import 'package:server/repositories/file_repository.dart';
import 'package:shared/shared.dart';

class ItemRepository extends FileRepository<Item> {
  ItemRepository() : super('items.json');

  @override
  Item fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    return Item.fromJson(json);
  }

  @override
  String idFromType(Item item) {
    // TODO: implement idFromType
    return item.id;
  }

  @override
  Map<String, dynamic> toJson(Item item) {
    // TODO: implement toJson
    return item.toJson();
  }
}