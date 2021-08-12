import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  
  final String text;
  final void Function()? onPressedfuntion;

  const BotonAzul({Key? key,
    required this.text,
    required this.onPressedfuntion
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
              child: Container(
                width: double.infinity,
                height: 55,
                child: Center(
                  child: Text(this.text, style: TextStyle(color: Colors.white, fontSize: 17),),
                ),
              ),
              onPressed: onPressedfuntion, 
              style: ElevatedButton.styleFrom(
                elevation: 2,
                shadowColor: Colors.blue,
                shape: StadiumBorder(),
                
              ),
    );
  }
}