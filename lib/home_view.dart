import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_impelentation/message_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Message> messages = [];
  final controller = TextEditingController();
  late Socket socket;
  @override
  void initState() {
    super.initState();
    socket = io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
      "query": {
        'username': 'Collins01',
      }
    });
    _connectToServer();
  }

  void _connectToServer() {
    socket.onConnect((data) {
      log('Connected Succesfully ');
      socket.emit("Collins Joined");
    });
    socket.onConnectError((data) => log("onConnectError : $data"));
    socket.onDisconnect((data) => log("Socket Disconnected"));
    socket.on('message', (data) {
      // ignore: avoid_print
      print(data.toString());
      // ignore: avoid_print
      print(data.runtimeType);
      Message msg = Message.fromJson(data);

      setState(() {
        messages.add(msg);
      });
    });
  }

  _sendMessage() {
    socket.emit(
      'message',
      {
        'message': controller.text.trim(),
        'sender': 'Collins01',
      },
    );
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.green,
        body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (_, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 15,
                      right: 10,
                      bottom: 10,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          messages[index].message,
                        ),
                        Text(
                          messages[index].sender,
                        )
                      ],
                    )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(hintText: "Send Message"),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (controller.text.trim().isNotEmpty) {
                      _sendMessage();
                    }
                    return;
                  },
                  icon: const Icon(Icons.send),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}
