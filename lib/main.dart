


import 'package:app_escolares/menu/apprauter.dart';
import 'package:flutter/material.dart';




void main() => runApp(
  
  
  const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig:appRouter,
      debugShowCheckedModeBanner:false,
           
    );
  }
}