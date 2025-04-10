import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class CounterEvent {}

class CounterIncrement extends CounterEvent {}

class CounterDecrement extends CounterEvent {}

class Count {
  final int count;
  const Count(this.count);
}

class CounterBloc extends Bloc<CounterEvent, Count> {
  CounterBloc() : super(const Count(0)) {
    on<CounterIncrement>((event, emit) {
      emit(Count(state.count + 1));
    });
    on<CounterDecrement>((event, emit) {
      emit(Count(state.count - 1));
    });
  }
}
