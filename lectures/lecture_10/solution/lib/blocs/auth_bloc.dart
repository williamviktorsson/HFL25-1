import 'package:flutter_bloc/flutter_bloc.dart';

sealed class AuthEvent {}

class AuthLogin extends AuthEvent {
  final String name;

  AuthLogin({required this.name});
}

class AuthLogout extends AuthEvent {}

sealed class AuthState {}

final class AuthInitial extends AuthState {
  AuthInitial();
}

final class AuthPending extends AuthState {}

final class AuthSuccess extends AuthState {
  final String name;

  AuthSuccess({required this.name});
}

final class AuthSignedOut extends AuthState {
  AuthSignedOut();
}

final class AuthFail extends AuthState {
  final String error;

  AuthFail({required this.error});
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      switch (event) {
        case AuthLogin():
          emit(AuthPending());
          await Future.delayed(const Duration(
              milliseconds: 500)); // wait for answer from auth repo
          emit(AuthSuccess(name: event.name));
        case AuthLogout():
          emit(AuthSignedOut());
      }
    });
  }

  login(String name) {
    add(AuthLogin(name: name));
  }

  logout() {
    add(AuthLogout());
  }
}
