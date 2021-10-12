import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/material.dart';
import 'package:navigator/components/topbar/top_bar.dart';
import 'package:navigator/layouts/default_layout.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// ignore: must_be_immutable
class Chat extends StatefulWidget {
  static const String routeName = '/examples/chat';
  String user;

  Chat({Key? key, this.user = 'sender01'}) : super(key: key);

  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  late TextEditingController _messageController;
  late ScrollController _controller;
  late IO.Socket socket;
  final List<dynamic> messages = [];

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _controller = ScrollController();
    initSocket();
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => {
        _controller.animateTo(
          0.0,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn,
        )
      },
    );
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
    return DefaultLayout(
      backgroundColor: Colors.grey[300]!,
      body: Column(
        children: [
          TopBar(title: 'Chat'),
          Expanded(child: renderMain(size)),
        ],
      ),
    );
  }

  Widget renderMain(Size size) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          bottom: 60,
          width: size.width,
          child: renderListView(),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            height: 60,
            color: Colors.white,
            child: renderTextInput(size),
          ),
        )
      ],
    );
  }

  Widget renderListView() {
    return ListView.builder(
      controller: _controller,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      reverse: true,
      cacheExtent: 1000,
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int index) {
        var message = messages[messages.length - index - 1];
        final sender = message['sender'];
        final time = message['time'];
        final msg = message['message'];

        return (sender == widget.user)
            ? renderSendMessage('@$time $msg')
            : renderReturnMessage('$sender @$time $msg');
      },
    );
  }

  Widget renderSendMessage(String text) {
    return BubbleNormal(
      text: text,
      isSender: true,
      color: Color(0xFFE8E8EE),
      tail: true,
      sent: true,
    );
  }

  Widget renderReturnMessage(String text) {
    return BubbleNormal(
      text: text,
      isSender: false,
      color: Color(0xFF1B97F3),
      tail: true,
      textStyle: TextStyle(
        fontSize: 20,
        color: Colors.white,
      ),
    );
  }

  Widget renderTextInput(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size.width * 0.80,
          padding: EdgeInsets.only(left: 10, right: 5),
          child: renderTextField(),
        ),
        Container(
          width: size.width * 0.20,
          child: IconButton(
            icon: Icon(Icons.send, color: Colors.redAccent),
            onPressed: _sendMessage,
          ),
        )
      ],
    );
  }

  Widget renderTextField() {
    return TextField(
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
    );
  }

  void _sendMessage() {
    String messageText = _messageController.text.trim();
    _messageController.text = '';
    print(messageText);

    if (messageText != '') {
      var messagePost = {
        'message': messageText,
        'sender': widget.user,
        'recipient': 'chat',
        'time': DateTime.now().toUtc().toString().substring(0, 16)
      };
      socket.emit('chat', messagePost);
      setState(() => messages.add(messagePost));
    }
  }
}
