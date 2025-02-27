import 'dart:isolate';

// Funktion som körs i en separat isolate
void generateDataStream(SendPort sendPort) async {
  for (int i = 1; i <= 10; i++) {
    await Future.delayed(Duration(milliseconds: 200));

    // Skicka data kontinuerligt tillbaka till main isolate
    sendPort.send(i);
  }
}

void main() async {
  final receivePort = ReceivePort();

  print('Startar dataström från separat isolate...');

  final isolate = await Isolate.spawn(generateDataStream, receivePort.sendPort);

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
