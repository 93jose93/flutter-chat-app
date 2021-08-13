import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  
  final String texto;
  //para identificar si es el mio o otra persona
  final String uid;
  //animacion de enviio del chat
  final AnimationController animationController;

  const ChatMessage({
    Key? key,
     required this.texto,
     required this.uid,
     required this.animationController
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //esto es para que se agregue la animacion
    return FadeTransition(
      opacity: animationController,
      //trasforma el tamao del widget
      child: SizeTransition(
        //esto al usar CurvedAnimation le da animaciones de trasicion 
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          //ejemplo si soy el que envia mensaje mi id es este == '123'
          child: this.uid == '123'
              //si soy yo entonces 
              ? _myMessage()
              //caso contrario
              : _notMyMessage(),
        ),
      ),
    );
  }

  Widget _myMessage() {
    //aliniar del lado derecho los mensajes mios
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(
          right: 5,
           bottom: 5,
           left: 50
        ),
        child: Text(this.texto, style: TextStyle( color: Colors.white ),),
        decoration: BoxDecoration(
          color: Color(0xff4D9EF6),
          borderRadius: BorderRadius.circular(20)
        ),
      ),

    );
  }


  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(
           left: 5,
           bottom: 5,
           right: 50
        ),
        child: Text(this.texto, style: TextStyle( color: Colors.black87 ),),
        decoration: BoxDecoration(
          color: Color(0xffE4E5E8),
          borderRadius: BorderRadius.circular(20)
        ),
      ),

    );
  }
}