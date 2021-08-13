import 'dart:io';

import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChatPage extends StatefulWidget {

  @override
  _ChatPageState createState() => _ChatPageState();
}
//hay que mesclar el estado con los cuadros y por eso se agrega para sicronizar
//y al hacer esto podemos agregar animaciones
class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();

  //INICALIZAR ChatMessage
  List<ChatMessage> _messages = [];

  bool _estaEscribiendo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       backgroundColor: Colors.white,
       centerTitle: true,
       elevation: 1,
       title: Column(
         children: <Widget>[
           CircleAvatar(
             child: Text('Te', style: TextStyle(fontSize: 12),),
             backgroundColor: Colors.blue[100],
             maxRadius: 14,
           ),
           SizedBox(height: 3),
           Text('Jose Sanchez', style: TextStyle(color: Colors.black87, fontSize: 12),),
         ],
       ),
     ),
     body: Container(
       child: Column(
         children: <Widget>[
           //se expande en su totalidad en la pantalla
            Flexible(
             //esto es una lista
             child: ListView.builder(
               //esto es para que se vea en ios
               physics: BouncingScrollPhysics(),
               itemCount: _messages.length,
               itemBuilder: ( _ , i) => _messages[i],
               //esto hace el chat suba vea los mensaje
               reverse: true,
             )
            ),
            Divider( height: 1,),
            
            //caja de texto donde escribira el mensaje
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
         ]
       ),
     ),
   );
  }

  Widget _inputChat() {
     return SafeArea(
       child: Container(
         margin: EdgeInsets.symmetric(horizontal: 8.0),
         //widwegts uno al aldo de otro
         child: Row(
           children: <Widget>[
             //se expande en su totalidad en la pantalla
             Flexible(
               //el imput
               child: TextField(
                 //valor 
                 controller: _textController,
                 //este es el posteo
                 onSubmitted: _handleSubmit,
                 //texto actual
                 onChanged: ( texto ) {
                   //cuando hay un valor, para poder postear
                   setState(() {
                     //trim es para limpiar, length hay texto contandolo
                     if(texto.trim().length > 0){
                       _estaEscribiendo = true;
                     } else {
                       _estaEscribiendo = false;
                     }
                   });
                 },
                 //quitar la line del imput
                 decoration: InputDecoration.collapsed(
                   hintText: 'Enviar mensaje'
                 ),
                 //esto del foco es para que se mantenga seleccionado el imput, cuando se ingrece al chat
                 focusNode: _focusNode,
               )
             ),
             //boton para enviar
             Container(
               margin: EdgeInsets.symmetric(horizontal: 4.0),
               //diferenciar si es ios se hace un ternario
               child: Platform.isIOS 
                  ? CupertinoButton(
                    child: Text('Enviar'),
                    onPressed: _estaEscribiendo
                        ? () => _handleSubmit( _textController.text.trim())
                        : null,
                  )
                  : Container(
                     margin: EdgeInsets.symmetric(horizontal: 4.0),
                     //se agrego este IconTheme, para que cuando no hay mensaje, se desavilite el color a negro
                     child: IconTheme(
                       data: IconThemeData(color: Colors.blue[400]),
                       child: IconButton(
                         highlightColor: Colors.transparent,
                         splashColor: Colors.transparent,
                         icon: Icon(Icons.send),
                         onPressed: _estaEscribiendo
                            ? () => _handleSubmit( _textController.text.trim())
                            : null,
                       ),
                     ),
                  ),
             )
           ],
         ),
       )
     );
  }

  //obtener el valor del chat a precionar
  _handleSubmit( String texto ) {

    //validacion de que si no hay nada no envie
    if( texto.length == 0) return;

    print(texto);

  
    //esto es para al enviar un mensaje se borre
    _textController.clear();
    //para no cerrar el chat cuando se envia mensajes
    _focusNode.requestFocus();

    
    final newMessage = ChatMessage(
      uid: '123',
      texto: texto,
      //aqui agregamos la animacion
      animationController: AnimationController(
        vsync: this, duration: Duration(milliseconds: 200),
      ),
      
    );
    _messages.insert(0, newMessage);

    //aqui ejecutamos la animacion
    newMessage.animationController.forward();

    setState(() {
      _estaEscribiendo = false;
    });
  }
  
  //aqui limpiamos varias cosas
  //esto va a funcionar cuando cerremos la pántalla del chat y se ejcuta esto 
  @override
  void dispose() {
    // TODO: implement dispose

    //limpiar instancia para que no consuma memoria, entonces limpia las animaciones
    for( ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}