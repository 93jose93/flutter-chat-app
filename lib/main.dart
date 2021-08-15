import 'package:chat/routes/routes.dart';
import 'package:chat/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //aqui se agrego la libreria providers, el cual se declaro aqui 
    //por que se puede usar de froma global estando en la raiz del sistema
    return MultiProvider(
      //coleccion o listado de providers
      providers: [
        //notiofica cuando se requieran redibujarlos
         ChangeNotifierProvider(create: ( _ ) => AuthServices()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}