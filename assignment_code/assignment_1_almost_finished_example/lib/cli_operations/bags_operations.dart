import 'dart:io';

import 'package:cli/models/bag.dart';
import 'package:cli/models/item.dart';
import 'package:cli/repositories/bag_repository.dart';
import 'package:cli/repositories/item_repository.dart';
import 'package:cli/utils/validator.dart';

BagRepository repository = BagRepository.instance;

class BagsOperations {
  static create() {
    print('Enter description: ');

    var input = stdin.readLineSync();

    if (Validator.isString(input)) {
      Bag bag = Bag(description: input!);
      repository.create(bag);
      print('Bag created');
    } else {
      print('Invalid input');
    }
  }

  static list() {
    List<Bag> allBags = repository.getAll();
    for (int i = 0; i < allBags.length; i++) {
      print(
          '${i + 1}. ${allBags[i].description} - [${allBags[i].items.map((e) => e.description).join(', ')}]');
    }
  }

  static update() {
    print('Pick an index to update: ');
    List<Bag> allBags = repository.getAll();
    for (int i = 0; i < allBags.length; i++) {
      print('${i + 1}. ${allBags[i].description}');
    }

    String? input = stdin.readLineSync();

    if (Validator.isIndex(input, allBags)) {
      int index = int.parse(input!) - 1;

      while (true) {
        print("\n------------------------------------\n");

        Bag bag = repository.getById(allBags[index].id);

        print(
            "What would you like to update in bag: ${bag.description} - [${bag.items.map((e) => e.description).join(", ")}]?");
        print('1. Update description');
        print('2. Add items to bag');
        print('3. Remove items from bag');

        var input = stdin.readLineSync();

        if (Validator.isNumber(input)) {
          int choice = int.parse(input!);

          switch (choice) {
            case 1:
              _updateDescription(bag);
            case 2:
              _addItemsToBag(bag);
            case 3:
              _removeItemsFromBag(bag);
            default:
              print('Invalid choice');
          }
        } else {
          print('Invalid input');
        }
        print("Would you like to update anything else? (y/n)");
        input = stdin.readLineSync();
        if (input == 'n') {
          break;
        }
      }
    } else {
      print('Invalid input');
    }
  }

  static _updateDescription(Bag bag) {
    print('Enter new description: ');
    var description = stdin.readLineSync();

    if (Validator.isString(description)) {
      bag.description = description!;
      repository.update(bag.id, bag);
      print('Bag updated');
    } else {
      print('Invalid input');
    }
  }

  static _addItemsToBag(Bag bag) {
    // list all items and pick an item to add

    List<Item> allItems = ItemRepository.instance.getAll();

    print('Pick an item to add: ');

    for (int i = 0; i < allItems.length; i++) {
      print('${i + 1}. ${allItems[i].description}');
    }

    var input = stdin.readLineSync();

    if (Validator.isIndex(input, allItems)) {
      int index = int.parse(input!) - 1;
      bag.items.add(allItems[index]);
      repository.update(bag.id, bag);
      print('Item added to bag');
    } else {
      print('Invalid input');
    }
  }

  static _removeItemsFromBag(Bag bag) {
    print('Pick an item to remove: ');
    for (int i = 0; i < bag.items.length; i++) {
      print('${i + 1}. ${bag.items[i].description}');
    }

    String? input = stdin.readLineSync();

    if (Validator.isIndex(input, bag.items)) {
      int index = int.parse(input!) - 1;
      bag.items.removeAt(index);
      repository.update(bag.id, bag);
      print('Item removed from bag');
    } else {
      print('Invalid input');
    }
  }

  static delete() {
    print('Pick an index to delete: ');
    List<Bag> allBags = repository.getAll();
    for (int i = 0; i < allBags.length; i++) {
      print('${i + 1}. ${allBags[i].description}');
    }

    String? input = stdin.readLineSync();

    if (Validator.isIndex(input, allBags)) {
      int index = int.parse(input!) - 1;
      repository.delete(allBags[index].id);
      print('Bag deleted');
    } else {
      print('Invalid input');
    }
  }
}
