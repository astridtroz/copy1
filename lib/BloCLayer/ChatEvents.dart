import '/DataLayer/Models/OrderModels/chatMessages.dart';

abstract class ChatEvents {}

class GetChats extends ChatEvents {
  String orderId;

  GetChats({
    required this.orderId,
  });
}

class SendChatMessage extends ChatEvents {
  ChatMessage chatMessage;
  bool didStoreRead;
  bool didCustomerRead;
  String orderId;

  SendChatMessage({
    required this.chatMessage,
    required this.orderId,
    required this.didCustomerRead,
    required this.didStoreRead,
  });
}

class MarkChatRead extends ChatEvents {
  String orderId;

  MarkChatRead({
    required this.orderId,
  });
}
