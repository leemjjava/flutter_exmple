import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// ignore: must_be_immutable
class Chat extends StatefulWidget {
  static const String routeName = '/examples/chat';
  String? user;

  Chat({Key? key, this.user}) : super(key: key);

  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  late TextEditingController _messageController;
  late ScrollController _controller;
  late IO.Socket socket;
  final List<dynamic> messages = [];

  void _sendMessage() {
    String messageText = _messageController.text.trim();
    _messageController.text = '';
    print(messageText);
    if (messageText != '') {
      var messagePost = {
        'message': messageText,
        'sender': widget.user ?? 'sender01',
        'recipient': 'chat',
        'time': DateTime.now().toUtc().toString().substring(0, 16)
      };
      socket.emit('chat', messagePost);
    }
  }

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _controller = ScrollController();
    initSocket();
    WidgetsBinding.instance!.addPostFrameCallback((_) => {
          _controller.animateTo(
            0.0,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeIn,
          )
        });
  }

  void initSocket() {
    print('Connecting to chat service');
    socket = IO.io('https://ff847a462e9a.ngrok.io', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    socket.onConnect((_) {
      print('connected to websocket');
    });
    socket.on('chat', (message) {
      print("chat : $message");
      setState(() => messages.add(message));
    });
    socket.on('allChats', (messages) {
      print("allChats : $messages");
      setState(() => this.messages.addAll(messages));
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.maybeOf(context)!.size;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: size.width * 0.60,
              child: Container(
                child: Text(
                  'Chat',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 60,
            width: size.width,
            child: ListView.builder(
              controller: _controller,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              reverse: true,
              cacheExtent: 1000,
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                var message = messages[messages.length - index - 1];
                return (message['sender'] == widget.user)
                    ? BubbleNormal(
                        text: '@${message['time']} ${message['message']}',
                        isSender: false,
                        color: Color(0xFF1B97F3),
                        tail: true,
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      )
                    : BubbleNormal(
                        text:
                            '${message['sender']} @${message['time']} ${message['message']}',
                        isSender: true,
                        color: Color(0xFFE8E8EE),
                        tail: true,
                        sent: true,
                      );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 60,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: size.width * 0.80,
                    padding: EdgeInsets.only(left: 10, right: 5),
                    child: TextField(
                      controller: _messageController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: "Message",
                        labelStyle: TextStyle(fontSize: 15, color: Colors.black),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        counterText: '',
                      ),
                      style: TextStyle(fontSize: 15),
                      keyboardType: TextInputType.text,
                      maxLength: 500,
                    ),
                  ),
                  Container(
                    width: size.width * 0.20,
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.redAccent),
                      onPressed: () {
                        _sendMessage();
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
