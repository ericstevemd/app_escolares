import 'dart:io'; // Necesario para manejar rutas locales de archivos
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ActividadesScreen extends StatefulWidget {
  @override
  _ActividadesScreenState createState() => _ActividadesScreenState();
}

class _ActividadesScreenState extends State<ActividadesScreen> {
  List<dynamic> actividades = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchActividades();
  }

  Future<void> fetchActividades() async {
    final url = Uri.parse('http://192.168.100.53:3002/actividad/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          actividades = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Error al cargar actividades');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  Widget _buildImage(String? imageUrl) {
    if (imageUrl == null) {
      // Imagen por defecto si no se proporciona URL
      return const Icon(Icons.image, size: 50, color: Colors.grey);
    }

    final isValidUri = Uri.tryParse(imageUrl)?.hasAbsolutePath ?? false;
    if (isValidUri && imageUrl.startsWith('http')) {
      // Carga de imágenes remotas
      return Image.network(
        imageUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
        },
      );
    } else if (File(imageUrl).existsSync()) {
      // Carga de imágenes locales
      return Image.file(
        File(imageUrl),
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    } else {
      // Imagen de respaldo si la URL no es válida
      return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Actividades'),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : actividades.isEmpty
              ? const Center(child: Text('No hay actividades disponibles'))
              : ListView.builder(
                  itemCount: actividades.length,
                  itemBuilder: (context, index) {
                    final actividad = actividades[index];
                    final imageUrl = actividad['foto'];
                    final decision = actividad['decision'] ?? 'No disponible';

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        leading: _buildImage(imageUrl),
                        title: Text(actividad['nombre'] ?? 'Sin nombre'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(actividad['descripcion'] ?? 'Sin descripción'),
                            const SizedBox(height: 4),
                            Text('Decisión: $decision',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetallesActividadScreen(actividad: actividad),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

class DetallesActividadScreen extends StatelessWidget {
  final Map<String, dynamic> actividad;

  DetallesActividadScreen({required this.actividad});

  Widget _buildImage(String? imageUrl) {
    if (imageUrl == null) {
      return const Icon(Icons.image, size: 200, color: Colors.grey);
    }

    final isValidUri = Uri.tryParse(imageUrl)?.hasAbsolutePath ?? false;
    if (isValidUri && imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 200, color: Colors.grey);
        },
      );
    } else if (File(imageUrl).existsSync()) {
      return Image.file(
        File(imageUrl),
        height: 200,
        fit: BoxFit.cover,
      );
    } else {
      return const Icon(Icons.broken_image, size: 200, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = actividad['foto'];
    return Scaffold(
      appBar: AppBar(
        title: Text(actividad['nombre'] ?? 'Detalles de la Actividad'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: _buildImage(imageUrl)),
            const SizedBox(height: 16),
            Text(
              actividad['nombre'] ?? 'Sin nombre',
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              actividad['descripcion'] ?? 'Sin descripción',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Decisión: ${actividad['decision'] ?? 'No disponible'}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
