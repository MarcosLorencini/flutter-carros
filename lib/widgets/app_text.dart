
import 'package:flutter/material.dart';

class AppText extends StatelessWidget {

  //paramentro em chaves são opcionais, caso queira obrigatorio coloque @required na frente do arguemento
  String label;
  String hint;
  bool password;
  TextEditingController contoller;
  FormFieldValidator<String> validator;
  TextInputType keyboardType;
  TextInputAction textInputAction;
  FocusNode focusNode;
  FocusNode nextFocus;


  AppText(
      this.label,
      this.hint,
      { this.password = false,
        this.contoller,
        this.validator,
        this.keyboardType,
        this.textInputAction,
        this.focusNode,
        this.nextFocus
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: contoller, //le os valors digitados do login
      obscureText: password,
      validator: validator,
      keyboardType: keyboardType, //define se o teclado vai ser númerico, alpha, alpah numerico
      textInputAction: textInputAction, //muda o layout do botão proximo do teclado no caso icone next
      focusNode: focusNode,
      onFieldSubmitted: (String next) { // chamado quando clica no botao seguinte do teclado após digitar o login e vai para o campo senha
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus); //foca no input da senha
        }
      },
      style: TextStyle( //campo de entrada do campos
          fontSize: 25,
          color: Colors.blue
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(//borda dos campos
          borderRadius: BorderRadius.circular(16)
        ),
          labelText: label,
          labelStyle: TextStyle(fontSize: 25, color: Colors.grey),
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 16,
          )
      ),
    );
  }
}
