import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import '/BloCLayer/ChatEvents.dart';
import '/DataLayer/Models/OrderModels/chats.dart';

class ChatBloc extends Bloc {
  ChatBloc() {
    _chatEventStream.listen(_mapEventToState);
  }

  StreamController<ChatEvents> _chatEventController =
      StreamController<ChatEvents>.broadcast();
  StreamSink<ChatEvents> get chatEventSink => _chatEventController.sink;
  Stream<ChatEvents> get _chatEventStream => _chatEventController.stream;

  StreamController<Chats> _chatController = StreamController<Chats>.broadcast();
  StreamSink<Chats> get _chatSink => _chatController.sink;
  Stream<Chats> get chatStream => _chatController.stream;

  void _mapEventToState(ChatEvents event) {
    if (event is GetChats) {
      FirebaseFirestore.instance
          .collection("orders")
          .doc(event.orderId)
          .snapshots()
          .listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
        // print("orderBloc.dart: ${snapshot.data["chats"]}");
        Chats _chats = snapshot.data()!["chats"] == null
            ? Chats(chatMessages: [])
            : Chats.fromMap(snapshot.data()!["chats"]);
        _chatSink.add(_chats);
      });
    } else if (event is SendChatMessage) {
      FirebaseFirestore.instance.collection("orders").doc(event.orderId).set(
          {
            "chats": {
              "didStoreRead": event.didStoreRead,
              "didCustomerRead": event.didCustomerRead,
              "chatMessages":
                  FieldValue.arrayUnion([event.chatMessage.toJson()]),
            }
          },
          SetOptions(
            merge: true,
          )).then((onValue) {
        print("Message Sent");
      });
    } else if (event is MarkChatRead) {
      FirebaseFirestore.instance.collection("orders").doc(event.orderId).set(
          {
            "chats": {
              "didStoreRead": true,
            }
          },
          SetOptions(
            merge: true,
          ));
    }
  }

  @override
  void dispose() {
    _chatController.close();
    _chatEventController.close();
  }
}
