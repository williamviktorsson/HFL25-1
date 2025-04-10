
import 'package:bloc_examples/views/counter_view.dart';
import 'package:bloc_examples/views/weather_api_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }
}

void main() {
  Bloc.observer = SimpleBlocObserver();
  // TODO 6: inject the authbloc into the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO 4: watch AuthBloc state and show appropriate view
    // TODO 5: run the app

    return MaterialApp(
      title: 'Bloc Examples',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      home: const SignedInView(),
    );
  }
}

class SignedOutView extends StatelessWidget {
  const SignedOutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
        onPressed: () {
          // TODO 7: dispatch sign in event to authbloc
        },
        child: const Text("Login"),
      ),
    ));
  }
}

class SignedInView extends StatelessWidget {
  const SignedInView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    // TODO 8: inject all blocs into the app

    return  LandingPage();
  }
}

class LandingPage extends StatelessWidget {
  LandingPage({super.key});

  final List<Widget> views = const [
    CounterView(),
    WeatherAPIView(),
  ];

  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);

  final List<BottomNavigationBarItem> bottomItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.calculate_outlined),
      label: "Counter",
    ),

    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: "Weather API",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: _selectedIndex,
        builder: (context, index, child) {
          return Scaffold(
              body: views[index],
              bottomNavigationBar: BottomNavigationBar(
                items: bottomItems,
                currentIndex: index,
                onTap: (int index) {
                  _selectedIndex.value = index;
                },
              ));
        });
  }
}
