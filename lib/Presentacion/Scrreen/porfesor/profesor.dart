import 'package:app_escolares/Presentacion/Scrreen/porfesor/Curso.dart';
import 'package:app_escolares/Presentacion/Scrreen/porfesor/asistencias.dart';
import 'package:app_escolares/Presentacion/Scrreen/porfesor/materia.dart';
import 'package:app_escolares/Presentacion/Scrreen/porfesor/subir_novedades.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Profesor extends StatefulWidget {
  final String nombre;
  final String correo;
  final int profesorId;

  const Profesor({
    Key? key,
    required this.nombre,
    required this.correo,
    required this.profesorId,
  }) : super(key: key);

  @override
  State<Profesor> createState() => _ProfesorState();
}

class _ProfesorState extends State<Profesor> {
  int _selectedIndex = 0;
  List<dynamic> _materias = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMaterias();
  }

  Future<void> _fetchMaterias() async {
    final url = 'http://192.168.100.53:3002/profesor/${widget.profesorId}/materias';
    try {
      final response = await http.get(Uri.parse(url));
      print('Código de respuesta HTTP: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> materias = json.decode(response.body);
        print('Materias obtenidas del servidor: $materias');

        setState(() {
          _materias = materias
              .where((materia) => materia is Map && materia['nombreMateria'] != null)
              .toList();
          _isLoading = false;
        });
      } else {
        print('Error: Código de respuesta inesperado ${response.statusCode}');
        _showSnackBar('Error al obtener las materias: ${response.statusCode}');
      }
    } catch (e) {
      print('Error capturado durante la solicitud: $e');
      _showSnackBar('Error al cargar materias. Verifica tu conexión.');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }Future<void> logout(BuildContext context) async {
  // Confirmar con el usuario si realmente quiere cerrar sesión
  bool confirmLogout = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Cerrar sesión'),
      content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false); // No cierra sesión
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true); // Cierra sesión
          },
          child: const Text('Aceptar'),
        ),
      ],
    ),
  ) ?? false;

  if (confirmLogout) {
    // Elimina el token o los datos de sesión de SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // O el nombre de la clave que uses para almacenar el token

    // Mostrar un SnackBar confirmando que se cerró sesión
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sesión cerrada correctamente')),
    );

    // Redirige a la pantalla de inicio de sesión
    Navigator.pushReplacementNamed(context, '/login'); // Asegúrate de tener configurada la ruta /login
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profesor ${widget.nombre}'),
      ),
      drawer: _buildDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _materias.isEmpty
              ? const Center(
                  child: Text(
                    'No hay materias disponibles.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : _buildMateriasList(),
    );
  }

  Widget _buildMateriasList() {
    return ListView.builder(
      itemCount: _materias.length,
      itemBuilder: (context, index) {
        final materia = _materias[index];
        return ListTile(
          title: Text(
            materia['nombreMateria'] ?? 'Sin nombre',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'ID: ${materia['id']}',
            style: const TextStyle(color: Colors.grey),
          ),
          leading: const Icon(Icons.book, color: Colors.blueAccent),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MateriaDetailScreen(materia: materia),
            ));
          },
        );
      },
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildUserHeader(),
          const Divider(color: Colors.black54),
          ..._buildDrawerItems(),
          const Divider(color: Colors.black54),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              Navigator.pop(context); // Cierra el drawer
              logout(context); // Llama al método logout para cerrar la sesión
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserHeader() {
    return UserAccountsDrawerHeader(
      currentAccountPicture: const CircleAvatar(
        backgroundImage: NetworkImage(
          'https://us.123rf.com/450wm/tuktukdesign/tuktukdesign1606/tuktukdesign160600119/59070200-icono-de-usuario-hombre-perfil-hombre-de-negocios-avatar-icono-persona-en-la-ilustraci%C3%B3n.jpg',
        ),
      ),
      accountName: Text(widget.nombre),
      accountEmail: Text(widget.correo),
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
    );
  }

  List<Widget> _buildDrawerItems() {
    final items = [
      {'icon': Icons.home_outlined, 'text': 'Curso', 'route': ProfesorCursosScreen(profesorId: widget.profesorId)},
      {'icon': Icons.account_box_sharp, 'text': 'Subir Novedades', 'route': ProfesorNovedadesScreen(profesorId: widget.profesorId)},
      {'icon': Icons.folder, 'text': 'Subir Tarea', 'route':  MateriasScreen(profesorId: widget.profesorId)},
      {'icon': Icons.account_box_rounded, 'text': 'Asistencias', 'route': const Asistencias()},
    ];

    return items
        .asMap()
        .entries
        .map((entry) => _buildDrawerItem(
              icon: entry.value['icon'] as IconData,
              text: entry.value['text'] as String,
              index: entry.key,
              route: entry.value['route'] as Widget,
            ))
        .toList();
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required int index,
    required Widget route,
  }) {
    return ListTile(
      leading: Icon(icon, color: _selectedIndex == index ? Colors.yellow : null),
      title: Text(text),
      selected: _selectedIndex == index,
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => route));
      },
    );
  }
}

class MateriaDetailScreen extends StatelessWidget {
  final Map<String, dynamic> materia;

  const MateriaDetailScreen({Key? key, required this.materia}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de ${materia['nombreMateria']}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Materia: ${materia['nombreMateria']}',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'ID: ${materia['id']}',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

