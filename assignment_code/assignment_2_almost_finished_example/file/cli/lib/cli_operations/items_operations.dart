import 'dart:io';

import 'package:cli/repositories/item_repository.dart';
import 'package:cli/utils/validator.dart';
import 'package:cli_shared/cli_shared.dart';

ItemRepository repository = ItemRepository();

class ItemsOperations {
  static Future create() async {
    print('Enter description: ');

    var input = stdin.readLineSync();

    if (Validator.isString(input)) {
      Item item = Item(input!);
      await repository.create(item);
      print('Item created');
    } else {
      print('Invalid input');
    }
  }

  static Future list() async {
    var result = await repository.getAll();

    switch (result) {
      case Success<List<Item>, String>(:var data):
        for (int i = 0; i < data.length; i++) {
          print('${i + 1}. ${data[i].description}');
        }
      case Failure(:var error):
        print(error);
    }
  }

  static Future update() async {
    var result = await repository.getAll();

    switch (result) {
      case Success<List<Item>, String>(:var data):
        print('Pick an index to update: ');
        List<Item> allItems = data;
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
            await repository.update(allItems[index].id, item);
            print('Item updated');
          } else {
            print('Invalid input');
          }
        } else {
          print('Invalid input');
        }
      case Failure(:var error):
        print(error);
    }
  }

  static Future delete() async {
    var result = await repository.getAll();

    switch (result) {
      case Success<List<Item>, String>(:var data):
        print('Pick an index to delete: ');
        List<Item> allItems = data;
        for (int i = 0; i < allItems.length; i++) {
          print('${i + 1}. ${allItems[i].description}');
        }

        String? input = stdin.readLineSync();

        if (Validator.isIndex(input, allItems)) {
          int index = int.parse(input!) - 1;
          await repository.delete(allItems[index].id);
          print('Item deleted');
        } else {
          print('Invalid input');
        }
      case Failure(:var error):
        print(error);
    }
  }
}
