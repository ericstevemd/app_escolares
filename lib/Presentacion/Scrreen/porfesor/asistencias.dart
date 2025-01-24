import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AsistenciaScreen extends StatefulWidget {
  @override
  _AsistenciaScreenState createState() => _AsistenciaScreenState();
}

class _AsistenciaScreenState extends State<AsistenciaScreen> {
  List<dynamic> asistenciaList = [];
  bool isLoading = true;
  String? errorMessage;

  // Función para obtener los datos de la API
  Future<void> fetchAsistencia() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('http://158.220.124.141:3002/asistencia/'),
      );

      if (response.statusCode == 200) {
        setState(() {
          asistenciaList = json.decode(response.body);
        });
      } else {
        setState(() {
          errorMessage = 'Error: ${response.statusCode} - ${response.reasonPhrase}';
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Error: No se pudo conectar con el servidor';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Función para actualizar el estado
  Future<void> updateEstado(int id, String nuevoEstado) async {
    final url = Uri.parse('http:// 10.195.243.180:3002/asistencia/$id');
    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'estado': nuevoEstado}),
      );

      if (response.statusCode == 200) {
        setState(() {
          // Actualizar la lista localmente después de la actualización en el servidor
          final index = asistenciaList.indexWhere((asistencia) => asistencia['id'] == id);
          if (index != -1) {
            asistenciaList[index]['estado'] = nuevoEstado;
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el estado: ${response.reasonPhrase}')),
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
      appBar: AppBar(
        title: const Text('Asistencia'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: fetchAsistencia,
              icon: const Icon(Icons.refresh),
              label: const Text('Recargar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (errorMessage != null)
              Center(
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
              )
            else if (asistenciaList.isEmpty)
              const Center(
                child: Text(
                  'No hay registros de asistencia disponibles.',
                  style: TextStyle(fontSize: 16.0),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: asistenciaList.length,
                  itemBuilder: (context, index) {
                    final asistencia = asistenciaList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Text(
                            asistencia['estado'][0],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          'Estudiante: ${asistencia['estudiante']['nombre']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Materia: ${asistencia['materia']['nombreMateria']}\nProfesor: ${asistencia['profesor']['nombre']}',
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (nuevoEstado) {
                            updateEstado(asistencia['id'], nuevoEstado);
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'PRESENTE',
                              child: Text('PRESENTE'),
                            ),
                            const PopupMenuItem(
                              value: 'AUSENTE',
                              child: Text('AUSENTE'),
                            ),
                            const PopupMenuItem(
                              value: 'JUSTIFICADO',
                              child: Text('JUSTIFICADO'),
                            ),
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
