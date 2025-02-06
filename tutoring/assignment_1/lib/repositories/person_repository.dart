import 'package:assignment_1/models/person.dart';
import 'package:assignment_1/models/vehicle.dart';
import 'package:assignment_1/repositories/repository.dart';

class PersonRepository extends AbstractRepository<Person> {
  PersonRepository() {
    super.add(Person(
        personNumber: "asd",
        ownedVehicles: [Vehicle(regNr: "123ABC", id: "asda")],
        id: "id"));
    super.add(Person(personNumber: "asd", ownedVehicles: [], id: "id"));
    super.add(Person(personNumber: "asd", ownedVehicles: [], id: "id"));
    super.add(Person(personNumber: "asd", ownedVehicles: [], id: "id"));
    super.add(Person(personNumber: "asd", ownedVehicles: [], id: "id"));
    super.add(Person(personNumber: "asd", ownedVehicles: [], id: "id"));
    super.add(Person(
        personNumber: "xxx",
        ownedVehicles: [Vehicle(regNr: "regNr", id: "idddd")],
        id: "123"));
  }


}
