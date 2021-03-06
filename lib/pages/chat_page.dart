import 'dart:io';

import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChatPage extends StatefulWidget {

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{
  
  final _textcontroller = new TextEditingController();
  final _focusNode = new FocusNode();
  List<ChatMessage> _messages = [];

  bool _estaEscribiendo = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        
        title: Column(
          children: <Widget>[
            Center(
              child: CircleAvatar(
                child: Text('Te', style: TextStyle(fontSize: 12)),
                backgroundColor: Colors.blue[100],
                maxRadius: 14,
              ),
            ),
            SizedBox(height: 3),
            Text('Alex', style: TextStyle(color: Colors.black, fontSize: 12 ),)
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (_,i)=> _messages[i],
                reverse: true,
              )
            ),
            Divider(height: 1,),
            //TODO CAJA DE TEXTO 
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
   );
  }

  Widget _inputChat(){

    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal:8),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textcontroller,
                onSubmitted: _handleSubmit,
                //TODO 
                onChanged: ( texto){
                  setState(() {
                    if(texto.trim().length > 0){
                      _estaEscribiendo = true;
                    }else{
                      _estaEscribiendo = false;
                    }
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enviar mensaje',
                ),
                focusNode: _focusNode,
              )
            ),
            //Boton de enviar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS
              ? CupertinoButton(
                child: Text('Enviar'), 
                onPressed: _estaEscribiendo 
                    ? ()=> _handleSubmit(_textcontroller.text.trim())
                    : null,
              )
              : Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: IconTheme(
                  data: IconThemeData(color: Colors.blue[400]),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: Icon(Icons.send),
                    onPressed: _estaEscribiendo 
                    ? ()=> _handleSubmit(_textcontroller.text.trim())
                    : null,
                  ),
                ),
              )
            )
          ],
        ),
      )
    );

  }
  _handleSubmit(String texto){
    if(texto.length == 0) return;
    print(texto);
    _textcontroller.clear();
    _focusNode.requestFocus();

    final newMessage = new ChatMessage(
      uid: '123', 
      texto: texto,
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      
      _estaEscribiendo = false;
    });
    
  }
  @override
  void dispose() {
    // TODO: off del socket
    for(ChatMessage message in _messages){
      message.animationController.dispose();
    }
    super.dispose();
  }
}