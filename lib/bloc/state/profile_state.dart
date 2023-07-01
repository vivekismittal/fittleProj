import 'package:fittle_ai/model/profile_data.dart';

class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileCreatedUpdatedState extends ProfileState {
  final int nextPageIndex;
final ProfileData? profileData;
final bool isProfileComplete;
  ProfileCreatedUpdatedState(this.nextPageIndex, this.profileData, this.isProfileComplete);
}

class ProfileLoadingState extends ProfileState {}

class ProfileErrorState extends ProfileState {
  final String message;

  ProfileErrorState(this.message);
}

class ProfileBackState extends ProfileState {}

class UserIdNotFoundState extends ProfileState {}

class ProfileEnabledProceedState extends ProfileState {
  final int index;

  ProfileEnabledProceedState(this.index);
}

class ProfileDisabledProceedState extends ProfileState {
  final int index;

  ProfileDisabledProceedState(this.index);
}

class ProfileFetchUserDataLoadingState extends ProfileState {}

class ProfileFetchUserDataErrorState extends ProfileState {
  final String message;

  ProfileFetchUserDataErrorState(this.message);
}

class ProfileFetchUserDataState extends ProfileState {
  final ProfileData data;

  ProfileFetchUserDataState(this.data);
}
