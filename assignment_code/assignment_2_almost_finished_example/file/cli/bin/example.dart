import 'package:cli/repositories/item_repository.dart';
import 'package:cli_shared/cli_shared.dart';

void main() async {
  // Create an instance of ItemRepository
  ItemRepository repository = ItemRepository();

  // Add items to the repository
  await repository.create(Item('Item 1'));
  await repository.create(Item('Item 2'));
  await repository.create(Item('Item 3'));

  // Get all items
  var result = await repository.getAll();

  switch (result) {
    case Success<List<Item>, String>(:var data):
      print('All items:');
      data.forEach((item) => print(item.description));

      // Get item by index
      Item? item = data.elementAt(0);
      print('\nItem at index 0: ${item?.description}');

      Item? item2 = data.elementAt(1);

      // Update an item
      Item updatedItem = Item('Updated Item 2', item2.id);
      await repository.update(updatedItem.id, updatedItem);

      break;
    case Failure(:var error):
      print(error);
      break;
  }

  result = await repository.getAll();

  switch (result) {
    case Success<List<Item>, String>(:var data):
      print('\nUpdated item at index 1: ${data.elementAt(1).description}');

      Item? item3 = data.elementAt(2);
      // Delete an item
      await repository.delete(item3.id);

      break;
    case Failure(:var error):
      print(error);
      break;
  }

  print('\nAll items after deleting item at index 2:');
  var Success(:data) = await repository.getAll() as Success;
  data.forEach((item) => print(item.description));
}
