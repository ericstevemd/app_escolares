import 'package:app_escolares/model/estudiantes.dart';
import 'package:app_escolares/service/EstudianteService.dart';
import 'package:flutter/material.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _edadController = TextEditingController();
  final _correoController = TextEditingController();
  final _generoController= TextEditingController();
  final _nacionalidadController=TextEditingController();
  final _fechaNacimientoController=TextEditingController();
  final _cursoController=TextEditingController();
final _problemasDiscapacidadContraller=TextEditingController();
final _problemasSaludController=TextEditingController();
final _tipoSangreController=TextEditingController();
final _representanteIdController=TextEditingController();
final Estudianteservice _service = Estudianteservice();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(title:  const Text('Registrar Estudiante'),),
      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(16.0),
        child: Form(
        
        key: _formKey,
        child: Wrap(
          children: [
            TextFormField(
              controller:_nombreController,
              decoration:  const InputDecoration(labelText:'Nombre'),
              validator: (value) => value!.isEmpty?'Ingrese un nombre' : null,
        
            ),
              TextFormField(
              controller:_edadController,
              decoration:  const InputDecoration(labelText:'edad'),
              validator: (value) => value!.isEmpty?'Ingrese un Edad' : null,
        
            ),
              TextFormField(
              controller:_correoController,
              decoration:  const InputDecoration(labelText:'correo'),
              validator: (value) => value!.isEmpty?'Ingrese un Correo' : null,
        
            ),
        
        
              TextFormField(
              controller:_generoController,
              decoration:  const InputDecoration(labelText:'genero'),
              validator: (value) => value!.isEmpty?'Ingrese un genero' : null,
        
            ),
               TextFormField(
              controller:_nacionalidadController,
              decoration:  const InputDecoration(labelText:'nacionalidad'),
              validator: (value) => value!.isEmpty?'Ingrese la nacionalidad' : null,
        
            ),
        
               TextFormField(
              controller:_fechaNacimientoController,
              decoration:  const InputDecoration(labelText:'fechaNacimiento'),
              validator: (value) => value!.isEmpty?'Ingrese la fechaNacimiento' : null,
        
            ),
                TextFormField(
              controller:_problemasDiscapacidadContraller,
              decoration:  const InputDecoration(labelText:'Problemas Discapacidad'),
              validator: (value) => value!.isEmpty?'Ingrese la Problemas Discapacidad' : null,
        
            ),
             
        TextFormField(
              controller:_tipoSangreController,
              decoration:  const InputDecoration(labelText:'Tipo de Sangre '),
              validator: (value) => value!.isEmpty?'Ingrese la tipo de sangre ' : null,
        
            ),
                      
        TextFormField(
              controller:_representanteIdController,
              decoration:  const InputDecoration(labelText:'Representantes '),
              validator: (value) => value!.isEmpty?'Ingrese le Representantes' : null,
        
            ),
         TextFormField(
              controller:_problemasSaludController,
              decoration:  const InputDecoration(labelText:'nacionalidad'),
              validator: (value) => value!.isEmpty?'Ingrese la problemasDiscapacidadContraller' : null,
        
            ),
        
            SizedBox(height: 20),
        
            ElevatedButton(onPressed: () async{
              if(_formKey.currentState!.validate()){
                final estudiantes=Estudiantes(
                  nombre:_nombreController.text,
                  edad:int.parse(_edadController.text),
                  correo:_correoController.text,
                   genero: _generoController.text,
                   nacionalidad: _nacionalidadController.text,
                   cedula: _cursoController.text,
                    fechaNacimiento:DateTime(_fechaNacimientoController.text as int),
                    curso: _cursoController.text,
                    problemasDiscapacidad:bool.parse(_problemasDiscapacidadContraller.text),
                     representanteId: 1, 
                     tipoSangre: _tipoSangreController.text,
                      problemasSalud: _problemasSaludController.text, id: null,
                      
                      
                      
                      
                      
                      
                     
                  
        
                );
                final success =await _service.createEstudiante(estudiantes);
              if(success){
                ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Estudiante registrado con éxito')),
                        );
              }else{
                 ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Error al registrar estudiante')),
                        );
              }
              
              }
            }, child: const Text('Registro '))
          ],
        ),),
        ),
      )
    );
  }
}




