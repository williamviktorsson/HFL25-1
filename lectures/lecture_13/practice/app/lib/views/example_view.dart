import 'package:app/services/notification_service.dart';
import 'package:flutter/material.dart';

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
                final ns = await NotificationsService.instance;

                ns.scheduleNotification(
                    title: "App Name",
                    content: "Parking about to expire",
                    deliveryTime: DateTime.now().add(Duration(seconds: 3)),
                    id: 0);
              },
              child: Text("Schedule Notificaiton")),
        ));
  }
}
