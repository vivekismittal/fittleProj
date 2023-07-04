class ProfileData {
  final ProfileDataClass? profileData;

  ProfileData({
    this.profileData,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        profileData: json["profile_data"] == null
            ? null
            : ProfileDataClass.fromJson(json["profile_data"]),
      );

  // Map<String, dynamic> toJson() => {
  //     "profile_data": profileData?.toJson(),
  // };
}

class ProfileDataClass {
  String? fullName;
  DateTime? dob;
  double? weight;
  int? age;

  double? height;
  String? gender;
  String? mobile;
  String? email;

  String? workoutlevel;
  String? profileImage;
  List<String>? profileGoal;
  String? workingLifestyle;
  bool? isWaitListJoined;

  ProfileDataClass(
      {this.fullName,
      this.dob,
      this.weight,
      this.mobile,
      this.email,
      this.height,
      this.gender,
      this.workoutlevel,
      this.profileImage,
      this.profileGoal,
      this.workingLifestyle,
      this.isWaitListJoined,
      this.age});

  factory ProfileDataClass.fromJson(Map<String, dynamic> json) =>
      ProfileDataClass(
          fullName: json["full_name"],
          dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
          weight: json["weight"],
          height: json["height"],
          gender: json["gender"],
          workoutlevel: json["workoutlevel"],
          profileImage: json["profile_image"],
          email: json["user__email"],
          mobile: json["user__mobile"],
          profileGoal: json["profile_goal"] == null
              ? []
              : List<String>.from(json["profile_goal"]!.map((x) => x)),
          workingLifestyle: json["working_lifestyle"],
          age: json["age"],
          isWaitListJoined: json["user__is_waitlist_joined"]);

  // Map<String, dynamic> toJson() => {
  //     "full_name": fullName,
  //     "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
  //     "weight": weight,
  //     "height": height,
  //     "gender": gender,
  //     "workoutlevel": workoutlevel,
  //     "profile_image": profileImage,
  //     "profile_goal": profileGoal == null ? [] : List<dynamic>.from(profileGoal!.map((x) => x)),
  //     "working_lifestyle": workingLifestyle,
  // };
}
