class Jwt {
  String accessToken;
  String refreshToken;

  Jwt({required this.accessToken, required this.refreshToken});

  static Jwt fromJson(Map<String, dynamic> json) {
    return Jwt(
        accessToken: json['access_token'], refreshToken: json['refresh_token']);
  }
}
