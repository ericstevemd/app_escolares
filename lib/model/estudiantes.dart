// To parse this JSON data, do
//
//     final estudiantes = estudiantesFromJson(jsonString);

import 'dart:convert';

List<Estudiantes> estudiantesFromJson(String str) => List<Estudiantes>.from(json.decode(str).map((x) => Estudiantes.fromJson(x)));

String estudiantesToJson(List<Estudiantes> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Estudiantes {
    int ? id;
    String nombre;
    String cedula;
    String genero;
    String nacionalidad;
    DateTime fechaNacimiento;
    String curso;
    int edad;
    bool problemasDiscapacidad;
    String? problemasSalud;
    String tipoSangre;
    int representanteId;

    Estudiantes({
        required this.id,
        required this.nombre,
        required this.cedula,
        required this.genero,
        required this.nacionalidad,
        required this.fechaNacimiento,
        required this.curso,
        required this.edad,
        required this.problemasDiscapacidad,
        required this.problemasSalud,
        required this.tipoSangre,
        required this.representanteId, required String correo,
    });

    factory Estudiantes.fromJson(Map<String, dynamic> json) => Estudiantes(
        id: json["id"],
        nombre: json["nombre"],
        cedula: json["cedula"],
        genero: json["genero"],
        nacionalidad: json["nacionalidad"],
        fechaNacimiento: DateTime.parse(json["fechaNacimiento"]),
        curso: json["curso"],
        edad: json["edad"],
        problemasDiscapacidad: json["problemasDiscapacidad"],
        problemasSalud: json["problemasSalud"],
        tipoSangre: json["tipoSangre"],
        representanteId: json["representanteId"], correo: '',
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "cedula": cedula,
        "genero": genero,
        "nacionalidad": nacionalidad,
        "fechaNacimiento": fechaNacimiento.toIso8601String(),
        "curso": curso,
        "edad": edad,
        "problemasDiscapacidad": problemasDiscapacidad,
        "problemasSalud": problemasSalud,
        "tipoSangre": tipoSangre,
        "representanteId": representanteId,
    };
}
