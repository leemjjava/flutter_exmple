
import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';

class WebSocketView extends StatefulWidget {
  static const String routeName = '/navigator/web_socket';

  @override
  _WebSocketViewState createState() => _WebSocketViewState();
}

class _WebSocketViewState extends State<WebSocketView> {
  TextEditingController _controller = TextEditingController();

  final String title = "채팅 테스트";
  SocketIO socketIO ;

  @override
  void initState() {
    super.initState();

    socketIO = SocketIOManager().createSocketIO(
        "http://pgrt-Chat-13QOMIE6SJQAB.eba-xcpcujs4.ap-northeast-2.elasticbeanstalk.com:80",
        "/",
        socketStatusCallback: _socketStatus);
    socketIO.init();
    socketIO.subscribe("socket_info", _onSocketInfo);
    _subscribes();
    socketIO.connect();
  }

  _onSocketInfo(dynamic data) {
    print("Socket info: " + data);
  }

  _socketStatus(dynamic data) {
    print("Socket status: " + data);
  }

  _subscribes() {
    if (socketIO != null) {
      socketIO.subscribe("messages", _onReceiveChatMessage);
      socketIO.subscribe("member_add", _onReceiveChatMessage);
      socketIO.subscribe("member_delete", _onReceiveChatMessage);
      socketIO.subscribe("message_history", _onReceiveChatMessage);
    }
  }

  void _onReceiveChatMessage(dynamic message) {
    print("Message from UFO: " + message);
  }

  void _sendChatMessage() async {
    String msg = _controller.text;
    if (socketIO != null) {
      String jsonData = '{"message":{"type":"Text","content": ${(msg != null && msg.isNotEmpty) ? '"${msg}"' : '"Hello SOCKET IO PLUGIN :))"'},"owner":"589f10b9bbcd694aa570988d","avatar":"img/avatar-default.png"},"sender":{"userId":"589f10b9bbcd694aa570988d","first":"Ha","last":"Test 2","location":{"lat":10.792273999999999,"long":106.6430356,"accuracy":38,"regionId":null,"vendor":"gps","verticalAccuracy":null},"name":"Ha Test 2"},"receivers":["587e1147744c6260e2d3a4af"],"conversationId":"589f116612aa254aa4fef79f","name":null,"isAnonymous":null}';
      socketIO.sendMessage("chat_direct", jsonData, _onReceiveChatMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Send a message'),
              ),
            ),
            getMainView(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendChatMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ),
    );
  }

  Widget getMainView(){
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(100),
      child: LinearProgressIndicator(
        minHeight: 5,
        backgroundColor: Colors.transparent,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey),
      ),
    );
  }


  @override
  void dispose() {
    if (socketIO != null) SocketIOManager().destroySocket(socketIO);
    super.dispose();
  }
}