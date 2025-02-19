import 'package:shared/shared.dart';

class BagRepository implements RepositoryInterface<Bag> {
  // singleton


  final List<Bag> _bags = [];

  @override
  Future<Bag> create(Bag bag) async {
    _bags.add(bag);
    return bag;
  }

  @override
  Future<Bag> getById(String id) async {
    return _bags.firstWhere((e) => e.id == id);
  }

  @override
  Future<List<Bag>> getAll() async => List.from(_bags);

  @override
  Future<Bag> update(String id, Bag newBag) async {
    var index = _bags.indexWhere((e) => e.id == id);
    if (index >= 0 && index < _bags.length) {
      _bags[index] = newBag;
      return newBag;
    }
    throw RangeError.index(index, _bags);
  }

  @override
  Future<Bag> delete(String id) async {
    var index = _bags.indexWhere((e) => e.id == id);
    if (index >= 0 && index < _bags.length) {
      return _bags.removeAt(index);
    }
    throw RangeError.index(index, _bags);
  }
}
