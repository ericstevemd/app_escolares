import 'dart:io'; // Necesario para manejar rutas locales de archivos
import 'package:app_escolares/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
    final url = Uri.parse('http://158.220.124.141:3002/actividad/'); // Cambiar la IP
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          actividades = data;
          isLoading = false;
        });

        // Mostrar una notificación al cargar actividades
        await showNotification(
          'Actividades cargadas',
          'Se han cargado ${actividades.length} actividades.',
        );
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

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id',
      'Actividades Notifications',
      channelDescription: 'Notificaciones de actividades',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0, // ID único para la notificación
      title,
      body,
      platformDetails,
    );
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
                        onTap: () async {
                          final actividadId = actividad['id']; // ID de la actividad
                          await showNotification(
                            'Actividad seleccionada',
                            'Has seleccionado: ${actividad['nombre']}',
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetallesActividadScreen(id: actividadId),
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

class DetallesActividadScreen extends StatefulWidget {
  final String id;

  DetallesActividadScreen({required this.id});

  @override
  _DetallesActividadScreenState createState() => _DetallesActividadScreenState();
}

class _DetallesActividadScreenState extends State<DetallesActividadScreen> {
  late Map<String, dynamic> actividad;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchActividadDetails();
  }

  Future<void> fetchActividadDetails() async {
    final url = Uri.parse('http://158.220.124.141:3002/actividad/${widget.id}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          actividad = data;
          isLoading = false;
        });
      } else {
        throw Exception('Error al cargar los detalles de la actividad');
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
    return Scaffold(
      appBar: AppBar(
        title: Text(actividad['nombre'] ?? 'Detalles de la Actividad'),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: _buildImage(actividad['foto'])),
                  const SizedBox(height: 16),
                  Text(
                    actividad['nombre'] ?? 'Sin nombre',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
