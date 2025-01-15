import 'package:app_escolares/Presentacion/Scrreen/porfesor/agregarNovedades.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfesorNovedadesScreen extends StatelessWidget {
  final int profesorId;

  const ProfesorNovedadesScreen({Key? key, required this.profesorId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profesor y Novedades'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchProfesorWithNovedades(profesorId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar datos: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No se encontró información.'));
          }

          final profesor = snapshot.data!;
          final novedades = profesor['novedades'] as List<dynamic>? ?? [];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profesor: ${profesor['nombre'] ?? 'Desconocido'}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Novedades:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                novedades.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay novedades disponibles.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : Expanded(
                        child: ListView.separated(
                          itemCount: novedades.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final novedad = novedades[index] as Map<String, dynamic>? ?? {};
                            return ListTile(
                              leading: const Icon(Icons.add_alert_rounded, color: Colors.redAccent),
                              title: Text(
                                novedad['tipo_novedade'] ?? 'Sin tipo',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Fecha: ${novedad['fecha'] ?? 'Sin fecha'}'),
                                  Text('Descripción: ${novedad['descricion'] ?? 'Sin descripción'}'),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateNovedadeScreen( profesorId: profesorId),
            ),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Agregar Novedad',
      ),
    );
  }

  Future<Map<String, dynamic>> fetchProfesorWithNovedades(int id) async {
    final url = Uri.parse('http://192.168.100.53:3002/profesor/$id/novedades');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print('Datos recibidos: ${response.body}');
        return Map<String, dynamic>.from(json.decode(response.body));
      } else {
        print('Error ${response.statusCode}: ${response.reasonPhrase}');
        throw Exception(
            'Error al obtener las novedades del profesor. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción capturada: $e');
      throw Exception('Error de red o servidor: $e');
    }
  }
}
