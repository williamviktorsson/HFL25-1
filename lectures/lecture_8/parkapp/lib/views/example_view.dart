import 'package:flutter/material.dart';

class ExampleView extends StatelessWidget {
  const ExampleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.deepOrangeAccent,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Go back!"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
