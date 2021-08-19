import 'package:chat/global/environment.dart';
import 'package:chat/models/usuarios_list_response.dart';
import 'package:chat/services/auth_services.dart';
import 'package:http/http.dart' as http;
import 'package:chat/models/usaurio.dart';

class UsuariosListServices {

    Future<List<Usuario>> getUsuarios() async {
      //es bueno usar try por que si sale algo mal, podria regresar algo
        try {

          final resp = await http.get(Uri.parse('${Environment.apiURL}/usuarios'),
             headers: {
               'Content-Type': 'application/json',
               'x-token': await AuthServices.getToken() as String
             }
          );

          final usuariosListResponse = usuariosListResponseFromJson(resp.body);

          return usuariosListResponse.usuarios;
          
        } catch (e) {

          return [];
        }
    }
}