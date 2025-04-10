import 'package:flutter/material.dart';

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO 11: get the counterbloc from the context

    return Scaffold(
      body: Center(child: Text("foobar")),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // TODO 12: dispatch increment event to counterbloc
            },
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () {
              // TODO 13: dispatch decrement event to counterbloc
            },
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
