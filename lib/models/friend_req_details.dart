class FriendRequestDetail {
  String? userId;
  String? playerOne;
  int? status;
  String? colour;
  String? time;
  String? gameId;
  String? playerTwo;

  FriendRequestDetail(
      {this.userId,
      this.playerOne,
      this.status,
      this.colour,
      this.time,
      this.gameId,
      this.playerTwo});

  factory FriendRequestDetail.fromJson(Map<String, dynamic> json) {
    return FriendRequestDetail(
      userId: json['userId'],
      playerOne: json['playerOne'],
      status: json['status'],
      colour: json['colour'],
      time: json['time'],
      gameId: json['gameId'],
      playerTwo: json['playerTwo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['playerOne'] = playerOne;
    data['status'] = status;
    data['colour'] = colour;
    data['time'] = time;
    data['gameId'] = gameId;
    data['playerTwo'] = playerTwo;
    return data;
  }
}
