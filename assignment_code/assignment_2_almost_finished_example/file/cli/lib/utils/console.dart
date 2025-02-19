import 'dart:io';

class Console {
  static void clear() {
    //https://stackoverflow.com/questions/21269769/clearing-the-terminal-screen-in-a-command-line-dart-app
    stdout.write('\x1B[2J\x1B[0;0H');
  }

  static int? choice() {
    // get user input for choice
    print('Enter choice: ');
    var choice = int.tryParse(stdin.readLineSync() ?? "foobar");
    return choice;
  }
}
