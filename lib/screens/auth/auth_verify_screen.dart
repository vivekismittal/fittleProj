import 'package:fittle_ai/resources/components/custom_button.dart';
import 'package:fittle_ai/resources/components/texts/custom_text.dart';
import 'package:fittle_ai/screens/auth/widgets/otp_field.dart';
import 'package:fittle_ai/screens/auth/widgets/otp_resend_timer.dart';
import 'package:fittle_ai/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth_bloc.dart';
import '../../bloc/loader_bloc.dart';
import '../../bloc/navigation_bloc.dart';
import '../../resources/components/buttons/base_text_button.dart';
import '../../resources/components/toast.dart';
import '../../screens/common/custom_loader_screen.dart';
import '../../utils/screen_paths.dart';

class AuthVerifyScreen extends StatelessWidget {
  const AuthVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String mobile = ModalRoute.of(context)!.settings.arguments as String;
    return CustomScreenWithLoader(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocProvider(
        create: (context) => AuthBloc(),
        child: AuthVerifyBody(
          mobile: mobile,
        ),
      ),
      id: ScreenPaths.authVerifyScreenPath.name,
    );
  }
}

class AuthVerifyBody extends StatelessWidget {
  const AuthVerifyBody({super.key, required this.mobile});

  final String mobile;
  @override
  Widget build(BuildContext context) {
    final GlobalKey<OtpTimerState> otpTimerKey = GlobalKey();
    bool isVerifyButtonEnabled = false;
    String finalOtp = "";
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "👋  Welcome",
            style: p10_400WhiteTextStyle.copyWith(
                color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 12),
          Text(
            "Let's Take Your\nFirst Step",
            style: m24_600WhiteTextStyle,
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              text: "Enter OTP Received on ",
              style: p12_400WhiteTextStyle,
              children: [
                TextSpan(
                  text: mobile,
                  style: p12_400WhiteTextStyle.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 44,
          ),
          InputOtpField(
            onOtpIncompleted: (otp) {
              if (isVerifyButtonEnabled) {
                context.read<AuthBloc>().add(DisabledVerifyButtonEvent());
              }
            },
            onOtpCompleted: (otp) {
              finalOtp = otp;
              if (!isVerifyButtonEnabled) {
                context.read<AuthBloc>().add(EnabledVerifyButtonEvent());
              }
            },
            otpLength: Constant.otpLength,
          ),
          const SizedBox(height: 54),
          Center(
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, authState) {
                switch (authState.runtimeType) {
                  case AuthVerifyLoadingState:
                    context.read<LoaderBloc>().add(EnabledLoadingEvent(
                        ScreenPaths.authVerifyScreenPath.name));
                    break;
                  case AuthOtpResentState:
                    otpTimerKey.currentState?.startTimer();
                    context.read<LoaderBloc>().add(
                          DisabledLoadingEvent(
                              ScreenPaths.authVerifyScreenPath.name),
                        );
                    Toast.show(
                        context, (authState as AuthOtpResentState).message);
                    break;

                  case AuthOtpVerifiedState:
                    String screenPath =
                        ScreenPaths.profileCompletionScreenPath.name;
                    int? index;
                    if ((authState as AuthOtpVerifiedState).isProfileExist &&
                        authState.profileIndex != null) {
                      index = authState.profileIndex;
                      if (authState.profileIndex == -1) {
                        screenPath = ScreenPaths.homeDashBoardPath.name;
                      }
                    }
                    context.read<NavigationBloc>().add(
                        ScreenPushedAndRemoveUntilEvent(screenPath, "",
                            arguments: index));
                    break;
                  case AuthVerificationErrorState:
                    context.read<LoaderBloc>().add(DisabledLoadingEvent(
                        ScreenPaths.authVerifyScreenPath.name));
                    Toast.show(context,
                        (authState as AuthVerificationErrorState).message);
                    break;
                  default:
                    break;
                }
              },
              builder: (context, authState) {
                return customButton(
                  isEnabled: isVerifyButtonEnabled,
                  title: "          ${"verify".toUpperCase()}          ",
                  context: context,
                  onPressed: () {
                    if (finalOtp.isNotEmpty) {
                      context.read<AuthBloc>().add(OtpVerifiedEvent(finalOtp));
                    } else {}
                  },
                );
              },
              buildWhen: (previous, current) {
                if (current is VerifyButtonEnabled) {
                  isVerifyButtonEnabled = true;
                  return true;
                } else if (current is VerifyButtonDisabled) {
                  isVerifyButtonEnabled = false;
                  return true;
                }
                return false;
              },
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
            child: OtpTimer(
              key: otpTimerKey,
              resendButtonCallback: () {
                context.read<AuthBloc>().add(OtpResentEvent());
              },
            ),
          )
        ],
      ),
    );
  }
}
