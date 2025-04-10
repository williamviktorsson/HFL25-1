import 'package:bloc_examples/blocs/auth_bloc.dart';
import 'package:bloc_examples/blocs/counter_bloc.dart';
import 'package:bloc_examples/blocs/weather_bloc.dart';
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
  runApp(BlocProvider(create: (context) => AuthBloc(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AuthState state = context.watch<AuthBloc>().state;

    return MaterialApp(
      title: 'Bloc Examples',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      home: switch (state) {
        AuthPending() => const Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        AuthSuccess() => const SignedInView(),
        AuthSignedOut() || AuthInitial() => const SignedOutView(),
        AuthFail() => Center(
            child: Text(state.error),
          ),
      },
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
          context.read<AuthBloc>().login("william");
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
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => WeatherBloc()),
      BlocProvider(create: (context) => CounterBloc())
    ], child: LandingPage());
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
