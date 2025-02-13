import 'dart:io';

import 'package:cli/repositories/item_repository.dart';
import 'package:cli/utils/validator.dart';
import 'package:shared/shared.dart';

ItemRepository repository = ItemRepository.instance;

class ItemsOperations {
  static Future create() async {
    print('Enter description: ');

    var input = stdin.readLineSync();

    if (Validator.isString(input)) {
      Item item = Item(input!);
      Item returned = await repository.create(item);
      print('Item created: ${returned.id}');
    } else {
      print('Invalid input');
    }
  }

  static list() async {
    List<Item> allItems = await repository.getAll();
    for (int i = 0; i < allItems.length; i++) {
      print('${i + 1}. ${allItems[i].description}');
    }
  }

  static update() async {
    print('Pick an index to update: ');
    List<Item> allItems = await repository.getAll();
    for (int i = 0; i < allItems.length; i++) {
      print('${i + 1}. ${allItems[i].description}');
    }

    String? input = stdin.readLineSync();

    if (Validator.isIndex(input, allItems)) {
      int index = int.parse(input!) - 1;
      Item item = allItems[index];

      print('Enter new description: ');
      var description = stdin.readLineSync();

      if (Validator.isString(description)) {
        item.description = description!;
        repository.update(allItems[index].id, item);
        print('Item updated');
      } else {
        print('Invalid input');
      }
    } else {
      print('Invalid input');
    }
  }

  static delete() async {
    print('Pick an index to delete: ');
    List<Item> allItems = await repository.getAll();
    for (int i = 0; i < allItems.length; i++) {
      print('${i + 1}. ${allItems[i].description}');
    }

    String? input = stdin.readLineSync();

    if (Validator.isIndex(input, allItems)) {
      int index = int.parse(input!) - 1;
      repository.delete(allItems[index].id);
      print('Item deleted');
    } else {
      print('Invalid input');
    }
  }
}
