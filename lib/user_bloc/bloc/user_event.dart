part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class UserGerUsersEvent extends UserEvent {
  final int count;

  UserGerUsersEvent(this.count);
}

class UserGerUsersJobEvent extends UserEvent {
  final int count;

  UserGerUsersJobEvent(this.count);
}
