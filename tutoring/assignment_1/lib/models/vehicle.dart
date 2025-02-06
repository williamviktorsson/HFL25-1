import 'package:assignment_1/repositories/repository.dart';

class Vehicle extends Identifyable {
  final String regNr;

  @override
  final String id;

  Vehicle({required this.regNr, required this.id});

  @override
  String toString() {
    // TODO: implement toString
    return id + " - " + regNr;
  }
}
