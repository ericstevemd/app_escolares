import 'package:app_escolares/Presentacion/Scrreen/repesentante/mostraTarea.dart';
import 'package:flutter/material.dart';

class Representante extends StatefulWidget {
  const Representante({super.key});

  @override
  State<Representante> createState() => _RepresentanteState();
}

class _RepresentanteState extends State<Representante> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Representantes"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.task),
              title: const Text('Ver tareas'),
              onTap: () {
                // Navega a la pantalla de tareas
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  ActividadesScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text("Bienvenido a la pantalla de Representantes"),
      ),
    );
  }
}

