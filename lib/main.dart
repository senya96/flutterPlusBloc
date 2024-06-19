import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_tutorial/counter_bloc.dart';

import 'user_bloc/bloc/user_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final counterBloc = CounterBloc();
    return MultiBlocProvider(
        providers: [
          BlocProvider<CounterBloc>(
            create: (context) => counterBloc,
          ),
          BlocProvider<UserBloc>(
            create: (context) => UserBloc(counterBloc),
          ),
        ],
        child: Builder(builder: (context) {
          final counterBloc = BlocProvider.of<CounterBloc>(context);
          final userBloc = BlocProvider.of<UserBloc>(context);
          return Scaffold(
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        counterBloc.add(CounterIncEvent());
                      },
                      icon: const Icon(Icons.plus_one)),
                  IconButton(
                      onPressed: () {
                        counterBloc.add(CounterDecEvent());
                      },
                      icon: const Icon(Icons.exposure_minus_1)),
                  IconButton(
                      onPressed: () {
                        userBloc.add(UserGerUsersEvent(counterBloc.state));
                      },
                      icon: const Icon(Icons.person)),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: userBloc,
                                      child: Job(),
                                    )));
                        userBloc.add(UserGerUsersJobEvent(counterBloc.state));
                      },
                      icon: const Icon(Icons.work)),
                ],
              ),
              body: SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      BlocBuilder<CounterBloc, int>(
                          // bloc: counterBloc,
                          builder: (context, state) {
                        final users =
                            context.select((UserBloc bloc) => bloc.state.users);
                        return Column(
                          children: [
                            Text(
                              state.toString(),
                              style: const TextStyle(fontSize: 33),
                            ),
                            if (users.isNotEmpty)
                              ...users.map((e) => Text(e.name)),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ));
        }));
  }
}

class Job extends StatelessWidget {
  const Job({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
        final jobs = state.jobs;
        // final jobs = state.jobs;
        final isLoading = state.isLoading;
        return Column(
          children: [
            if (isLoading) const CircularProgressIndicator(),
            if (jobs.isNotEmpty) ...jobs.map((e) => Text(e.name))
          ],
        );
      }),
    );
  }
}
