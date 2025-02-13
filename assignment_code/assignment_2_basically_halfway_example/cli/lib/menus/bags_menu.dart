import 'dart:io';

import 'package:cli/cli_operations/bags_operations.dart';
import 'package:cli/utils/console.dart';

enum BagChoices {
  create(1),
  list(2),
  update(3),
  delete(4),
  back(5),
  invalid(-1);

  const BagChoices(this.value);

  factory BagChoices.fromInt(int? value) {
    return switch (value) {
      1 => BagChoices.create,
      2 => BagChoices.list,
      3 => BagChoices.update,
      4 => BagChoices.delete,
      5 => BagChoices.back,
      _ => BagChoices.invalid
    };
  }

  final int value;
}

class BagsMenu {
  static Future prompt() async {
    clearConsole();
    while (true) {
      print('Bags Menu');
      print('1. Create Bag');
      print('2. List all Bags');
      print('3. Update Bag');
      print('4. Delete Bag');
      print('5. Back to Main Menu');

      var input = choice();

      var bagChoice = BagChoices.fromInt(input);

      switch (bagChoice) {
        case BagChoices.create:
          print('Creating Bag');
          await BagsOperations.create();
        case 2:
          print('Listing all Bags');
          await BagsOperations.list();
        case 3:
          print('Updating Bag');
          await BagsOperations.update();
        case 4:
          print('Deleting Bag');
          await BagsOperations.delete();
        case 5:
          return;
        default:
          print('Invalid choice');
      }
      print("\n------------------------------------\n");
    }
  }

  static int? choice() {
    // get user input for choice
    print('Enter choice: ');
    var choice = int.parse(stdin.readLineSync()!);
    return choice;
  }
}
