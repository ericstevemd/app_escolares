import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class MateriasScreen extends StatelessWidget {
  final int profesorId;

  const MateriasScreen({Key? key, required this.profesorId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Materias del Profesor'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchMaterias(profesorId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar datos: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron materias.'));
          }

          final materias = snapshot.data!;

          return ListView.separated(
            itemCount: materias.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final materia = materias[index] as Map<String, dynamic>;
              return ListTile(
                leading: const Icon(Icons.book, color: Colors.blueAccent),
                title: Text(
                  materia['nombreMateria'] ?? 'Sin nombre',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Código: ${materia['id'] ?? 'Sin código'}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CrearMateriaScreen(
                        profesorId: profesorId,
                        materiaId: materia['id'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CrearMateriaScreen(
                profesorId: profesorId,
                materiaId: null,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Agregar Materia',
      ),
    );
  }

  Future<List<dynamic>> fetchMaterias(int id) async {
    final url = Uri.parse('http://192.168.100.53:3002/profesor/$id/materias');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        if (decodedResponse is Map<String, dynamic> &&
            decodedResponse.containsKey('Materias')) {
          return List<dynamic>.from(decodedResponse['Materias']);
        }
        throw Exception('No se encontró la clave "Materias".');
      } else {
        throw Exception(
            'Error al obtener las materias. Código: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de red o servidor: $e');
    }
  }
}


class CrearMateriaScreen extends StatelessWidget {
  final int profesorId;
  final int? materiaId;

  CrearMateriaScreen({Key? key, required this.profesorId, this.materiaId})
      : super(key: key);

  final ImagePicker _picker = ImagePicker();
  final ValueNotifier<String?> _selectedImagePath = ValueNotifier<String?>(null);

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final dateController = TextEditingController();
    final cursoController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Subir Tarea/Actividad')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre de la actividad'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Fecha (YYYY-MM-DD)'),
              ),
              TextField(
                controller: cursoController,
                decoration: const InputDecoration(labelText: 'ID del curso'),
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder<String?>(
                valueListenable: _selectedImagePath,
                builder: (context, imagePath, _) {
                  return Column(
                    children: [
                      imagePath != null
                          ? Image.file(File(imagePath), height: 200)
                          : const Text('No se ha seleccionado una imagen.'),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.photo),
                        label: const Text('Seleccionar Imagen'),
                        onPressed: () async {
                          final XFile? pickedFile = await _picker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 50, // Reduce el tamaño del archivo
                          );

                          if (pickedFile != null) {
                            _selectedImagePath.value = pickedFile.path;
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final name = nameController.text.trim();
                  final description = descriptionController.text.trim();
                  final date = dateController.text.trim();
                  final cursoId = int.tryParse(cursoController.text.trim());
                  final imagePath = _selectedImagePath.value;

                  if (name.isEmpty || description.isEmpty || date.isEmpty || cursoId == null || imagePath == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Todos los campos son obligatorios, incluida la imagen.')),
                    );
                    return;
                  }

                  try {
                    await uploadTask(
                      name,
                      description,
                      date,
                      imagePath,
                      materiaId!,
                      cursoId,
                      profesorId,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tarea subida con éxito.')),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al subir tarea: $e')),
                    );
                  }
                },
                child: const Text('Subir'),
              ),
            ],
          ),
        ),
      ),
    );
  }}

  Future<void> uploadTask(
    String name,
    String description,
    String date,
    String photo,
    int materiaId,
    int cursoId,
    int profesorId,
  ) async {
    final url = Uri.parse('http://192.168.100.53:3002/actividad/');
    final payload = {
      "nombre": name,
      "descripcion": description,
      "fecha": date,
      "foto": photo,
      "materiaId": materiaId,
      "cursoId": cursoId,
      "profesorId": profesorId,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      if (response.statusCode == 201) {
        print('Tarea subida exitosamente: ${response.body}');
      } else {
        throw Exception(
            'Error al subir tarea. Código: ${response.statusCode}, Respuesta: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de red o servidor: $e');
    }
  }

