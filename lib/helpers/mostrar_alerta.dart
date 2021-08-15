import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//al ponerlo asi, le esta obligando que esos campos son obligatorio
mostrartAlerta( BuildContext context, String titulo, String subtitulo) {
   
    if( Platform.isAndroid){
        return showDialog(
          context: context,
          builder: ( _ ) => AlertDialog(
            title: Text( titulo ),
            content: Text( subtitulo ),
            actions: <Widget>[
                MaterialButton(
                  child: Text('Ok'),
                  elevation: 5,
                  textColor: Colors.blue,
                  onPressed: () => Navigator.pop(context)
                )
            ],
          )
       );
    } 

    showCupertinoDialog(
      context: context,
      builder: ( _ ) => CupertinoAlertDialog(
        title: Text( titulo ),
        content: Text( subtitulo ),
        actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () => Navigator.pop(context),

            )
        ],
      )
      
    
    );
   
   
    
}