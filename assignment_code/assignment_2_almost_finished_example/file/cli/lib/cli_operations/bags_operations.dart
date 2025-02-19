import 'dart:io';

import 'package:cli/repositories/bag_repository.dart';
import 'package:cli/repositories/item_repository.dart';
import 'package:cli/utils/validator.dart';
import 'package:cli_shared/cli_shared.dart';

BagRepository repository = BagRepository();

class BagsOperations {
  static Future create() async {
    print('Enter description: ');

    var input = stdin.readLineSync();

    if (Validator.isString(input)) {
      Bag bag = Bag(description: input!, brand: Brand(name: "Boogle"));
      await repository.create(bag);
      print('Bag created');
    } else {
      print('Invalid input');
    }
  }

  static Future list() async {
    var result = await repository.getAll();

    switch (result) {
      case Success(:var data):
        for (int i = 0; i < data.length; i++) {
          print(
              '${i + 1}. ${data[i].description} - [${data[i].items.map((e) => e.description).join(', ')}]');
        }
        break;
      case Failure(:var error):
        print(error);
        break;
    }
  }

  static Future update() async {
    var result = await repository.getAll();

    switch (result) {
      case Success(:var data):
        print('Pick an index to update: ');
        List<Bag> allBags = data;
        for (int i = 0; i < allBags.length; i++) {
          print('${i + 1}. ${allBags[i].description}');
        }

        String? input = stdin.readLineSync();

        if (Validator.isIndex(input, allBags)) {
          int index = int.parse(input!) - 1;

          while (true) {
            print("\n------------------------------------\n");

            var result = await repository.getById(allBags[index].id);

            switch (result) {
              case Success(:var data):
                Bag bag = data;

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
                      await _updateDescription(bag);
                    case 2:
                      await _addItemsToBag(bag);
                    case 3:
                      await _removeItemsFromBag(bag);
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
              case Failure(:var error):
                print(error);
            }
          }
        } else {
          print('Invalid input');
        }

      case Failure(:var error):
        print(error);
    }
  }

  static Future _updateDescription(Bag bag) async {
    print('Enter new description: ');
    var description = stdin.readLineSync();

    if (Validator.isString(description)) {
      bag.description = description!;
      await repository.update(bag.id, bag);
      print('Bag updated');
    } else {
      print('Invalid input');
    }
  }

  static Future _addItemsToBag(Bag bag) async {
    // list all items and pick an item to add

    var result = await ItemRepository().getAll();

    switch (result) {
      case Success(:var data):
        var allItems = data;
        print('Pick an item to add: ');

        for (int i = 0; i < allItems.length; i++) {
          print('${i + 1}. ${allItems[i].description}');
        }

        var input = stdin.readLineSync();

        if (Validator.isIndex(input, allItems)) {
          int index = int.parse(input!) - 1;
          bag.items.add(allItems[index]);
          await repository.update(bag.id, bag);
          print('Item added to bag');
        } else {
          print('Invalid input');
        }
      case Failure(:var error):
        print(error);
    }
  }

  static Future _removeItemsFromBag(Bag bag) async {
    print('Pick an item to remove: ');
    for (int i = 0; i < bag.items.length; i++) {
      print('${i + 1}. ${bag.items[i].description}');
    }

    String? input = stdin.readLineSync();

    if (Validator.isIndex(input, bag.items)) {
      int index = int.parse(input!) - 1;
      bag.items.removeAt(index);
      await repository.update(bag.id, bag);
      print('Item removed from bag');
    } else {
      print('Invalid input');
    }
  }

  static Future delete() async {
    var result = await repository.getAll();

    switch (result) {
      case Success(:var data):
        print('Pick an index to delete: ');
        List<Bag> allBags = data;
        for (int i = 0; i < allBags.length; i++) {
          print('${i + 1}. ${allBags[i].description}');
        }

        String? input = stdin.readLineSync();

        if (Validator.isIndex(input, allBags)) {
          int index = int.parse(input!) - 1;
          await repository.delete(allBags[index].id);
          print('Bag deleted');
        } else {
          print('Invalid input');
        }
      case Failure(:var error):
        print(error);
    }
  }
}
