// To parse this JSON data, do
//
//     final profesorYCruso = profesorYCrusoFromJson(jsonString);

import 'dart:convert';

ProfesorYCruso profesorYCrusoFromJson(String str) => ProfesorYCruso.fromJson(json.decode(str));

String profesorYCrusoToJson(ProfesorYCruso data) => json.encode(data.toJson());

class ProfesorYCruso {
    int id;
    String nombre;
    String cedula;
    List<Curso> cursos;

    ProfesorYCruso({
        required this.id,
        required this.nombre,
        required this.cedula,
        required this.cursos,
    });

    factory ProfesorYCruso.fromJson(Map<String, dynamic> json) => ProfesorYCruso(
        id: json["id"],
        nombre: json["nombre"],
        cedula: json["cedula"],
        cursos: List<Curso>.from(json["cursos"].map((x) => Curso.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "cedula": cedula,
        "cursos": List<dynamic>.from(cursos.map((x) => x.toJson())),
    };
}

class Curso {
    int id;
    String nombreCurso;
    String descripcion;
    int duracion;
    int profesorId;

    Curso({
        required this.id,
        required this.nombreCurso,
        required this.descripcion,
        required this.duracion,
        required this.profesorId,
    });

    factory Curso.fromJson(Map<String, dynamic> json) => Curso(
        id: json["id"],
        nombreCurso: json["nombreCurso"],
        descripcion: json["descripcion"],
        duracion: json["duracion"],
        profesorId: json["profesorId"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombreCurso": nombreCurso,
        "descripcion": descripcion,
        "duracion": duracion,
        "profesorId": profesorId,
    };
}
