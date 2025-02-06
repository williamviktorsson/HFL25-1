import 'dart:io';

import 'package:assignment_1/repositories/person_repository.dart';

void main(List<String> arguments) {
  var repo = PersonRepository();
  print(repo.getAll());

  print(repo.getById("123"));

}

String? prompt(String prompt) {
  stdout.write(prompt);
  final input = stdin.readLineSync();
  return input;
  // comment
}
