import 'package:exmaple/globals.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Globals.initialize(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: Globals.borderRadius,
          ),
          color: Colors.white10,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
