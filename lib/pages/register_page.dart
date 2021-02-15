import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app_node/services/auth_service.dart';
import 'package:chat_app_node/widgets/boton_azul.dart';
import 'package:chat_app_node/widgets/custom_input.dart';
import 'package:chat_app_node/widgets/labels.dart';
import 'package:chat_app_node/widgets/logo.dart';
import 'package:chat_app_node/helpers/mostrar_alerta.dart';

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
    final authService = Provider.of<AuthService>(context);
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
            onPressed: authService.autenticando ? null : () async {
               FocusScope.of(context).unfocus();
              final isloginOk = await authService.register(userNameController.text, emailController.text.trim(), passController.text.trim());
              if(isloginOk){
                //TODO: Conectar a sokcet server
                //TODO: Navegar a otra pantalla
                Navigator.pushReplacementNamed(context, 'users');
              }else{
                //Mostrar alerta
                mostrarAlerta(context, 'Registro Incorrecto', 'Credenciales no validas');
              }
            },
          ),
        ],
      ),
    );
  }
}
