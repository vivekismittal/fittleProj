import 'package:fittle_ai/model/otp_verified_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/event/auth_event.dart';
import '../bloc/state/auth_state.dart';
import '../model/hash_token_model.dart';
import '../repository/auth_repo.dart';
import '../repository/shared_repo.dart';
import '../utils/singleton.dart';

export './event/auth_event.dart';
export './state/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo _authRepo = AuthRepo();
  final SharedRepo _sharedRepo = Singleton().sharedRepo;

  AuthBloc() : super(AuthInitialState()) {
    on<OtpSentEvent>(_onOtpSentEvent);
    on<OtpResentEvent>(_onOtpResentEvent);
    on<OtpVerifiedEvent>(_onOtpVerifiedEvent);
    on<EnabledProceedButtonEvent>(_onEnabledProceedButtonEvent);
    on<DisabledProceedButtonEvent>(_onDisabledProceedButtonEvent);
    on<EnabledVerifyButtonEvent>(
      (event, emit) => emit(VerifyButtonEnabled()),
    );
    on<DisabledVerifyButtonEvent>(
      (event, emit) => emit(VerifyButtonDisabled()),
    );
  }

  void _onEnabledProceedButtonEvent(
      EnabledProceedButtonEvent event, Emitter emit) {
    emit(ProceedButtonEnabled());
  }

  void _onDisabledProceedButtonEvent(
      DisabledProceedButtonEvent event, Emitter emit) {
    emit(ProceedButtonDisabled());
  }

  void _onOtpSentEvent(OtpSentEvent event, Emitter emit) async {
    emit(AuthLoginLoadingState());
    try {
      var data = {
        "mobile": event.inputRequiredDetail.mobile,
        "platform": "app",
        "type": "mobile",
        "is_tnc_accepted": event.inputRequiredDetail.isTncAccepted,
        "is_whatsapp_subscribed":
            event.inputRequiredDetail.isWhatsappSubscribed,
      };
      HashToken hashTokenWithMessage = await _authRepo.sendOtp(data);
      if (hashTokenWithMessage.hashToken != null &&
          hashTokenWithMessage.message != null) {
        await _sharedRepo.saveHashToken(hashTokenWithMessage.hashToken!);
        emit(AuthOtpSentState(message: hashTokenWithMessage.message!));
      }
    } catch (e, s) {
      addError(e, s);
      emit(AuthLoginErrorState(message: "$e"));
    }
  }

  void _onOtpVerifiedEvent(OtpVerifiedEvent event, Emitter emit) async {
    emit(AuthVerifyLoadingState());
    try {
      var hashToken = await _sharedRepo.readHashToken();
      dynamic data = {"hash_token": hashToken, "otp": event.inputOtp};

      OtpVerifiedResponse otpVerifiedResponse = await _authRepo.verifyOtp(data);
      var isUserValidated = otpVerifiedResponse.isUserValidated;
      var userId = otpVerifiedResponse.userId;
      // print(isUserValidated);
      if (isUserValidated != null && isUserValidated && userId != null) {
        await _sharedRepo.saveUserId(userId);
        if (otpVerifiedResponse.profileId != null &&
            otpVerifiedResponse.profileIndex != null) {
          await _sharedRepo.saveProfileId(otpVerifiedResponse.profileId!);
            await _sharedRepo.saveProfileIndex(otpVerifiedResponse.profileIndex!);
        }
        emit(
          AuthOtpVerifiedState(
              message:
                  otpVerifiedResponse.message ?? "OTP Validated Successfully.",
              isProfileExist: otpVerifiedResponse.isProfileExist!,
              profileId: otpVerifiedResponse.profileId,
              profileIndex: otpVerifiedResponse.profileIndex),
        );
      } else {
        emit(AuthVerificationErrorState(
            message: otpVerifiedResponse.message ?? "OTP not Verified"));
      }
    } catch (e) {
      // print(e);
      addError(e);
      emit(AuthVerificationErrorState(message: e.toString()));
    }
  }

  void _onOtpResentEvent(OtpResentEvent event, Emitter emit) async {
    emit(AuthVerifyLoadingState());
    try {
      var hashToken = await _sharedRepo.readHashToken();
      dynamic data = {"hash_token": hashToken};

      HashToken hashTokenWithMessage = await _authRepo.resendOtp(data);
      var newHashToken = hashTokenWithMessage.hashToken;
      var message = hashTokenWithMessage.message;
      if (newHashToken != null && message != null) {
        await _sharedRepo.saveHashToken(newHashToken);
        emit(AuthOtpResentState(message: message));
      }
    } catch (e) {
      addError(e);
      emit(AuthVerificationErrorState(message: e.toString()));
    }
  }
}
