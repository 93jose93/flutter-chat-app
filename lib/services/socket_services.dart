import 'package:chat/global/environment.dart';
import 'package:chat/services/auth_services.dart';
import 'package:flutter/material.dart';
 
import 'package:socket_io_client/socket_io_client.dart' as IO;
 
enum ServerStatus { Online, Offline, Connecting }
 
class SocketServices with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;
 
  ServerStatus get serverStatus => this._serverStatus;
 
  //esto es para usar en cualquier otra pantalla, emite y escucha
  IO.Socket get socket => this._socket;

  //este es para solo enviar infromacion y no escuchar
  Function get emit => this._socket.emit;
 
  
  void connect() async {

    final token = await AuthServices.getToken();

    //String urlSocket = 'http://192.168.1.102:3000'; //tu ipv4 con iPconfig (windows)
 
    this._socket = IO.io(
        Environment.socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .enableAutoConnect()
            .enableForceNew()
            .setExtraHeaders({
              'foo': 'bar',
              //aqui enviare el token al servidor para que verfique al usuario conectado
              'x-token': token
            }) // optional
            .build());
 
    // Estado Conectado
    this._socket.onConnect((_) {
      this._serverStatus = ServerStatus.Online;
      print('Conectado por Socket');
      notifyListeners();
    });
 
    // Estado Desconectado
    this._socket.onDisconnect((_) {
      this._serverStatus = ServerStatus.Offline;
      print('Desconectado del Socket Server');
      notifyListeners();
    });
  }

  void disconnect() {
    this._socket.disconnect();
  }
}