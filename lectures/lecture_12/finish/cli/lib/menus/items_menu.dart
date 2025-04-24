import 'dart:io';

import 'package:cli/cli_operations/items_operations.dart';
import 'package:cli/utils/console.dart';

class ItemsMenu {
  static Future prompt() async {
    clearConsole();
    while (true) {
      print('Items Menu');
      print('1. Create Item');
      print('2. List all Items');
      print('3. Update Item');
      print('4. Delete Item');
      print('5. Back to Main Menu');

      var input = choice();

      switch (input) {
        case 1:
          print('Creating Item');
          await ItemsOperations.create();
        case 2:
          print('Listing all Items');
          await ItemsOperations.list();
        case 3:
          print('Updating Item');
          await ItemsOperations.update();
        case 4:
          print('Deleting Item');
          await ItemsOperations.delete();
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
