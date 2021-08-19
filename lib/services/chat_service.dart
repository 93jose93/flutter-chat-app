import 'package:chat/global/environment.dart';
import 'package:chat/models/MensajesListResponse.dart';
import 'package:chat/models/usaurio.dart';
import 'package:chat/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatServices with ChangeNotifier {

    late Usuario usuarioPara;

    Future<List<Mensaje>> getChat( String usuarioID ) async {
   
        final resp = await http.get(Uri.parse('${ Environment.apiURL }/mensajes/$usuarioID'),
         headers: {
               'Content-Type': 'application/json',
               'x-token': await AuthServices.getToken() as String
         }
        );

        final mensajeListResponse = mensajeListResponseFromJson(resp.body);

        return mensajeListResponse.mensajes;
        
    }
}