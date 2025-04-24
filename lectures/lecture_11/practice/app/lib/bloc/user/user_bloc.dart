import 'package:app/bloc/auth/auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

sealed class UserEvent {}

final class UserCreate extends UserEvent {
  final String username;

  UserCreate({required this.username});
}

final class UserSubscribeToChanges extends UserEvent {}

sealed class UserState {
  final String uid;

  UserState({required this.uid});
}

final class UserInitial extends UserState {
  UserInitial({required super.uid});
}

final class UserExists extends UserState {
  final String username;

  UserExists({required super.uid, required this.username});
}

final class UserCreateInProgress extends UserState {
  final String username;

  UserCreateInProgress({required super.uid, required this.username});
}

final class UserMissing extends UserState {
  UserMissing({required super.uid});
}

class UserBloc extends Bloc<UserEvent, UserState> {
  final AuthSuccess authenticated;

  UserBloc({required this.authenticated})
      : super(UserInitial(uid: authenticated.uid)) {
    on<UserEvent>(
      (event, emit) async {
        switch (event) {
          case UserCreate(:var username):
            emit(UserCreateInProgress(
                uid: authenticated.uid, username: username));
            await FirebaseFirestore.instance
                .collection("users")
                .doc(authenticated.uid)
                .set({"uid": authenticated.uid, "username": username});
          case UserSubscribeToChanges():
            await emit.forEach(
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(authenticated.uid)
                    .snapshots(), onData: (snapshot) {
              final json = snapshot.data();

              if (snapshot.exists && json != null) {
                return UserExists(uid: json["uid"], username: json["username"]);
              } else {
                return UserMissing(uid: authenticated.uid);
              }
            });
        }
      },
    );
  }
}
