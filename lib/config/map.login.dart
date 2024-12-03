
import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
    List<Datum> data;
    Meta meta;

    Welcome({
        required this.data,
        required this.meta,
    });

    factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
    };
}

class Datum {
    int id;
    String cedula;
    String correo;
    String password;
    Rol rol;
    bool sesionIniciada;
    int profesorId;
    bool isDeleted;
    dynamic resetCode;

    Datum({
        required this.id,
        required this.cedula,
        required this.correo,
        required this.password,
        required this.rol,
        required this.sesionIniciada,
        required this.profesorId,
        required this.isDeleted,
        required this.resetCode,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        cedula: json["cedula"],
        correo: json["correo"],
        password: json["password"],
        rol: rolValues.map[json["rol"]]!,
        sesionIniciada: json["sesionIniciada"],
        profesorId: json["profesorId"],
        isDeleted: json["isDeleted"],
        resetCode: json["resetCode"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "cedula": cedula,
        "correo": correo,
        "password": password,
        "rol": rolValues.reverse[rol],
        "sesionIniciada": sesionIniciada,
        "profesorId": profesorId,
        "isDeleted": isDeleted,
        "resetCode": resetCode,
    };
}

enum Rol {
    ADMIN,
    ESTUDIANTE,
    PROFESOR
}

final rolValues = EnumValues({
    "ADMIN": Rol.ADMIN,
    "ESTUDIANTE": Rol.ESTUDIANTE,
    "PROFESOR": Rol.PROFESOR
});

class Meta {
    int total;
    int page;
    int limit;
    int totalPages;

    Meta({
        required this.total,
        required this.page,
        required this.limit,
        required this.totalPages,
    });

    factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        total: json["total"],
        page: json["page"],
        limit: json["limit"],
        totalPages: json["totalPages"],
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "page": page,
        "limit": limit,
        "totalPages": totalPages,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
