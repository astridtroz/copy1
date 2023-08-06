import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import '/BloCLayer/ChatBloc.dart';
import '/BloCLayer/ChatEvents.dart';
import '/DataLayer/Models/OrderModels/chatMessages.dart';
import '/DataLayer/Models/OrderModels/chats.dart';

class ChatScreen extends StatelessWidget {
  final String orderId;
  final String customerName;

  ChatScreen({
    required this.orderId,
    required this.customerName,
  });

  final TextEditingController _messageController = TextEditingController();

  final ScrollController _scrollController = ScrollController(
    initialScrollOffset: 0,
  );

  @override
  Widget build(BuildContext context) {
    ChatBloc _chatBloc = BlocProvider.of<ChatBloc>(context);
    _initialize(_chatBloc);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Customer Chat"),
            Text(
              "$customerName",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(6),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            StreamBuilder(
              stream: _chatBloc.chatStream,
              builder:
                  (BuildContext buildContext, AsyncSnapshot<Chats> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error Occured. Please try later"),
                    );
                  } else {
                    return Expanded(
                      child: SingleChildScrollView(
                        reverse: true,
                        controller: _scrollController,
                        child: Column(
                          children: snapshot.data!.chatMessages!
                              .map((c) => ChatBox(
                                    text: c.message!,
                                    isSelf: !c.isStore!,
                                  ))
                              .toList(),
                        ),
                      ),
                    );
                  }
                } else {
                  return Center(
                    child: Text("No Chats"),
                  );
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 250,
                  ),
                  child: TextField(
                    controller: _messageController,
                    autofocus: true,
                    maxLines: null,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp("[\\\\*]")),
                    ],
                    decoration: InputDecoration(
                      hintText: "Type your message ...",
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // String message = _messageController.text.trim();
                    if (_messageController.text != "") {
                      _chatBloc.chatEventSink.add(
                        SendChatMessage(
                          didCustomerRead: true,
                          didStoreRead: false,
                          chatMessage: ChatMessage(
                            dateTime: DateTime.now(),
                            message: _messageController.text,
                            isStore: false,
                          ),
                          orderId: orderId,
                        ),
                      );
                    }
                    _messageController.clear();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _initialize(ChatBloc chatBloc) async {
    chatBloc.chatEventSink.add(
      GetChats(orderId: this.orderId),
    );
    chatBloc.chatEventSink.add(
      MarkChatRead(orderId: this.orderId),
    );
  }
}

class ChatBox extends StatelessWidget {
  final String text;
  final bool isSelf;

  ChatBox({
    required this.text,
    required this.isSelf,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSelf ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(3),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.66,
        ),
        decoration: BoxDecoration(
          // borderRadius: Constants.constBorderRadius,
          color: isSelf ? Colors.green : Colors.blue,
        ),
        child: Text(text),
      ),
    );
  }
}
