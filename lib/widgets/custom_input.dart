import 'package:flutter/material.dart';

//se uso esto en el imput StatelessWidget por que, solo el imput sera statico y el logo diseño no cambia
class CustomImput extends StatelessWidget {
  
  final IconData icon;
  final String placeholder;
  //esto sera los argumentos que obligo a que se usen en login_page, ejemplo se enviara el tipo de icono segun el imput 
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool isPassword;

  const CustomImput({
    Key? key, 
    required this.icon,
    required this.placeholder,
    required this.textController,
    //aqui se definio por defecto que trae si no se llega ausar
    this.keyboardType = TextInputType.text, 
    this.isPassword = false
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return  Container(
              //esto le dio margen a las lineas dentro del imput
              padding: EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: Offset(0, 5),
                    //difuminado
                    blurRadius: 5
                  )
                ]
              ),
              child: TextField(
                   controller: this.textController,
                   autocorrect: false,
                   //este es para definir que es un impot de tipo correo, dandole al chat tipo correo saliendo el arroba
                   keyboardType: this.keyboardType,
                   //esto es para el tipo de cambo contraseña
                   obscureText: this.isPassword,
                   decoration: InputDecoration(
                     prefixIcon: Icon(this.icon),
                     //quita la linea cuando estoy dentro del imput
                     focusedBorder: InputBorder.none,
                     //este quita la linea pero cuando no esta seleccionado, muestra uno por defaul y se desactiva
                     border: InputBorder.none,
                     hintText: this.placeholder
                   ),
              ),
            );
  }
}