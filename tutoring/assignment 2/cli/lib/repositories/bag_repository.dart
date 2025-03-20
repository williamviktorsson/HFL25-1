import 'package:cli/models/bag.dart';
import 'package:cli/repositories/repository_interface.dart';

class BagRepository implements RepositoryInterface<Bag> {
  // singleton

  BagRepository._internal();

  static final BagRepository _instance = BagRepository._internal();

  static BagRepository get instance => _instance;

  final _bags = [];

  @override
  Bag create(Bag bag) {
    if (bag.id < 0) {
      bag.id = _bags.length;
    }
    _bags.add(bag);
    return bag;
  }

  @override
  Bag getById(int id) {
    return _bags.firstWhere((e) => e.id == id);
  }

  @override
  List<Bag> getAll() => List.from(_bags);

  @override
  Bag update(int id, Bag newBag) {
    var index = _bags.indexWhere((e) => e.id == id);
    if (index >= 0 && index < _bags.length) {
      _bags[index] = newBag;
      return newBag;
    }
    throw RangeError.index(index, _bags);
  }

  @override
  Bag delete(int id) {
    var index = _bags.indexWhere((e) => e.id == id);
    if (index >= 0 && index < _bags.length) {
      return _bags.removeAt(index);
    }
    throw RangeError.index(index, _bags);
  }
}
