import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfesorCursosScreen extends StatelessWidget {
  final int profesorId;

  const ProfesorCursosScreen({Key? key, required this.profesorId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profesor y Cursos'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchProfesorWithCursos(profesorId),
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
          final cursos = profesor['cursos'] as List<dynamic>? ?? [];

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
                  'Cursos:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                cursos.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay cursos disponibles.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : Expanded(
                        child: ListView.separated(
                          itemCount: cursos.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final curso = cursos[index] as Map<String, dynamic>? ?? {};
                            return ListTile(
                              title: Text(curso['nombreCurso'] ?? 'Curso sin nombre'),
                              subtitle: Text(
                                curso['descripcion'] ?? 'Sin descripción',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              leading: const Icon(Icons.book, color: Colors.blueAccent),
                            );
                          },
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> fetchProfesorWithCursos(int id) async {
    final url = Uri.parse('http://158.220.124.141:3002/profesor/$id/cursos');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print('Datos recibidos: ${response.body}');
        return Map<String, dynamic>.from(json.decode(response.body));
      } else {
        print('Error ${response.statusCode}: ${response.reasonPhrase}');
        throw Exception(
            'Error al obtener los datos del profesor. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción capturada: $e');
      throw Exception('Error de red o servidor: $e');
    }
  }
}
