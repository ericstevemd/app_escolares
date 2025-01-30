import 'dart:convert';
import 'package:app_escolares/Presentacion/Scrreen/login/loginScreen.dart';
import 'package:app_escolares/Presentacion/Scrreen/repesentante/mostraTarea.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class Representante extends StatefulWidget {
  final String nombre;
  final String correo;
  final int representanteid;

  const Representante({
    super.key,
    required this.nombre,
    required this.correo,
    required this.representanteid,
  });

  @override
  State<Representante> createState() => _RepresentanteState();
}

class _RepresentanteState extends State<Representante> {
  bool isLoading = true;
  List<FlSpot> dataPoints = [];
  double minX = 0, maxX = 0, minY = 0, maxY = 0;

  @override
  void initState() {
    super.initState();
    fetchActividadData();
  }

  // Función para obtener datos desde la API
  Future<void> fetchActividadData() async {
    final url = Uri.parse('http://158.220.124.141/actividad/${widget.representanteid}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Procesar los puntos y crear una lista de FlSpot (x, y)
        List<dynamic> puntos = data['puntos']; // Ajusta según la respuesta de tu API

        setState(() {
          dataPoints = puntos
              .map((e) => FlSpot(e['x'].toDouble(), e['y'].toDouble()))
              .toList();

          minX = dataPoints.map((e) => e.x).reduce((a, b) => a < b ? a : b);
          maxX = dataPoints.map((e) => e.x).reduce((a, b) => a > b ? a : b);
          minY = dataPoints.map((e) => e.y).reduce((a, b) => a < b ? a : b);
          maxY = dataPoints.map((e) => e.y).reduce((a, b) => a > b ? a : b);
          isLoading = false;
        });
      } else {
        throw Exception('Error al cargar datos');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  // Función para manejar el cierre de sesión
  Future<void> _logout(BuildContext context) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Representante'),
        backgroundColor: Colors.blueAccent,
        elevation: 4.0,
      ),
      drawer: _buildDrawer(context),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Mostrar gráfico
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(show: true),
                        borderData: FlBorderData(show: true, border: Border.all(color: Colors.black)),
                        minX: minX - 1, // Ajustar el margen en el eje X
                        maxX: maxX + 1, // Ajustar el margen en el eje X
                        minY: minY - 1, // Ajustar el margen en el eje Y
                        maxY: maxY + 1, // Ajustar el margen en el eje Y
                        lineBarsData: [
                          LineChartBarData(
                            spots: dataPoints,
                            isCurved: true,color:Colors.blue,// Cambio aquí, 'colors' en minúsculas
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  const Text(
                    "Graficos actividad ", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
    );
  }

  // Widget para el Drawer
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(widget.nombre),
            accountEmail: Text(widget.correo),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.blueAccent),
            ),
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
            ),
          ),
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
    );
  }
}
