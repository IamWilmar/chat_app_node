import 'package:chat_app_node/helpers/mostrar_alerta.dart';
import 'package:chat_app_node/services/auth_service.dart';
import 'package:chat_app_node/widgets/boton_azul.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_node/widgets/custom_input.dart';
import 'package:chat_app_node/widgets/labels.dart';
import 'package:chat_app_node/widgets/logo.dart';
import 'package:provider/provider.dart';

//https://www.flaticon.com/authors/pixel-perfect

class LogInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.95,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(),
                _Form(),
                Labels(
                    route: 'register',
                    titulo: '¿No tienes Cuenta?',
                    subTitulo: 'Crea una ahora'),
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
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: <Widget>[
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
            onPressed:  authService.autenticando ? null : () async {
              FocusScope.of(context).unfocus();
              final isloginOk = await authService.login(emailController.text.trim(), passController.text.trim());
              if(isloginOk){
                //TODO: Conectar a sokcet server
                //TODO: Navegar a otra pantalla
                Navigator.pushReplacementNamed(context, 'users');
              }else{
                //Mostrar alerta
                mostrarAlerta(context, 'Login Incorrecto', 'Credenciales no validas');
              }
            },
          ),
        ],
      ),
    );
  }
}
