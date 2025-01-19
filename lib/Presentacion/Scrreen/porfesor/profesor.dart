import 'package:app_escolares/Presentacion/Scrreen/porfesor/Curso.dart';
import 'package:app_escolares/Presentacion/Scrreen/porfesor/asistencias.dart';
import 'package:app_escolares/Presentacion/Scrreen/porfesor/materia.dart';
import 'package:app_escolares/Presentacion/Scrreen/porfesor/subir_novedades.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> logout(BuildContext context) async {
    bool confirmLogout = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Cerrar sesión'),
            content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Aceptar'),
              ),
            ],
          ),
        ) ??
        false;

    if (confirmLogout) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sesión cerrada correctamente')),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/Loginscreen',
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profesor ${widget.nombre}'),
      ),
      drawer: _buildDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Gráfico de Barras',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 300, child: _buildBarChart()),
              const SizedBox(height: 16),
              const Text(
                'Gráfico de Pastel',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 300, child: _buildPieChart()),
            ],
          ),
        ),
      ),
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
              Navigator.pop(context);
              logout(context);
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
        'route': ProfesorCursosScreen(profesorId: widget.profesorId)
      },
      {
        'icon': Icons.account_box_sharp,
        'text': 'Subir Novedades',
        'route': ProfesorNovedadesScreen(profesorId: widget.profesorId)
      },
      {
        'icon': Icons.folder,
        'text': 'Subir Tarea',
        'route': MateriasScreen(profesorId: widget.profesorId)
      },
      {
        'icon': Icons.account_box_rounded,
        'text': 'Asistencias',
        'route': AsistenciaScreen()
      },
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
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => route));
      },
    );
  }
Widget _buildBarChart() {
  return BarChart(
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
              switch (value.toInt()) {
                case 0:
                  return const Text('Asistencias');
                case 1:
                  return const Text('Estudiantes');
                case 2:
                  return const Text('Materias');
                default:
                  return const Text('');
              }
            },
          ),
        ),
      ),
      barGroups: [
        BarChartGroupData(
          x: 0,
          barRods: [BarChartRodData(toY: 50, color: Colors.green)],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [BarChartRodData(toY: 120, color: Colors.blue)],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [BarChartRodData(toY: 5, color: Colors.orange)],
        ),
      ],
    ),
  );
}

Widget _buildPieChart() {
  return PieChart(
    PieChartData(
      sections: [
        PieChartSectionData(
          value: 40,
          color: Colors.blue,
          title: '40%',
        ),
        PieChartSectionData(
          value: 30,
          color: Colors.red,
          title: '30%',
        ),
        PieChartSectionData(
          value: 30,
          color: Colors.green,
          title: '30%',
        ),
      ],
      centerSpaceRadius: 40,
    ),
  );
}


}