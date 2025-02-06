import 'package:assignment_1/models/vehicle.dart';
import 'package:assignment_1/repositories/repository.dart';

class Person extends Identifyable {
  final String personNumber;
  final List<Vehicle> ownedVehicles;

  @override
  final String id;

  Person({
    required this.personNumber,
    required this.ownedVehicles,
    required this.id,
  });

  @override
  String toString() {
    // TODO: implement toString
    return personNumber + " - " + id + " - "  + ownedVehicles.map((e)=>e.toString()).join(", ");
  }

}
