import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Ajustes.dart';
import 'asistencias.dart';
import 'Curso.dart';
import 'subir_novedades.dart';
import 'tarea.dart';

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
    final url = 'http://192.168.100.53/profesor/${widget.profesorId}/materias';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> materias = json.decode(response.body);

        setState(() {
          _materias = materias
              .where((materia) =>
                  materia is Map && materia['nombreMateria'] != null)
              .toList();
          _isLoading = false;
        });
      } else {
        throw Exception(
            'Error al obtener las materias: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Error al cargar materias: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
                  child: Text('No hay materias disponibles.'),
                )
              : ListView.builder(
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
                          builder: (context) => MateriaDetailScreen(
                            materia: materia,
                          ),
                        ));
                      },
                    );
                  },
                ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://us.123rf.com/450wm/tuktukdesign/tuktukdesign1606/tuktukdesign160600119/59070200-icono-de-usuario-hombre-perfil-hombre-de-negocios-avatar-icono-persona-en-la-ilustraci%C3%B3n.jpg'),
            ),
            accountName: Text(widget.nombre),
            accountEmail: Text(widget.correo),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          const Divider(color: Colors.black54),
          _buildDrawerItem(
            icon: Icons.home_outlined,
            text: 'Curso',
            index: 0,
            route: ProfesorCursosScreen(profesorId: widget.profesorId),
          ),
          _buildDrawerItem(
            icon: Icons.account_box_sharp,
            text: 'Subir Novedades',
            index: 1,
            route: const SubirNovedades(),
          ),
          _buildDrawerItem(
            icon: Icons.folder,
            text: 'Subir Tarea',
            index: 2,
            route: const Tarea(),
          ),
          _buildDrawerItem(
            icon: Icons.account_box_rounded,
            text: 'Asistencias',
            index: 3,
            route: const Asistencias(),
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            text: 'Ajustes',
            index: 4,
            route: const Ajustes(),
          ),
          const Divider(color: Colors.black54),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              Navigator.pop(context);
              // Lógica de cierre de sesión aquí
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required int index,
    required Widget route,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: _selectedIndex == index ? Colors.yellow : null,
      ),
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
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'ID: ${materia['id']}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
