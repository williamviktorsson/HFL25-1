import 'dart:io';

import 'package:cli/cli_operations/bags_operations.dart';
import 'package:cli/utils/console.dart';

class BagsMenu {
  static Future prompt() async {
    Console.clear();
    while (true) {
      print('Bags Menu');
      print('1. Create Bag');
      print('2. List all Bags');
      print('3. Update Bag');
      print('4. Delete Bag');
      print('5. Back to Main Menu');

      var input = Console.choice();

      switch (input) {
        case 1:
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


}
