import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/services/auth_services.dart';
import 'package:chat/services/socket_services.dart';
import 'package:chat/widgets/boton_azul.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/labels.dart';
import 'package:chat/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class RegisterPage extends StatelessWidget {

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
                 Logo(titulo: 'Registro',),
                 _Form(),
                 Labels(
                   ruta: 'login',
                   titulo1: '¿Ya tienes una cuenta?',
                    titulo2: 'Ingresa ahora!',
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

  final nameCtrol = TextEditingController();
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
             icon: Icons.perm_identity,
             placeholder: 'Nombre',
             keyboardType: TextInputType.text,
             //esto es a donde va a apuntar
             textController: nameCtrol,

           ),
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
            text: 'Crear cuenta',
            onPressedfuntion: authService.autenticando ? null : () async {
              print(nameCtrol.text);
              print(emailCtrol.text);
              print(passCtrol.text);
              final registroOk = await authService.register(nameCtrol.text.trim(), emailCtrol.text.trim(), passCtrol.text.trim());
              
              if(registroOk == true) {
                //conectar a soket server
                socketServices.connect();

                Navigator.pushReplacementNamed(context, 'usuarios');
              } else {
                mostrartAlerta(context, 'Registro incorrecto', registroOk);
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