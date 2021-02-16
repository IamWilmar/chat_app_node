import 'package:chat_app_node/global/enviroment.dart';
import 'package:chat_app_node/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier{
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket    get socket => this._socket;
  Function     get emit => this._socket.emit;

  void connect() async {

    final token = await AuthService.getToken();

    //Dart client
    _socket = IO.io( Enviroment.socketUrl, {
       'transports' : ['websocket'],
       'autoConnect': true,
       'forceNew' : true,
       'extraHeaders': {
         'x-token': token
       }  
     });

    this._socket.onConnect((_) {
     this._serverStatus = ServerStatus.Online;
     notifyListeners();
    });

    this._socket.onDisconnect((_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    //(nuevo-mensaje): asi se emite desde nodejs
    /*socket.on('nuevo-mensaje', ( payload ){
      print('nuevo mensaje: ');
      print('nombre: ' + payload['nombre']);
      print('mensaje: ' + payload['mensaje']);
    });*/

  }

  void disconnect(){
    this._socket.disconnect();
  }

}