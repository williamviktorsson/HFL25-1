import 'package:cli_shared/cli_shared.dart';

class BagRepository implements RepositoryInterface<Bag> {
  final _bags = [];

  @override
  Future<Bag> create(Bag bag) async {
    if (bag.id < 0) {
      bag.id = _bags.length;
    }
    _bags.add(bag);
    return bag;
  }

  @override
  Future<Bag> getById(int id) async {
    return _bags.firstWhere((e) => e.id == id);
  }

  @override
  Future<List<Bag>> getAll() async => List.from(_bags);

  @override
  Future<Bag> update(int id, Bag newBag) async {
    var index = _bags.indexWhere((e) => e.id == id);
    if (index >= 0 && index < _bags.length) {
      _bags[index] = newBag;
      return newBag;
    }
    throw RangeError.index(index, _bags);
  }

  @override
  Future<Bag> delete(int id) async {
    var index = _bags.indexWhere((e) => e.id == id);
    if (index >= 0 && index < _bags.length) {
      return _bags.removeAt(index);
    }
    throw RangeError.index(index, _bags);
  }
}
