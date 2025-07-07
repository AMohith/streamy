import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './src/core.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) {
        final repository = ShowsRepository();
        return AppCoreCubit(showsRepository: repository)..initializeApp();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Streamy',
        home: HomePage(),
      ),
    );
  }
}
