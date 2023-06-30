class CreateUpdateProfileResponse {
  String? profileId;
  String? message;
  int? nextProfileIndex;
  bool? isUserEmailVerified;

  CreateUpdateProfileResponse.fromJson(dynamic json) {
    profileId = json["profile_id"];
    message = json["message"];
    nextProfileIndex = json["next_profile_index"] as int;
    isUserEmailVerified = json["is_user_email_verified"] as bool;
  }
}
