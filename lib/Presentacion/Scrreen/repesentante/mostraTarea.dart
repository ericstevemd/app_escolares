

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
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        leading: const Icon(Icons.event),
                        title: Text(actividad['nombre'] ?? 'Sin nombre'),
                        subtitle: Text(actividad['descripcion'] ?? 'Sin descripción'),
                      ),
                    );
                  },
                ),
    );
  }
}