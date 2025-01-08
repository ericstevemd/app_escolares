// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';

List<Login> loginFromJson(String str) => List<Login>.from(json.decode(str).map((x) => Login.fromJson(x)));

String loginToJson(List<Login> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Login {
    String message;
    String token;
    String cedula;
    String email;
    String userType;
    bool isProfessor;
    List<ProfesorInfo> profesorInfo;

    Login({
        required this.message,
        required this.token,
        required this.cedula,
        required this.email,
        required this.userType,
        required this.isProfessor,
        required this.profesorInfo,
    });

    factory Login.fromJson(Map<String, dynamic> json) => Login(
        message: json["message"],
        token: json["token"],
        cedula: json["cedula"],
        email: json["email"],
        userType: json["userType"],
        isProfessor: json["isProfessor"],
        profesorInfo: List<ProfesorInfo>.from(json["profesorInfo"].map((x) => ProfesorInfo.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "token": token,
        "cedula": cedula,
        "email": email,
        "userType": userType,
        "isProfessor": isProfessor,
        "profesorInfo": List<dynamic>.from(profesorInfo.map((x) => x.toJson())),
    };
}

class ProfesorInfo {
    int id;
    String nombre;
    String cedula;

    ProfesorInfo({
        required this.id,
        required this.nombre,
        required this.cedula,
    });

    factory ProfesorInfo.fromJson(Map<String, dynamic> json) => ProfesorInfo(
        id: json["id"],
        nombre: json["nombre"],
        cedula: json["cedula"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "cedula": cedula,
    };
}
