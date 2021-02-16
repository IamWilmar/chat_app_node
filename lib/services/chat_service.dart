import 'package:chat_app_node/global/enviroment.dart';
import 'package:chat_app_node/models/mensajes_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app_node/models/user.dart';
import 'package:chat_app_node/services/auth_service.dart';

class ChatService with ChangeNotifier {
  Usuario usuarioPara;

  Future<List<Mensaje>> getChat(String usuarioID) async {
    final resp = await http.get('${Enviroment.apiUrl}/mensajes/$usuarioID', 
        headers: {
          'Content-Type': 'applicatio/json',
          'x-token': await AuthService.getToken()
        });

    final mensajesResp = mensajesResponseFromJson(resp.body);

    return mensajesResp.mensajes;

  }
}
