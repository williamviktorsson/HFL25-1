import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkapp/repositories/item_repository.dart';
import 'package:shared/shared.dart';

class ItemsView extends StatefulWidget {
  const ItemsView({super.key});

  @override
  State<ItemsView> createState() => _ItemsViewState();
}

class _ItemsViewState extends State<ItemsView> {
  Future future = ItemRepository().getAll();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].id),
                  subtitle: Text(snapshot.data![index].description),
                  trailing: IconButton(
                    onPressed: () async {
                      await ItemRepository().delete(snapshot.data![index].id);
                      setState(() {
                        future = ItemRepository().getAll();
                      });
                    },
                    icon: Icon(Icons.delete),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Item? created = await showDialog<Item>(
            context: context,
            builder: (context) {
              String description = "";

              return AlertDialog(
                title: Text('Create new item'),
                content: TextField(
                  decoration: InputDecoration(labelText: 'Description'),
                  onChanged: (value) {
                    description = value;
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),

                    child: Text('Cancel'),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, Item(description));
                    },

                    child: Text('Create'),
                  ),
                ],
              );
            },
          );
          if (created != null) {
            // dispatch create item event
            await ItemRepository().create(created);
            setState(() {
              future = ItemRepository().getAll();
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
