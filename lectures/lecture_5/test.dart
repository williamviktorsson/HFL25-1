import 'dart:async';
import 'dart:isolate';

// Funktion som körs i en separat isolate

void generateDataStream(dynamic list) async {
  var sendPort = list[0];
  Future(() async {
    for (int i = 1; i <= 10; i++) {
      await Future.delayed(Duration(milliseconds: 200));

      // Skicka data kontinuerligt tillbaka till main isolate

      sendPort.send(i);
    }
  });

  await for (final data in receivePort) {
    if (data == 10) {
      print('Dataström komplett');

      break;
    }

    print('Mottog data i isolate: ' + data.toString());
  }
}

final receivePort = ReceivePort();

void main() async {
  print('Startar dataström från separat isolate...');

  final isolate =
      await Isolate.spawn(generateDataStream, [receivePort.sendPort]);

  // Lyssna på kontinuerlig dataström

  await for (final data in receivePort) {
    if (data == 10) {
      print('Dataström komplett');

      break;
    }

    print('Mottog data: ' + data.toString());
  }

  // Städa upp

  receivePort.close();

  isolate.kill();
}
