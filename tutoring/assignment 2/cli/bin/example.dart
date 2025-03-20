import 'package:cli/models/item.dart';
import 'package:cli/repositories/item_repository.dart';

void main() {
  // Create an instance of ItemRepository
  ItemRepository repository = ItemRepository.instance;

  // Add items to the repository
  repository.create(Item('Item 1'));
  repository.create(Item('Item 2'));
  repository.create(Item('Item 3'));

  // Get all items
  List<Item> allItems = repository.getAll();
  print('All items:');
  allItems.forEach((item) => print(item.description));

  // Get item by index
  Item? item = allItems.elementAt(0);
  print('\nItem at index 0: ${item?.description}');

  Item? item2 = allItems.elementAt(1);

  // Update an item
  Item updatedItem = Item('Updated Item 2', item2.id);
  repository.update(updatedItem.id, updatedItem);

  allItems = repository.getAll();

  print('\nUpdated item at index 1: ${allItems.elementAt(1).description}');

  Item? item3 = allItems.elementAt(2);

  // Delete an item
  repository.delete(item3.id);
  print('\nAll items after deleting item at index 2:');
  allItems = repository.getAll();
  allItems.forEach((item) => print(item.description));
}
