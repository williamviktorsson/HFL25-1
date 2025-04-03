import 'package:flutter/material.dart';
import 'package:parkapp/views/example_view.dart';

class BagsView extends StatelessWidget {
  const BagsView({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        Navigator.push(
          context,

          MaterialPageRoute(builder: (context) => ExampleView()),
        );
      },
      child: Text("Go to new route!"),
    );
  }
}
