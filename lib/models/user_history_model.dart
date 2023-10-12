class UserHistoryModel {
  String? senderId;
  String? reciverId;
  String? status;
  String? gameId;
  String? playerName;

  UserHistoryModel(
      {this.senderId,
        this.reciverId,
        this.status,
        this.gameId,
        this.playerName});

  UserHistoryModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    reciverId = json['reciverId'];
    status = json['status'];
    gameId = json['gameId'];
    playerName = json['playerName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['senderId'] = senderId;
    data['reciverId'] = reciverId;
    data['status'] = status;
    data['gameId'] = gameId;
    data['playerName'] = playerName;
    return data;
  }
}
