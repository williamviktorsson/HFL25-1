import 'dart:io';

import 'package:cli_server/handlers/bag_handlers.dart';
import 'package:cli_server/handlers/item_handlers.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ServerConfig {
  // singleton constructor

  ServerConfig._privateConstructor() {
    initialize();
  }

  static final ServerConfig _instance = ServerConfig._privateConstructor();

  static ServerConfig get instance => _instance;

  late Router router;

  late Database db;

  Future initialize() async {
    // Configure routes.
    router = Router();

    sqfliteFfiInit();

    var databaseFactory = databaseFactoryFfi;

    db = await databaseFactory.openDatabase(
      '${Directory.current.path}/db.sqlite',
    );

    db.execute('''
      CREATE TABLE IF NOT EXISTS items (
        id TEXT PRIMARY KEY,
        blob TEXT
      )
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS bags (
        id TEXT PRIMARY KEY,
        blob TEXT
      )
    ''');

    router.post('/items', postItemHandler); // create an item
    router.get('/items', getItemsHandler); // get all items
    router.get('/items/<id>', getItemHandler); // get specific item
    router.put('/items/<id>', updateItemHandler); // update specific item
    router.delete('/items/<id>', deleteItemHandler); // update specific item

    router.post('/bags', postBagHandler); // create a bag
    router.get('/bags', getBagsHandler); // get all bags
    router.get('/bags/<id>', getBagHandler); // get specific bag
    router.put('/bags/<id>', updateBagHandler); // update specific bag
    router.delete('/bags/<id>', deleteBagHandler); // update specific bag
  }
}
