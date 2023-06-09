import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_app/constant/constant.dart';
import 'package:flutter_chatgpt_app/model/ChatMessage.dart';
import 'package:flutter_chatgpt_app/widget/chatmessage.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ChatPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

const backgroundColor = Color(0xff343541);
const botBackgroundColor = Color(0xff444654);

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  Future<String> generateResponse(String prompt) async {
    final apikey = apiSecretKey;
    var url = Uri.https('api.openai.com', '/v1/completions');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apikey'
        },
        body: jsonEncode({
          "model": "text-davinci-003",
          "prompt": prompt,
          "max_tokens": 2000,
          "top_p": 1,
          "temperature": 0,
        }));

    Map<String, dynamic> newresponse = jsonDecode(response.body);
    print(newresponse);
    print("KARAN");

    return newresponse['choices'][0]["text"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              "Ask any Questions ? Buddy, ",
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        backgroundColor: botBackgroundColor,
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _buildList(),
            ),
            Visibility(
              visible: isLoading,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  _buildInput(),
                  _buildSubmit(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmit() {
    return Visibility(
      visible: !isLoading,
      child: Container(
        color: botBackgroundColor,
        child: IconButton(
          icon: const Icon(
            Icons.send_rounded,
            color: Color.fromRGBO(142, 142, 160, 1),
          ),
          onPressed: () {
            setState(() {
              _messages.add(ChatMessage(
                  text: _textController.text,
                  chatMessageType: ChatMessageType.user));

              isLoading = true;
              var input = _textController.text;
              _textController.clear();

              Future.delayed(Duration(microseconds: 30))
                  .then((value) => _scrollDown());

              //call chatbot api

              generateResponse(input).then((value) {
                setState(() {
                  isLoading = false;
                  // display the chatbot response
                  _messages.add(ChatMessage(
                      text: value, chatMessageType: ChatMessageType.bot));
                });
              });
              _textController.clear();

              Future.delayed(Duration(microseconds: 30))
                  .then((value) => _scrollDown());
            });
          },
        ),
      ),
    );
  }

  Expanded _buildInput() {
    return Expanded(
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(color: Colors.white),
        controller: _textController,
        decoration: const InputDecoration(
          fillColor: botBackgroundColor,
          filled: true,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  ListView _buildList() {
    return ListView.builder(
        controller: _scrollController,
        itemCount: _messages.length,
        itemBuilder: ((context, index) {
          var message = _messages[index];
          return ChatMessageWidget(
            text: message.text,
            chatMessageType: message.chatMessageType,
          );
        }));
  }
}
