import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class UserEvent {}

final class UserSubscribe extends UserEvent {
  final String uid;

  UserSubscribe({required this.uid});
}

sealed class UserState {}

final class UserInitial extends UserState {
  UserInitial();
}

final class UserProgress extends UserState {
  UserProgress();
}

final class UserSuccess extends UserState {
  final String user;
  UserSuccess(this.user);
}

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<UserEvent>(
      (event, emit) async {
        switch (event) {
          case UserSubscribe(:var uid):
            emit(UserProgress());
            await emit.forEach(
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(uid)
                    .snapshots(), onData: (document) {
              if (document.exists && document.data() != null) {
                return UserSuccess(document.data()!["username"]);
              } else {
                // TODO: show failure states
                return UserInitial();
              }
            });
        }
      },
    );
  }
}
