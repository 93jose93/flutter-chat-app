import 'dart:convert';

import 'package:chat/global/environment.dart';
import 'package:chat/models/login_response.dart';
import 'package:chat/models/usaurio.dart';
import 'package:flutter/material.dart';
//como no queremos que esponga otodos los metodos
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//se pasa por el mixin with
//esto es provider por que se mescla con ChangeNotifier
class AuthServices with ChangeNotifier {

  //esta vacio null
  late Usuario usuario;


  //una class cuando le de al botton de inciar se bloquee mientras se incia de sesion
  bool _autenticando = false;
  //geter y set para hacer los cambios de estado, con provider
  bool get autenticando => this._autenticando;
  set autenticando(bool valor){
    this._autenticando = valor;
    notifyListeners();
  }

  // Create instancias de storage 
  final _storage = new FlutterSecureStorage();
   
   //getter del token de forma statica, para obtener el token
   static Future<String?> getToken() async {
      final _storage = new FlutterSecureStorage();
      //leer el token
      final token = await _storage.read(key: 'token');
      
      //aqui enviaremos el token a asoket services para enviarlo al servidor
      return token;
   }

   //getter del token de forma statica para eliminar
   static Future<void> deleteToken() async {
      final _storage = new FlutterSecureStorage();
      //leer el token
      await _storage.delete(key: 'token');

   }




  //Future esta de la mano con async pero esto se hace por que necesitamos que se ejecute pimero 
  //al tener respuetsa continua ejecutandose 
  
  //proceso de autenticacion

  //se le agrego Future<bool>, por que queremos cuando sea true realice lo de andetro
  // y false mostrar el error desde del servidor de las credenciales incorrectas 
  Future login( String email, String password) async {
    
    //ahoara se validara en boton para que cuando este ingresando se desactive
    //aqui lo esta bloquiando
    this.autenticando = true;


    //aqui recibiremos los campos, cuando voy hacer login, su informacion
      final data = {
         'email': email,
         'password': password
      };
      
      //entonces aqui pide la url de login
      final resp = await http.post(Uri.parse('${ Environment.apiURL }/login'),
         //aqui covertimos lo biene en forma de json
         body: jsonEncode(data),
         headers: {
           'Content-Type': 'application/json'
         }
      );




      //imprimero la url y en consola se ve el json, y se uso https://app.quicktype.io/ para mapearlo en models
      //print(resp.body);

       //ahoara se validara en boton para que cuando este ingresando se desactive y se active de nuevo al recorrer y hacer login
      //aqui lo desbloquea por que ya se ingreso y hizo todo lo anterior
      this.autenticando = false;

      if(resp.statusCode == 200) {
        //lo almacenamos
        final loginResponse = loginResponseFromJson(resp.body);
        //para almacenar EL JSON QUE probiene de la url
        this.usuario = loginResponse.usuario;

        //guardar el token para mantener el incio de sesion del usuario
        await this._guardarToken(loginResponse.token);

        return true;
      } else {
        //aqui regresaremos el error desde el servidor, mensaje de credenciales incorrecto

        final respBody = jsonDecode(resp.body);

        return respBody['msg'];
      }

     
  }


   Future register(String nombre, String email, String password) async {
      
    this.autenticando = true;

      final data = {
         'nombre': nombre,
         'email': email,
         'password': password
      };
      
      final resp = await http.post(Uri.parse('${ Environment.apiURL }/login/new'),
         body: jsonEncode(data),
         headers: {
           'Content-Type': 'application/json'
         }
      );

      //imprimero la url y en consola se ve el json, y se uso https://app.quicktype.io/ para mapearlo en models
      //print(resp.body);
      this.autenticando = false;

      if(resp.statusCode == 200) {
      
        final loginResponse = loginResponseFromJson(resp.body);
        this.usuario = loginResponse.usuario;

        await this._guardarToken(loginResponse.token);

        return true;
      } else {
        //aqui regresaremos el error desde el servidor, mensaje de credenciales incorrecto

        final respBody = jsonDecode(resp.body);

        return respBody['msg'];
      }
   }

  


  //metodo para matener la pantalla de usaurio,
  //verficaremos el token, este almacenado en storas y quse valido y que no este vencido
  Future<bool> isLoggedIn() async {
    
    final token = await this._storage.read(key: 'token');

    //print(token);

    final resp = await http.get(Uri.parse('${ Environment.apiURL }/login/renew'),
         headers: {
           'Content-Type': 'application/json',
           'x-token': token.toString()
         }
    );

      if(resp.statusCode == 200) {
      
        final loginResponse = loginResponseFromJson(resp.body);
        this.usuario = loginResponse.usuario;

        await this._guardarToken(loginResponse.token);

        return true;
      } else {
        //si el token vencio cerrara la sesion del usuario
        this.logout();
        return false;
      }
  }

  Future _guardarToken( String token ) async {
     // escribir
     return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    // Delete value 
    await _storage.delete(key: 'token');
  }
}