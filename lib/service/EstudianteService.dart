
import 'dart:convert';

import 'package:app_escolares/model/estudiantes.dart';
import 'package:http/http.dart' as http;

class Estudianteservice {

  final String baseUrl= 'http://192.168.100.53:3002/estudiantes';


//Crear un estudiantes 
Future <bool>createEstudiante (Estudiantes estudiante ) async{
  final url =Uri.parse(baseUrl);
  final headers= {'Content-Type': 'application/json'};
  final body =jsonEncode(estudiante.toJson());


  try{
    final response = await http.post(url, headers :headers , body : body);
  if(response.statusCode==201){
    return true;

  }else {
    print('Error: ${response.body}');
    return false;
  }
    
  }catch(e){
    print('Error al crear estudiante: $e');

    return false;

  }
}
//lista todo los estudiantes 
Future<List<Estudiantes>> getAllEstudiantes() async{
  final url =Uri.parse(baseUrl);
  try{
    final  response =await http.get(url);
    if(response.statusCode==200){
      List<dynamic>data=jsonDecode(response.body);
      return data.map((e)=> Estudiantes.fromJson(e)).toList();

    }else{
      print('Error: ${response.body}');
      return [];
    }

  }catch(e){

  print('Error al obtener estudiantes: $e');
      return [];

  }
}
//buscar un estudiantes 
Future <Estudiantes?>getestudiantesbyId(int id )async{
  final url =Uri.parse(baseUrl);

try{
final response=await http.get(url);
if (response.statusCode==200){
  return Estudiantes.fromJson(jsonDecode(response.body));
}else{
  print('Error: ${response.body}');
  return null;
}
}catch(e){
  print('Error al obtener estudiante: $e');
  return null ;
}

}

//eliminar todo los estudiantes 
Future <bool> deletesEstudiante(int id )async{
  final url =Uri.parse(baseUrl);
try{
final response=await http.delete(url);
if(response.statusCode==200){
  return true;
}else{
  print('Error: ${response.body}');
  return false;
}

}catch(e){
  print('Error al eliminar estudiante: $e');
  return false;

}
}
}