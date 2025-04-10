
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class CounterEvent {}

// TODO 9: add appropriate events

class Count {
  final int count;
  const Count(this.count);
}

// TODO 9: add appropriate events

class CounterBloc extends Bloc<CounterEvent, Count> {
  CounterBloc() : super(const Count(0)) {

    // TODO 10: handle all events and emit states

  }
}
