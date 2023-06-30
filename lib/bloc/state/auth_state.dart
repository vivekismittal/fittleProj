abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoginLoadingState extends AuthState {}

class ProceedButtonEnabled extends AuthState {}

class ProceedButtonDisabled extends AuthState {}

class VerifyButtonEnabled extends AuthState {}

class VerifyButtonDisabled extends AuthState {}

class AuthOtpSentState extends AuthState {
  final String message;

  AuthOtpSentState({required this.message});
}

class AuthLoginErrorState extends AuthState {
  final String message;

  AuthLoginErrorState({required this.message});
}

class AuthVerifyLoadingState extends AuthState {}

class AuthOtpVerifiedState extends AuthState {
  final String message;
  final bool isProfileExist;
  final String? profileId;
  final int? profileIndex;
  AuthOtpVerifiedState(
   {   required this.message,
   
   required this.isProfileExist,
    this.profileId,
    this.profileIndex,
  });
}

class AuthVerificationErrorState extends AuthState {
  final String message;

  AuthVerificationErrorState({required this.message});
}

class AuthOtpResentState extends AuthState {
  final String message;

  AuthOtpResentState({required this.message});
}
