import 'dart:convert';
import 'package:app_escolares/Presentacion/Scrreen/porfesor/profesor.dart';
import 'package:app_escolares/Presentacion/Scrreen/repesentante/representante.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_escolares/Presentacion/Scrreen/administrador/administrador.dart';
import 'package:app_escolares/Presentacion/Scrreen/estudiantes/estudiantes.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  _LoginscreenState createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final _cedulaController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Método de login
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return; // Validación de formulario

    final cedula = _cedulaController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://158.220.124.141:3002/usuario/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'cedula': cedula, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final token = data['token'];
        final userType = data['userType'];

        if (token == null) {
          _showSnackBar('No se recibió un Token');
          return;
        }

        await _saveToken(token);
        _showSnackBar('Inicio de sesión exitoso.');
        _redirectUser(userType, data, cedula);
      } else {
        _showSnackBar('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Función para guardar el token en SharedPreferences
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Función para redirigir al usuario según el tipo
  void _redirectUser(String userType, Map data, String cedula) {
    switch (userType) {
      case 'ADMIN':
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Administrador(userCedula: cedula)));
        break;
      case 'PROFESOR':
        final profesorInfo = data['profesorInfo']?[0];
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Profesor(
            nombre: profesorInfo?['nombre'] ?? '',
            correo: data['email'] ?? '',
            profesorId: profesorInfo?['id'] ?? '',
          ),
        ));
        break;
  case 'REPRESENTANTE':
      final representativeInfo = data['representativeInfo']?[0];
      if (representativeInfo == null) {
        _showSnackBar('Información del representante no disponible');
        return;
      }
    
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Representante(),
      ));
      break;
      case 'ESTUDIANTE':
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Estudiantes()));
        break;
      default:
        _showSnackBar('Tipo de usuario desconocido.');
        break;
    }
  }

  // Función para mostrar un SnackBar con el mensaje
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        reverse: true,
        child: Wrap(
          children: [
            Container(
              height: 400,
              child: Stack(
                children: [
                  Positioned(
                    top: -40,
                    height: 400,
                    width: width + 20,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(image: AssetImage('assets/images/background-3.png'), fit: BoxFit.fill),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/logoyasuni.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      "LOGIN",
                      style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    TextFormField(
                      controller: _cedulaController,
                      decoration: const InputDecoration(labelText: 'Cédula'),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'La cédula no puede estar vacía';
                        }
                        // Puedes agregar más validaciones si es necesario
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Contraseña'),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'La contraseña no puede estar vacía';
                        }
                        if (value.length < 6) {
                          return 'La contraseña debe tener al menos 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent),
                            child: const Text('Iniciar Sesión', style: TextStyle(color: Colors.black)),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
