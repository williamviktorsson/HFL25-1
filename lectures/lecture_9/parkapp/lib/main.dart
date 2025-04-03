import 'package:flutter/material.dart';
import 'package:parkapp/views/bags_view.dart';
import 'package:parkapp/views/home_view.dart';
import 'package:parkapp/views/items_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

enum AuthStatus { unauthenticated, authenticated, loading }

class AuthService extends ChangeNotifier {
  AuthStatus _status = AuthStatus.unauthenticated;

  AuthStatus get status => _status;

  void login() async {
    _status = AuthStatus.loading;
    notifyListeners();

    await Future.delayed(Duration(milliseconds: 200));

    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  void logout() async {
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: ChangeNotifierProvider(
        create: (context) => AuthService(),
        child: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  final ValueNotifier<int> _index = ValueNotifier<int>(1);

  final views = [CounterWidget(), ItemsView(), BagsView()];

  @override
  Widget build(BuildContext context) {
    // Provider, bloc, streams & events

    // watch for state changes on Counter

    AuthService authService = context.watch<AuthService>();

    switch (authService.status) {
      case AuthStatus.unauthenticated:
        return Material(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    authService.login();
                  },
                  child: Text("Log in"),
                ),
              ],
            ),
          ),
        );

      case AuthStatus.loading:
        return Material(child: Center(child: CircularProgressIndicator()));

      case _:
        return ChangeNotifierProvider<Counter>(
          create: (_) => Counter(),

          child: ValueListenableBuilder(
            valueListenable: _index,
            builder: (context, value, _) {
              return LayoutBuilder(
                builder: (context, constarints) {
                  bool isMobile = constarints.maxWidth < 600;

                  return isMobile
                      ? Scaffold(
                        body: Center(
                          // Center is a layout widget. It takes a single child and positions it
                          // in the middle of the parent.
                          child: IndexedStack(index: value, children: views),
                        ),

                        bottomNavigationBar: BottomNavigationBar(
                          currentIndex: value,
                          onTap: (index) {
                            // index is the index of the clicked navbar item
                            _index.value = index;
                          },
                          items: [
                            BottomNavigationBarItem(
                              icon: Icon(Icons.home),
                              label: 'Home',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.shelves),
                              label: 'Items',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.shopping_bag),
                              label: 'Bags',
                            ),
                          ],
                        ),
                      )
                      : Material(
                        child: Row(
                          children: [
                            NavigationRail(
                              extended: constarints.maxWidth > 800,
                              destinations: [
                                NavigationRailDestination(
                                  icon: Icon(Icons.home),
                                  label: Text('Home'),
                                ),
                                NavigationRailDestination(
                                  icon: Icon(Icons.shelves),
                                  label: Text('Items'),
                                ),
                                NavigationRailDestination(
                                  icon: Icon(Icons.shopping_bag),
                                  label: Text('Bags'),
                                ),
                              ],
                              selectedIndex: value,
                              onDestinationSelected: (index) {
                                // index is the index of the clicked navbar item
                                _index.value = index;
                              },
                            ),
                            VerticalDivider(),
                            Expanded(
                              child: Center(
                                // Center is a layout widget. It takes a single child and positions it
                                // in the middle of the parent.
                                child: IndexedStack(
                                  index: value,
                                  children: views,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                },
              );
            },
          ),
        );
    }
  }
}

// ChangeNotifier för state-uppdateringar

class Counter extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;

    notifyListeners();
  }

  void decrement() {
    _count--;

    notifyListeners();
  }
}

// Skapa provider

// Användning i widget

class CounterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Lyssnar på Counter ändringar

    final counter = context.watch<Counter>();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<AuthService>().logout();
        },
        label: Text("logout"),
      ),
      body: Column(
        children: [
          Text(counter.count.toString()),

          ElevatedButton(
            onPressed: () {
              // Läser Counter utan att lyssna

              context.read<Counter>().increment();
            },

            child: Text('Öka'),
          ),
        ],
      ),
    );
  }
}
