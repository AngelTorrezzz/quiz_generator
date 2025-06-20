import 'package:flutter/material.dart';
import 'package:quiz_generator/screens/form_generator.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Generator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF1d2d44),
            primary: Color(0xFF1d2d44), secondary: Color.fromARGB(255, 240, 235, 216), tertiary: Color(0xFF748cab)),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1d2d44),
          foregroundColor: Color.fromARGB(255, 240, 235, 216),
        ),
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
      home: const FormGenerator("Generador de Cuestionario"),
      //home: const FormQuestions(),
    );
  }
}