import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/services/auth_services.dart';
import 'package:chat/services/socket_services.dart';
import 'package:chat/widgets/boton_azul.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/labels.dart';
import 'package:chat/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      //SafeArea es para justar el contenido, del header y baje todos los elementos, y no esten dentro del header donde sale ejemplo la hora del telefono
      body: SafeArea(
        //este hace que cuando sale el teclado, haga scroll y no se salga error
        child: SingleChildScrollView(
          //este lo que hace es que cuando haya espacio de mas rebote
          physics: BouncingScrollPhysics(),
          child: Container(
            //se agrego container para ajustar toodos los widget a toda la pantalla por eso se uso Media query
            //algunos widgets posee padindd y magin, entonces para que encaje todo correctamente en la pantalla
            //se uso multimplica a * 0.9  que searia el 90% de la pantalla 
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              //quiero que todos los elementos se esparsan en la pantalla
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                 Logo(titulo: 'Messenger',),
                 _Form(),
                 Labels(
                   ruta: 'register',
                   titulo1: '¿No tienes cuenta?',
                   titulo2: 'Crea una ahora!',
                 ),
                 
                 _Terminos(),
                
              ],
            ),
          ),
        ),
      )
   );
  }
}



//SE CREA WIDGET DE TIPO StatefulWidget POR QUE SERA UN FORMULARIO QUE CAMBIA LA INFORMACION
class _Form extends StatefulWidget {
  
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {

  //se crearon para tener los controladores donde se va a apuntarla infromacion en ese imput
  final emailCtrol = TextEditingController();
  final passCtrol = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthServices>(context);
    final socketServices = Provider.of<SocketServices>(context);

    return Container(
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.symmetric( horizontal: 50),
      child: Column(
        children: <Widget>[
            
           CustomImput(
             icon: Icons.mail_outline,
             placeholder: 'Correo',
             keyboardType: TextInputType.emailAddress,
             //esto es a donde va a apuntar
             textController: emailCtrol,

           ),
           CustomImput(
             icon: Icons.lock_outline,
             placeholder: 'Contraseña',
             textController: passCtrol,
             isPassword: true,
             

           ),
          //aqui se colocan los argumentos que se obligan en boton_azul
          BotonAzul(
            text: 'Ingrese',
            //y aqui agregamos un ternario para desabilitar el botton cuando se este haciendo login
            //como ahora regresa un bool de auts_services necesitamos async
            onPressedfuntion: authService.autenticando ? null : () async {
              
              //quita el teclado al hacer login
              FocusScope.of(context).unfocus();
              
              //print(emailCtrol.text);
              //print(passCtrol.text);
              //solo necesito la referencia

              //trim() sirve para no enviar espacios en blanco en el input de login
              final loginOK = await authService.login(emailCtrol.text.trim(), passCtrol.text.trim());

              //validacion si es login es correcto o no
              if( loginOK == true) {
                  //conectar a nuestro soket.io server
                  socketServices.connect();

                  //navegar en otra pantalla
                  //pushReplacementNamed este me permite que de dirija a la pagina pero que no pueda regresar 
                  Navigator.pushReplacementNamed(context, 'usuarios');
              } else {
                  //mostrar alerta
                  //se creo una carpeta llamado helper para costruir el diseño de la alerta
                  mostrartAlerta(context, 'Login incorrecto', loginOK);
              }
            },
          )
        ],
      ),
    );
  }
}



class _Terminos extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 0),
      child:  Text('Términos y condiciones de uso',style: TextStyle(fontWeight: FontWeight.w200),),
    );
  }
}