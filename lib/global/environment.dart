import 'dart:io';


//al ser metodos estaticos, puedo aceder a ellos nin necesidad de instanciar la class
class Environment {
  //pregunta si es android 
  //servicio res
  static String apiURL = Platform.isAndroid 
     ? 'http://192.168.1.8:3000/api' 
     //de lo contrario es ios
     : 'http://localhost:3000/api';
  
  //servidor de sokets.io
  static String socketUrl = Platform.isAndroid 
     ? 'http://192.168.1.8:3000' 
     //de lo contrario es ios
     : 'http://localhost:3000';
}