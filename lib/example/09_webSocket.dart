import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketExample extends StatefulWidget {
  static const String routeName = '/examples/web_socket';
  // final channel = IOWebSocketChannel.connect('ws://211.218.24.94:3000');
  final channel = IOWebSocketChannel.connect(Uri.parse('ws://echo.websocket.org'));

  @override
  _WebSocketExampleState createState() => _WebSocketExampleState();
}

class _WebSocketExampleState extends State<WebSocketExample> {
  TextEditingController _controller = TextEditingController();
  // SocketIO socketIO;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Web Socket Example"),
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
            StreamBuilder(
              stream: widget.channel.stream,
              builder: (context, snapshot) {
                print("StreamBuilder");
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ),
    );
  }

  void _sendMessage() {
    final text = _controller.text;
    print("text:$text");

    if (_controller.text.isNotEmpty) {
      widget.channel.sink.add(_controller.text);
    }
  }
}
