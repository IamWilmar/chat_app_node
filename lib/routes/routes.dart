
import 'package:chat_app_node/pages/chat_page.dart';
import 'package:chat_app_node/pages/loading_page.dart';
import 'package:chat_app_node/pages/login_page.dart';
import 'package:chat_app_node/pages/register_page.dart';
import 'package:chat_app_node/pages/users_page.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'users'     : (_) => UserPage(),
  'chat'      : (_) => ChatPage(),
  'login'     : (_) => LogInPage(),
  'register'  : (_) => RegisterPage(),  
  'loading'   : (_) => LoadingPage(),
};