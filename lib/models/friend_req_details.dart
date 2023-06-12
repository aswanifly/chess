class FriendRequestDetail {
  String? userId;
  int? status;
  String? colour;
  String? time;
  String? gameId;

  FriendRequestDetail(
      {this.userId, this.status, this.colour, this.time, this.gameId});

  factory FriendRequestDetail.fromJson(Map<String, dynamic> json) {
    return FriendRequestDetail(
      userId: json['userId'],
      status: json['status'],
      colour: json['colour'],
      time: json['time'],
      gameId: json['gameId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['status'] = status;
    data['colour'] = colour;
    data['time'] = time;
    data['gameId'] = gameId;
    return data;
  }
}
