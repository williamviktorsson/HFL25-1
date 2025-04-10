import 'package:bloc_examples/blocs/auth_bloc.dart';
import 'package:bloc_examples/blocs/counter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO 11: get the counterbloc from the context

    Count count = context.watch<CounterBloc>().state;

    return Scaffold(
      body: Center(child: Text("${count.count}")),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              context.read<CounterBloc>().add(CounterIncrement());
            },
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () {
              context.read<CounterBloc>().add(CounterDecrement());
            },
            child: const Icon(Icons.remove),
          ),
          FloatingActionButton(
            onPressed: () {
              context.read<AuthBloc>().logout();
            },
            child: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
