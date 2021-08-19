// To parse this JSON data, do
//
//     final usuariosListResponse = usuariosListResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/usaurio.dart';

UsuariosListResponse usuariosListResponseFromJson(String str) => UsuariosListResponse.fromJson(json.decode(str));

String usuariosListResponseToJson(UsuariosListResponse data) => json.encode(data.toJson());

class UsuariosListResponse {

  
    UsuariosListResponse({
      required  this.ok,
      required  this.usuarios,
        
    });

    bool ok;
    List<Usuario> usuarios;
 

    factory UsuariosListResponse.fromJson(Map<String, dynamic> json) => UsuariosListResponse(
        ok: json["ok"],
        usuarios: List<Usuario>.from(json["usuarios"].map((x) => Usuario.fromJson(x))),
        
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuarios": List<dynamic>.from(usuarios.map((x) => x.toJson())),
        
    };
}
