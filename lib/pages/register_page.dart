import 'package:chat_app_node/widgets/boton_azul.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_node/widgets/custom_input.dart';
import 'package:chat_app_node/widgets/labels.dart';
import 'package:chat_app_node/widgets/logo.dart';

//https://www.flaticon.com/authors/pixel-perfect

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height*0.95,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(),
                _Form(),
                Labels(route: 'login', titulo: '¿Ya tienes una cuenta?', subTitulo: 'Ingresa ahora'),
                Text(
                  'Terminos y condiciones de uso',
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final userNameController = TextEditingController(); 
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 28),
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.person_outline_rounded,
            textController: userNameController,
            keyboardType: TextInputType.text,
            hint: 'username',
          ),
          CustomInput(
            icon: Icons.email_outlined,
            textController: emailController,
            keyboardType: TextInputType.emailAddress,
            hint: 'Email',
          ),
          CustomInput(
            icon: Icons.text_format,
            textController: passController,
            keyboardType: TextInputType.text,
            isPassword: true,
            hint: 'Password',
          ),
          BlueButton(
            text: 'Log In',
            onPressed: () {
              print(emailController.text);
              print(passController.text);
            },
          ),
        ],
      ),
    );
  }
}
