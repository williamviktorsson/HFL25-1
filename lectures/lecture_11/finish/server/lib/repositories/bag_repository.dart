import 'package:server/models/bag_entity.dart';
import 'package:server/repositories/file_repository.dart';

class BagRepository extends FileRepository<BagEntity> {
  BagRepository() : super('bags.json');

  @override
  BagEntity fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    return BagEntity.fromJson(json);
  }

  @override
  String idFromType(BagEntity bag) {
    // TODO: implement idFromType
    return bag.id;
  }

  @override
  Map<String, dynamic> toJson(BagEntity bag) {
    // TODO: implement toJson
    return bag.toJson();
  }
}
