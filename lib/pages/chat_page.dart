import 'dart:io';

import 'package:chat_app_node/models/mensajes_response.dart';
import 'package:chat_app_node/services/auth_service.dart';
import 'package:chat_app_node/services/chat_service.dart';
import 'package:chat_app_node/services/socket_service.dart';
import 'package:chat_app_node/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final textController = new TextEditingController();
  final focusNode = new FocusNode();
  ChatService chatService;
  SocketService socketService;
  AuthService authService;
  bool isWriting = false;
  List<ChatMessage> messages = [];

  @override
  void initState() {
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);

    this.socketService.socket.on('mensaje-personal', _escucharMensaje);
    _cargarHistorial(this.chatService.usuarioPara.uid);
  }

  void _cargarHistorial(String usuarioParaId) async {
    List<Mensaje> chat = await this.chatService.getChat(usuarioParaId);
    final history = chat.map((m) => ChatMessage(
        texto: m.mensaje,
        uid: m.de,
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 0))
          ..forward()));
    setState(() {
      messages.insertAll(0,history);
    });
  }

  void _escucharMensaje(dynamic payload) {
    ChatMessage incomingMessage = new ChatMessage(
      texto: payload['mensaje'],
      uid: payload['de'],
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 3000),
      ),
    );
    setState(() {
      messages.insert(0, incomingMessage);
    });
    incomingMessage.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final usuarioPara = this.chatService.usuarioPara;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              child: Text(usuarioPara.nombre.substring(0, 2),
                  style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(height: 3),
            Text(usuarioPara.nombre,
                style: TextStyle(color: Colors.black87, fontSize: 12)),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                reverse: true,
                physics: BouncingScrollPhysics(),
                itemCount: messages.length,
                itemBuilder: (_, i) => messages[i],
              ),
            ),
            Divider(height: 1),
            //TODO: Caja de texto
            Container(
              child: inputChat(),
            ),
          ],
        ),
      ),
    );
  }

  inputChat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: this.textController,
                focusNode: this.focusNode,
                onSubmitted: _handleSubmit,
                onChanged: (String text) {
                  if (text.trim().length > 1) {
                    isWriting = true;
                  } else {
                    isWriting = false;
                  }
                  setState(() {});
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Send Message',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text('Send'),
                      onPressed: isWriting
                          ? () => _handleSubmit(this.textController.text)
                          : null,
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 1.0),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: Icon(Icons.send),
                        onPressed: isWriting
                            ? () => _handleSubmit(this.textController.text)
                            : null,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  _handleSubmit(String texto) {
    if (texto.length == 0) return;
    focusNode.requestFocus();
    textController.clear();
    final newMessage = new ChatMessage(
      uid: this.authService.usuario.uid,
      texto: texto,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 13000)),
    );
    messages.insert(0, newMessage);
    newMessage.animationController.forward();
    isWriting = false;
    setState(() {});

    this.socketService.emit('mensaje-personal', {
      'de': authService.usuario.uid,
      'para': this.chatService.usuarioPara.uid,
      'mensaje': texto
    });
  }

  @override
  void dispose() {
    for (ChatMessage message in messages) {
      message.animationController.dispose();
    }
    this.socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}
