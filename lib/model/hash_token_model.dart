class HashToken {
  String? hashToken;
  String? message;

  HashToken({required this.hashToken, required this.message});

  HashToken.fromJson(dynamic json) {
    hashToken = json["hash_token"];
    message = json["message"];
  }
}
