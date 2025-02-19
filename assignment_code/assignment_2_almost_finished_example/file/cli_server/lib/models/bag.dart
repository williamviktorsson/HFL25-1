import 'package:cli_server/repositories/item_repository.dart';
import 'package:cli_shared/cli_shared.dart';

class BagFactory {
  static Future<Bag> fromJsonServer(Map<String, dynamic> json) async {
    // Gå igenom itemIds och hämta rätt item för detta id för att undvika duplicerad kod.

    return Bag(
        description: json['description'],
        id: json['id'],
        items: (await Future.wait((json['itemIds'] as List)
                .map((id) => ItemRepository().getById(id))
                .toList()))
            .whereType<Success<Item, String>>()
            .map((result) => result.data)
            .toList(),
        brand: Brand.fromJson(json['brand']));
  }

  static Map<String, dynamic> toJsonServer(Bag bag) {
    // specifik lagring på servern. Lagra endast id till items och hämta sedan rätt ITEM när bags deserialiseras

    return {
      "description": bag.description,
      "id": bag.id,
      'itemIds': bag.items.map((item) => item.id).toList(),
      'brand': bag.brand.toJson()
    };
  }
}
