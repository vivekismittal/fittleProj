class OtpVerifiedResponse {
  bool? isUserValidated;
  String? message;
  String? userId;
  bool? isProfileExist;
  String? profileId;
  int? profileIndex;

  OtpVerifiedResponse(
      {this.isUserValidated,
      this.message,
      this.userId,
      this.isProfileExist,
      this.profileId,
      this.profileIndex});

  OtpVerifiedResponse.fromJson(dynamic json) {
    isUserValidated = json["is_user_validated"];
    message = json["message"];
    userId = json["user_id"];
    isProfileExist = json["is_profile_exists"];
    profileId = json["profile_id"];
    profileIndex = json["profile_index"];
  }
}
