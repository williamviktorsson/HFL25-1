import 'package:flutter/material.dart';

class ExampleView extends StatelessWidget {
  const ExampleView({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTileExample();
  }
}

class ListTileExample extends StatefulWidget {
  const ListTileExample({super.key});

  @override
  State<ListTileExample> createState() => _ListTileExampleState();
}

class _ListTileExampleState extends State<ListTileExample> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom List Item Sample')),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('Item $index'),
            selected: index == _selectedIndex,
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
          );
        },
      ),
    );
  }
}
