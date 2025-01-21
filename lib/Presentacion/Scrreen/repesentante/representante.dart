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
        backgroundColor: Colors.blueAccent, // Color personalizado
        elevation: 4.0, // Efecto de sombra
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            // Encabezado del Drawer
            const UserAccountsDrawerHeader(
              accountName: Text("Usuario Representante"),
              accountEmail: Text("representante@correo.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.blueAccent),
              ),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
            ),
            // Elementos del menú
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.task, color: Colors.blueAccent),
                    title: const Text('Ver tareas'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ActividadesScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Pie del Drawer
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '© 2025 App Escolares',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.person_outline, size: 100, color: Colors.blueAccent),
            SizedBox(height: 16),
            Text(
              "Bienvenido a la pantalla de Representantes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
