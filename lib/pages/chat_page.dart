import 'dart:io';

import 'package:chat_app_node/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final textController = new TextEditingController();
  final focusNode = new FocusNode();
  bool isWriting = false;
  List<ChatMessage> messages = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              child: Text('Te', style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(height: 3),
            Text('Anonimo',
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
    if(texto.length == 0) return;
    focusNode.requestFocus();
    textController.clear();
    final newMessage = new ChatMessage(
      uid: '123',
      texto: texto,
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 13000)),
    );
    messages.insert(0, newMessage);
    newMessage.animationController.forward();
    isWriting = false;
    setState(() {}); 
  }

  @override
    void dispose() {
      // TODO: Off del Socket
      for(ChatMessage message in messages){
        message.animationController.dispose();
      }
      super.dispose();
    }

}
