import 'package:app_escolares/Presentacion/Scrreen/login/loginScreen.dart';
import 'package:app_escolares/Presentacion/Scrreen/porfesor/Curso.dart';
import 'package:app_escolares/Presentacion/Scrreen/porfesor/asistencias.dart';
import 'package:app_escolares/Presentacion/Scrreen/porfesor/materia.dart';
import 'package:app_escolares/Presentacion/Scrreen/porfesor/subir_novedades.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  List<Map<String, dynamic>> courses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCourses(widget.profesorId);
  }

  Future<void> fetchCourses(int id) async {
    final url = Uri.parse('http://158.220.124.141/profesor/$id/materias');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          courses = List<Map<String, dynamic>>.from(data['nombreMateria']);
          isLoading = false;
        });
      } else {
        _handleError('Error al obtener los datos: ${response.statusCode}');
      }
    } catch (e) {
      _handleError('Error: $e');
    }
  }

  void _handleError(String errorMessage) {
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }

  void _logout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cerrar sesión"),
          content: const Text("¿Estás seguro de que deseas cerrar sesión?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('token');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profesor ${widget.nombre}'),
      ),
      drawer: _buildDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSectionTitle('Gráfico de Barras'),
                    _buildBarChart(),
                    const SizedBox(height: 16),
                    _buildSectionTitle('Gráfico de Pastel'),
                    _buildPieChart(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Cerrar sesión'),
            onTap: () {
              _logout(context);
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
      {
        'icon': Icons.home_outlined,
        'text': 'Curso',
        'route': ProfesorCursosScreen(profesorId: widget.profesorId),
      },
      {
        'icon': Icons.account_box_sharp,
        'text': 'Subir Novedades',
        'route': ProfesorNovedadesScreen(profesorId: widget.profesorId),
      },
      {
        'icon': Icons.folder,
        'text': 'Subir Tarea',
        'route': MateriasScreen(profesorId: widget.profesorId),
      },
      {
        'icon': Icons.account_box_rounded,
        'text': 'Asistencias',
        'route': AsistenciaScreen(),
      },
    ];

    return items
        .asMap()
        .entries
        .map(
          (entry) => _buildDrawerItem(
            icon: entry.value['icon'] as IconData,
            text: entry.value['text'] as String,
            index: entry.key,
            route: entry.value['route'] as Widget,
          ),
        )
        .toList();
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
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => route));
      },
    );
  }

  Widget _buildBarChart() {
    if (courses.isEmpty) {
      return const Center(child: Text('No hay datos para mostrar.'));
    }

    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < courses.length) {
                    return Text(courses[value.toInt()]['nombreCurso']);
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          barGroups: courses
              .asMap()
              .entries
              .map(
                (entry) => BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value['duracion'].toDouble(),
                      color: Colors.blue,
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    if (courses.isEmpty) {
      return const Center(child: Text('No hay datos para mostrar.'));
    }

    return SizedBox(
      height: 300,
      child: PieChart(
        PieChartData(
          sections: courses
              .map(
                (course) => PieChartSectionData(
                  value: course['duracion'].toDouble(),
                  color: Colors.primaries[courses.indexOf(course) % Colors.primaries.length],
                  title: '${course['duracion']}h',
                ),
              )
              .toList(),
          centerSpaceRadius: 40,
        ),
      ),
    );
  }
}
