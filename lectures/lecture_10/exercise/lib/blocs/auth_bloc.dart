import 'package:flutter_bloc/flutter_bloc.dart';

sealed class AuthEvent {}

// TODO 1: Create additional events


sealed class AuthState {}

final class AuthInitial extends AuthState {
  AuthInitial();
}

// TODO 2: Create additional states

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      // TODO 3: handle all events and emit states
    });
  }
}
