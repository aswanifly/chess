class AllUsersDetails {
  String? userId;
  String? userName;
  String? userEmail;

  AllUsersDetails({this.userId, this.userName, this.userEmail});

  AllUsersDetails.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    userEmail = json['userEmail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['userId'] = userId;
    data['userName'] = userName;
    data['userEmail'] = userEmail;
    return data;
  }
}