import 'package:fittle_ai/model/profile_data.dart';

class ProfileEvent {}

class ProfileCreatedUpdatedEvent extends ProfileEvent {
  final int currentIndex;
  final Map<String, dynamic> data;
  final bool isProfileFinished;
  final ProfileData? profileData;
  ProfileCreatedUpdatedEvent(
    this.currentIndex,
    this.data, {
    this.isProfileFinished = false,
    this.profileData,
  });
}

class ProfileBackEvent extends ProfileEvent {}

class ProfileEnabledProceedEvent extends ProfileEvent {
  final int index;

  ProfileEnabledProceedEvent(this.index);
}

class ProfileDisabledProceedEvent extends ProfileEvent {
  final int index;

  ProfileDisabledProceedEvent(this.index);
}

class ProfileFetchUserDataEvent extends ProfileEvent {}
