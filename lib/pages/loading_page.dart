import 'package:chat/pages/login_page.dart';
import 'package:chat/pages/usuarios_page.dart';
import 'package:chat/services/auth_services.dart';
import 'package:chat/services/socket_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LoadingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot){
            return Center(
              child: Text('Conectado por favor espere...'),
            );
        },         
      ),
   );
  }

  Future checkLoginState(BuildContext context) async{

      final authService = Provider.of<AuthServices>(context, listen: false);
      final socketServices = Provider.of<SocketServices>(context);

      final autenticado = await authService.isLoggedIn();
       
      //si esta autenticado inciara sesion
      if( autenticado ) {
        //conectar el soket server
        socketServices.connect();

        //Navigator.pushReplacementNamed(context, 'usuarios');

        //se recreo para navegar esa pagina de home, que su animacion sea diferente
        Navigator.pushReplacement(
          context, PageRouteBuilder(
            pageBuilder: ( _, __, ___) => UsuariosPage(),
            transitionDuration: Duration(microseconds: 0)
          )
        );

      } else {
        //de lo contario a login
        //Navigator.pushReplacementNamed(context, 'login');

         Navigator.pushReplacement(
          context, PageRouteBuilder(
            pageBuilder: ( _, __, ___) => LoginPage(),
            transitionDuration: Duration(microseconds: 0)
          )
        );
      }
  }
}