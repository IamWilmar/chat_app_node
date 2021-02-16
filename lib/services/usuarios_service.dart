import 'package:chat_app_node/global/enviroment.dart';
import 'package:chat_app_node/models/usuarios_response.dart';
import 'package:chat_app_node/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app_node/models/user.dart';

class UsuariosService{
  Future<List<Usuario>> getUsuario() async{ 
    try{
      final resp = await http.get('${Enviroment.apiUrl}/usuarios',
        headers: {
          'Content-Type' : 'application/json',
          'x-token': await AuthService.getToken()
        }
      );
      final usuarioResponse = usuariosResponseFromJson(resp.body);
      return usuarioResponse.usuarios;
    }catch(e){
      return [];
    }
  }
}