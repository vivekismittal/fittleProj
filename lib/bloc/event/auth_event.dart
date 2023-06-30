import 'package:fittle_ai/model/auth_input_detail_model.dart';

abstract class AuthEvent {}

class OtpSentEvent extends AuthEvent {
  final AuthInputDetailModel inputRequiredDetail;

  OtpSentEvent({
    required this.inputRequiredDetail,
  });
}

class OtpVerifiedEvent extends AuthEvent {
  final String inputOtp;

  OtpVerifiedEvent(
    this.inputOtp,
  );
}

class EnabledProceedButtonEvent extends AuthEvent {}
class DisabledProceedButtonEvent extends AuthEvent {}

class EnabledVerifyButtonEvent extends AuthEvent {}
class DisabledVerifyButtonEvent extends AuthEvent {}

class OtpResentEvent extends AuthEvent{}