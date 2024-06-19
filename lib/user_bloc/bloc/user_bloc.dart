import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_tutorial/counter_bloc.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final CounterBloc counterBloc;
  late final StreamSubscription counterBlocSubscription;

  UserBloc(this.counterBloc) : super(UserState()) {
    on<UserGerUsersEvent>(_onGetUser);
    on<UserGerUsersJobEvent>(_onGetUserJob);
    counterBlocSubscription = counterBloc.stream.listen((state) {
      if (state <= 0) {
        add(UserGerUsersEvent(0));
        add(UserGerUsersJobEvent(0));
      } //else {
      //   add(UserGerUsersEvent(state));
      //   add(UserGerUsersJobEvent(state));
      // }
    });
  }

  @override
  Future<void> close() async {
    counterBlocSubscription.cancel();
    return super.close();
  }

  _onGetUser(UserGerUsersEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(Duration(seconds: 1));
    final users = List.generate(event.count, (index) => User(name: 'username ${index.toString()}', id: 'id'));
    emit(state.copyWith(users: users));
  }

  _onGetUserJob(UserGerUsersJobEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(Duration(seconds: 1));
    final jobs = List.generate(event.count, (index) => Job(name: 'employer ${index.toString()}', id: 'id'));
    emit(state.copyWith(jobs: jobs));
  }
}
