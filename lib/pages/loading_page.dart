import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app_node/services/auth_service.dart';
import 'package:chat_app_node/pages/login_page.dart';
import 'package:chat_app_node/pages/users_page.dart';
import 'package:chat_app_node/services/socket_service.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);
    final autenticado = await authService.isLoggedIn();
    if (autenticado) {
      //Conectar al socker server
      socketService.connect();
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => UserPage(),
            transitionDuration: Duration(milliseconds: 0),
          ));
    } else {
       Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => LogInPage(),
            transitionDuration: Duration(milliseconds: 0),
          ));
    }
  }
}
