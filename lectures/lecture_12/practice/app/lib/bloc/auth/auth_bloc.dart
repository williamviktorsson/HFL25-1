import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class AuthEvent {}

final class AuthLogin extends AuthEvent {
  final String password;
  final String email;

  AuthLogin({required this.password, required this.email});
}

final class AuthLogout extends AuthEvent {}

final class AuthSubscribeToChanges extends AuthEvent {}

final class AuthRegister extends AuthEvent {
  final String password;
  final String email;
  final String username;

  AuthRegister(
      {required this.password, required this.email, required this.username});
}

sealed class AuthState {}

final class AuthInitial extends AuthState {
  AuthInitial();
}

final class AuthNotAuth extends AuthState {
  AuthNotAuth();
}

final class AuthSuccess extends AuthState {
  final String uid;

  AuthSuccess(this.uid);
}

final class AuthInProgress extends AuthState {
  AuthInProgress();
}

final class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>(
      (event, emit) async {
        switch (event) {
          case AuthRegister(:var email, :var password, :var username):
            emit(AuthInProgress());
            try {
              final credentials =
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: email,
                password: password,
              );

              if (credentials.user == null) {
                throw Exception("Credentials user returned null from create");
              }

              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(credentials.user!.uid)
                  .set({"uid": credentials.user!.uid, "username": username});
            } on FirebaseAuthException catch (e) {
              if (e.code == 'weak-password') {
                emit(AuthFailure('The password provided is too weak.'));
              } else if (e.code == 'email-already-in-use') {
                emit(AuthFailure('The account already exists for that email.'));
              } else {
                emit(AuthFailure(e.code));
              }
            } catch (e) {
              emit(AuthFailure(e.toString()));
            }
          case AuthLogin(:var email, :var password):
            emit(AuthInProgress());
            try {
              await FirebaseAuth.instance
                  .signInWithEmailAndPassword(email: email, password: password);
            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found') {
                emit(AuthFailure('No user found for that email.'));
              } else if (e.code == 'wrong-password') {
                emit(AuthFailure('Wrong password provided for that user.'));
              } else {
                emit(AuthFailure(e.code));
              }
            } catch (e) {
              emit(AuthFailure(e.toString()));
            }
          case AuthLogout():
            await FirebaseAuth.instance.signOut();
          case AuthSubscribeToChanges():
            await emit.forEach(FirebaseAuth.instance.authStateChanges(),
                onData: (user) {
              if (user != null) {
                return AuthSuccess(user.uid);
              } else {
                return AuthNotAuth();
              }
            });
        }
      },
    );
  }

  login({required String email, required String password}) {
    add(AuthLogin(email: email, password: password));
  }

  register(
      {required String username,
      required String password,
      required String email}) {
    add(AuthRegister(password: password, username: username, email: email));
  }

  logout() {
    add(AuthLogout());
  }
}
