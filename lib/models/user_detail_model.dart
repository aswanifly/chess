class CurrentUserDetail {
  String id;
  String userName;
  String email;
  String token;

  CurrentUserDetail({
    required this.id,
    required this.userName,
    required this.email,
    required this.token,
  });

  factory CurrentUserDetail.fromJson(Map<String, dynamic> json) {
    return CurrentUserDetail(
        id: json["_id"],
        userName: json["UserName"],
        email: json["Email"],
        token: json["Token"]);
  }
}
