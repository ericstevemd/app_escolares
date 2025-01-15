import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateNovedadeScreen extends StatefulWidget {
  final int  profesorId;
  const CreateNovedadeScreen( {super.key, required this.profesorId});

  @override
  _CreateNovedadeScreenState createState() => _CreateNovedadeScreenState();
}

class _CreateNovedadeScreenState extends State<CreateNovedadeScreen> {
  final _formKey = GlobalKey<FormState>();
  String? tipoNovedade;
  String? fecha;
  int? profesorId;
  String? descripcion;

  Future<void> createNovedade() async {
    final url = Uri.parse('http://192.168.100.53:3002/novedades'); // Cambia la URL según tu servidor

    final body = {
      "tipo_novedade": tipoNovedade,
      "fecha": fecha,
      "profesorId": profesorId,
      "descricion": descripcion,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        // Si la solicitud es exitosa
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Novedad creada exitosamente')),
        );
      } else {
        // Si hay un error del servidor
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode} - ${response.body}')),
        );
      }
    } catch (e) {
      // Si hay un error de red
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de red: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Novedad')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Tipo de Novedad'),
                onSaved: (value) => tipoNovedade = value,
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Fecha (YYYY-MM-DD)'),
                onSaved: (value) => fecha = value,
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'ID del Profesor'),
                keyboardType: TextInputType.number,
                onSaved: (value) => profesorId = int.tryParse(value ?? ''),
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Descripción'),
                onSaved: (value) => descripcion = value,
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    _formKey.currentState?.save();
                    createNovedade();
                  }
                },
                child: const Text('Crear Novedad'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
