import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:uuid/uuid.dart';

class ExampleView extends StatelessWidget {
  const ExampleView({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTileExample();
  }
}

class ListTileExample extends StatelessWidget {
  const ListTileExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Custom List Item Sample')),
        body: Center(
          child: TextButton(
              onPressed: () async {
                final androidDetails = AndroidNotificationDetails(
                  Uuid().v4(),
                  "important_alarms",
                  channelDescription:
                      "Will only send super critical payment alerts on this channel!",
                  importance: Importance.max,
                  priority: Priority.high,
                  color: Colors.amber,
                  when: DateTime.now().add(Duration(seconds: 15)).millisecondsSinceEpoch,
                  usesChronometer: true,
                  chronometerCountDown: true

                );

                NotificationDetails details =
                    NotificationDetails(android: androidDetails,
                    
                    );

                await requestPermissions();

                await notificationPlugin.zonedSchedule(
                    0, // id
                    "Foobar", // title
                    "Klicka på mig", // body
                    tz.TZDateTime.from(DateTime.now().add(Duration(seconds: 2)),
                        tz.local), // when
                    details, // config per platform
                    androidScheduleMode:
                        AndroidScheduleMode.exactAllowWhileIdle);
              },
              child: Text("Show notification")),
        ));
  }
}
