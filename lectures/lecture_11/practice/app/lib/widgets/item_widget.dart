import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.description),
    );
  }
}
