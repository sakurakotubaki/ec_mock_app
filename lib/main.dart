import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'router/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'EC Mock App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: GoRouter(
        routes: $appRoutes,
        initialLocation: '/',
      ),
    );
  }
}
