import 'package:flutter/material.dart';

class Estudiantes extends StatefulWidget {
  const Estudiantes({super.key});

  @override
  State<Estudiantes> createState() => _EstudiantesState();


}

class _EstudiantesState extends State<Estudiantes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estudiantes '),
      
      ),
drawer: Drawer(
  child: ListView(
    children: [
      ListTile(
        title: Text('data'),
      )
    ],
  ),

),

    );
  }
}