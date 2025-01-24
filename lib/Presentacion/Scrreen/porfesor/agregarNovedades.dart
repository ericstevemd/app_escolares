import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateNovedadeScreen extends StatefulWidget {
  final int profesorId;
  const CreateNovedadeScreen({super.key, required this.profesorId});

  @override
  _CreateNovedadeScreenState createState() => _CreateNovedadeScreenState();
}

class _CreateNovedadeScreenState extends State<CreateNovedadeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController profesorIdController;
  TextEditingController tipoNovedadeController = TextEditingController();
  TextEditingController fechaController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicializa el controlador con el ID del profesor
    profesorIdController = TextEditingController(text: widget.profesorId.toString());
  }

  Future<void> createNovedade() async {
    final url = Uri.parse('http://158.220.124.141:3002/novedades'); // Cambia la URL según tu servidor

    final body = {
      "tipo_novedade": tipoNovedadeController.text,
      "fecha": fechaController.text,
      "profesorId": int.parse(profesorIdController.text), // Obtén el valor del controlador
      "descricion": descripcionController.text,
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
          const SnackBar(content: Text('Novedad creada exitosamente')),
        );

        // Limpia el formulario y redirige al menú principal
        _formKey.currentState?.reset();
        tipoNovedadeController.clear();
        fechaController.clear();
        descripcionController.clear();
        Navigator.pop(context); // Redirige al menú principal
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
                controller: tipoNovedadeController,
                decoration: const InputDecoration(labelText: 'Tipo de Novedad'),
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: fechaController,
                decoration: const InputDecoration(labelText: 'Fecha (YYYY-MM-DD)'),
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: profesorIdController,
                decoration: const InputDecoration(labelText: 'ID del Profesor'),
                readOnly: true, // Hace que el campo no sea editable
              ),
              TextFormField(
                controller: descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
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
