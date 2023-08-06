import '/DataLayer/Models/OrderModels/chatMessages.dart';

class Chats {
  bool? didStoreRead;
  bool? didCustomerRead;
  List<ChatMessage>? chatMessages;

  Chats({
    required this.chatMessages,
    this.didCustomerRead = true,
    this.didStoreRead = true,
  });

  Chats.fromMap(Map<String, dynamic> map) {
    if (map != null) {
      this.didStoreRead = map["didStoreRead"] ?? true;
      this.didCustomerRead = map["didCustomerRead"] ?? true;
      this.chatMessages = [];
      int _length = map["chatMessages"]?.length ?? 0;
      // print("length: ${map["chatMessage"]}");
      for (int i = 0; i < _length; i++) {
        chatMessages?.add(ChatMessage.fromMap(map["chatMessages"][i]));
      }
    } else {
      this.didCustomerRead = true;
      this.didStoreRead = true;
      // this.chatMessages = [];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "didStoreRead": this.didStoreRead,
      "didCustomerRead": this.didCustomerRead,
      "chatMessages":
          List<dynamic>.from(this.chatMessages!.map((c) => c.toJson())),
    };
  }

  @override
  String toString() {
    return '''Chats{
      didStoreRead: $didStoreRead 
    didCustomerRead: $didCustomerRead 
    chatMessages: $chatMessages} ''';
  }
}

Chats sampleChats = Chats(
  didStoreRead: false,
  didCustomerRead: false,
  chatMessages: [
    ChatMessage(
        dateTime: DateTime.now(),
        message:
            "1HelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHello",
        isStore: true),
    ChatMessage(dateTime: DateTime.now(), message: "2Hellwo", isStore: false),
    ChatMessage(dateTime: DateTime.now(), message: "3Hellows", isStore: true),
    ChatMessage(dateTime: DateTime.now(), message: "4Helalo", isStore: false),
    ChatMessage(
        dateTime: DateTime.now(),
        message:
            "5HeleafloHeleafloHeleafloHeleafloHeleafloHeleafloHeleafloHeleafloHeleafloHeleaflo",
        isStore: true),
    ChatMessage(dateTime: DateTime.now(), message: "6sHessllo", isStore: false),
    ChatMessage(dateTime: DateTime.now(), message: "7Helsslo", isStore: true),
    ChatMessage(
        dateTime: DateTime.now(),
        message: '''8HelqloHelqloHelqloHelqloHelqloHelqloHelqloHel
            qloHelqloHelqloHelqloHelqloHelqloHelqloHelqloHelq
            loHelqloHelqloHelqloHelqloHelqloHelqloHelqloHelqloHelqloHelqloHelqlo''',
        isStore: false),
    ChatMessage(
        dateTime: DateTime.now(),
        message: '''9HelqloHelqloHelqloHelqloHelqloHelqloHelqloHel
            qloHelqloHelqloHelqloHelqloHelqloHelqloHelqloHelq
            loHelqloHelqloHelqloHelqloHeqloHelqloHelqloHelqloHelqloHelqloHelqlo''',
        isStore: false),
    ChatMessage(
        dateTime: DateTime.now(),
        message: '''10HelqloHelqloHelqloHelqloHelqloHelqloHelqloHel
            qloHelqloHelqloHelqloHelqloHelqloHelqloHelqloHelq
            loHelqloHelqloHelqloHelqloHelqloHelqloHelqloHelqloHelqloHelqloHelqlo''',
        isStore: false),
    ChatMessage(dateTime: DateTime.now(), message: "11Helelo", isStore: true),
  ],
);
