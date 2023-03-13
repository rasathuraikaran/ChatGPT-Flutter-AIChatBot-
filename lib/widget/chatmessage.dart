import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_chatgpt_app/model/ChatMessage.dart';

import '../main.dart';

class ChatMessageWidget extends StatelessWidget {

  final String ? text;
  final ChatMessageType  ? chatMessageType;

  const ChatMessageWidget({super.key, this.text, this.chatMessageType});
  

  @override
  Widget build(BuildContext context) {
    return Container(
 margin: EdgeInsets.symmetric(vertical: 10),
   padding: const EdgeInsets.all(16),
      color: chatMessageType == ChatMessageType.bot
          ? botBackgroundColor
          : backgroundColor,
          child: Row(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           chatMessageType == ChatMessageType.bot ? Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  child: CircleAvatar(
                    backgroundColor: const Color.fromRGBO(16, 163, 127, 1),
                    child: Icon(
                      Icons.rocket,
                    ),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  child: const CircleAvatar(
                    child: Icon(
                      Icons.person,
                    ),
                  ),
                ),
                Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Text(
                    text!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
          ),


    );
  }
}