// To parse this JSON data, do
//
//     final profesorYMateria = profesorYMateriaFromJson(jsonString);

import 'dart:convert';

ProfesorYMateria profesorYMateriaFromJson(String str) => ProfesorYMateria.fromJson(json.decode(str));

String profesorYMateriaToJson(ProfesorYMateria data) => json.encode(data.toJson());

class ProfesorYMateria {
    int id;
    String nombre;
    String cedula;
    List<Materia> materias;

    ProfesorYMateria({
        required this.id,
        required this.nombre,
        required this.cedula,
        required this.materias,
    });

    factory ProfesorYMateria.fromJson(Map<String, dynamic> json) => ProfesorYMateria(
        id: json["id"],
        nombre: json["nombre"],
        cedula: json["cedula"],
        materias: List<Materia>.from(json["Materias"].map((x) => Materia.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "cedula": cedula,
        "Materias": List<dynamic>.from(materias.map((x) => x.toJson())),
    };
}

class Materia {
    int id;
    String nombreMateria;
    int profesorId;

    Materia({
        required this.id,
        required this.nombreMateria,
        required this.profesorId,
    });

    factory Materia.fromJson(Map<String, dynamic> json) => Materia(
        id: json["id"],
        nombreMateria: json["nombreMateria"],
        profesorId: json["profesorId"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombreMateria": nombreMateria,
        "profesorId": profesorId,
    };
}
