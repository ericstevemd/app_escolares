import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AsistenciaScreen extends StatefulWidget {
  final int profesorId;

  const AsistenciaScreen({Key? key, required this.profesorId}) : super(key: key);

  @override
  _AsistenciaScreenState createState() => _AsistenciaScreenState();
}

class _AsistenciaScreenState extends State<AsistenciaScreen> {
  List<dynamic> asistenciaList = [];
  bool isLoading = true;
  String? errorMessage;

  // Función para realizar la petición GET de asistencia
  Future<void> fetchAsistencia() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse(
            'http://158.220.124.141:3002/asistencia/${widget.profesorId}/profesor/materia/estudiantes'),
      );

      print('Realizando petición GET a: ${response.request?.url}');
      print('Código de respuesta: ${response.statusCode}');
      print('Cuerpo de la respuesta: ${response.body}'); // Imprimir el cuerpo de la respuesta

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        print('Respuesta decodificada: $decodedData'); // Imprimir la respuesta decodificada

        if (decodedData is Map<String, dynamic>) {
          // Si la respuesta es un solo objeto, lo convertimos en una lista
          setState(() {
            asistenciaList = [decodedData];  // Convertir el objeto en una lista de un solo elemento
            errorMessage = asistenciaList.isEmpty
                ? 'No se encontraron registros de asistencia.'
                : null;
          });
        } else {
          setState(() {
            errorMessage = 'La respuesta no contiene un objeto válido de asistencia.';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Error ${response.statusCode}: ${response.reasonPhrase}';
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Error de conexión: ${error.toString()}';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Función para actualizar el estado de asistencia
  Future<void> updateEstado(int id, String nuevoEstado) async {
    final url = Uri.parse('http://158.220.124.141:3002/asistencia/$id');
    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'estado': nuevoEstado}),
      );

      print('✅ Código de respuesta: ${response.statusCode}');
      print('📨 Cuerpo de la respuesta: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          final index = asistenciaList.indexWhere((asistencia) => asistencia['id'] == id);
          if (index != -1) {
            asistenciaList[index]['estado'] = nuevoEstado;
          }
        });
        print('✔ Estado actualizado correctamente.');
      } else {
        print('❌ Error al actualizar: ${response.reasonPhrase}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar: ${response.reasonPhrase}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo conectar con el servidor')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAsistencia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asistencia'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: fetchAsistencia,
              icon: const Icon(Icons.refresh),
              label: const Text('Recargar'),
            ),
            const SizedBox(height: 16.0),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (errorMessage != null)
              Center(child: Text(errorMessage!, style: const TextStyle(color: Colors.red)))
            else if (asistenciaList.isEmpty)
              const Center(child: Text('No hay registros de asistencia disponibles.'))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: asistenciaList.length,
                  itemBuilder: (context, index) {
                    final asistencia = asistenciaList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 3,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Text(
                            asistencia['estado'][0],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text('Estudiante: ${asistencia['estudiante']['nombre']}',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          'Materia: ${asistencia['materia']['nombreMateria']} Profesor: ${asistencia['profesor']['nombre']}',
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (nuevoEstado) {
                            updateEstado(asistencia['id'], nuevoEstado);
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 'PRESENTE', child: Text('PRESENTE')),
                            const PopupMenuItem(value: 'AUSENTE', child: Text('AUSENTE')),
                            const PopupMenuItem(value: 'JUSTIFICADO', child: Text('JUSTIFICADO')),
                          ],
                          child: Text(
                            asistencia['estado'],
                            style: TextStyle(
                              color: asistencia['estado'] == 'PRESENTE'
                                  ? Colors.green
                                  : asistencia['estado'] == 'AUSENTE'
                                      ? Colors.red
                                      : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
