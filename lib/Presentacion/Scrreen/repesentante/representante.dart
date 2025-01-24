import 'package:app_escolares/Presentacion/Scrreen/login/loginScreen.dart';
import 'package:app_escolares/Presentacion/Scrreen/repesentante/mostraTarea.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Representante extends StatefulWidget {
  const Representante({super.key});



  @override
  State<Representante> createState() => _RepresentanteState();
}
void _logout(BuildContext context) async {
  // Mostrar un cuadro de diálogo de confirmación
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Cerrar sesión"),
        content: const Text("¿Estás seguro de que deseas cerrar sesión?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
            },
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              // Limpiar el token de autenticación de SharedPreferences
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');

              // Navegar a la pantalla de inicio de sesión
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const Loginscreen()),
              );
            },
            child: const Text("Cerrar sesión"),
          ),
        ],
      );
    },
  );
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
             ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Cerrar sesión'),
              onTap: () {
                _logout(context);
              },
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
