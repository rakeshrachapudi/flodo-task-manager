import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'providers/task_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const FlodoTaskApp());
}

class FlodoTaskApp extends StatelessWidget {
  const FlodoTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider()..loadTasks(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flodo Task Manager',
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}