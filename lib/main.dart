import 'package:chat_app_node/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app_node/routes/routes.dart';
import 'package:chat_app_node/services/auth_service.dart';
import 'package:chat_app_node/services/socket_service.dart'; 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SocketService()),
        ChangeNotifierProvider(create: (_) => ChatService())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat with Node',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}