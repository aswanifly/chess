class ChatMessage {
  String? move;
  String? userId;

  ChatMessage({this.move, this.userId});

 factory ChatMessage.fromJson(Map<String, dynamic> json) {
   return ChatMessage(
       move : json['move'],
       userId : json['userId'],
   );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['move'] = move;
    data['userId'] = userId;
    return data;
  }
}