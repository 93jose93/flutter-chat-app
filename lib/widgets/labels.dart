import 'package:flutter/material.dart';

class Labels extends StatelessWidget {

  final String ruta;

  final String titulo1;
  final String titulo2;

  const Labels({
    Key? key,
    required this.ruta,
    required this.titulo1,
    required this.titulo2,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Column(
         children: <Widget>[
           Text( this.titulo1 , style: TextStyle(color: Colors.black54 ,fontSize: 15, fontWeight: FontWeight.w300)),
           SizedBox( height: 10,),
           //detector de gesto
           GestureDetector(
             child: Text(this.titulo2, style: TextStyle(color: Colors.blue[600], fontSize: 18, fontWeight: FontWeight.bold),),
             onTap: () {
                 Navigator.pushReplacementNamed(context, this.ruta);
             },
           )
         ],
       ),
    );
  }
}