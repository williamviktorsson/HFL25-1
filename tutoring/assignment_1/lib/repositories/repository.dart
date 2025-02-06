// Abstrakt klass kan ha metodimplementationer men kan inte instansieras.

// Endast konkreta klasser som ärver från Repository kan skapas.

abstract class Identifyable {
  String get id;
}

abstract class AbstractRepository<T extends Identifyable> {
  final List<T> _items = [];

  void add(T item) => _items.add(item);

  List<T> getAll() => _items;

  void update(T item, T newItem) {
    var index = _items.indexWhere((element) => element == item);

    _items[index] = newItem;
  }

  void delete(T item) => _items.remove(item);

  T? getById(String id) {
    for (var item in _items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }
}
