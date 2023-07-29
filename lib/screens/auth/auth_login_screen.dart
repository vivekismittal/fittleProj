import 'package:fittle_ai/common/form_input_field.dart';
import 'package:fittle_ai/resources/components/texts/custom_text.dart';
import 'package:fittle_ai/resources/components/toast.dart';
import 'package:fittle_ai/screens/auth/widgets/country_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../bloc/auth_bloc.dart';
import '../../bloc/loader_bloc.dart';
import '../../bloc/navigation_bloc.dart';
import '../../model/auth_input_detail_model.dart';
import '../../resources/components/custom_button.dart';
import '../../resources/app_color.dart';
import '../../screens/common/custom_loader_screen.dart';
import '../../utils/constants.dart';
import '../../utils/countries.dart';
import '../../utils/screen_paths.dart';

class AuthLoginScreen extends StatelessWidget {
  const AuthLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreenWithLoader(
      body: BlocProvider(
        create: (context) => AuthBloc(),
        child: AuthLoginBody(),
      ),
      id: ScreenPaths.authLoginScreenPath.name,
    );
  }
}

// ignore: must_be_immutable
class AuthLoginBody extends StatelessWidget {
  AuthLoginBody({super.key});

  bool isProceedButtonEnabled = false;

  String countryCode = countries.first.dialCode;
  TextEditingController mobileEditingController = TextEditingController();
  bool? isTncChecked = true;
  bool? isWhatsappChecked = true;

  @override
  Widget build(BuildContext context) {
    var emitEventFunc = context.read<AuthBloc>().add;
    final theme = Theme.of(context);
    GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

    return Padding(
      padding: const EdgeInsets.only(top: 80, left: 34,right: 34),
      child: Stack(
        children: [
          Form(
            key: loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "👋  Welcome",
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.primary),
                ),
                const SizedBox(height: 12),
                Text(
                  "Let's Take Your\nFirst Step",
                  style: m24_600WhiteTextStyle,
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    text:
                        "To get started, please enter your phone number.\nWe will send you the ",
                    style: p12_400WhiteTextStyle.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                    children: [
                      TextSpan(
                        text: "6 digit",
                        style: p12_400WhiteTextStyle.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(
                        text: " verification code",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100,
                      child: CountryDropDown(
                        onChanged: (val) {
                          countryCode = val;
                        },
                        countryCode: countryCode,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 72,
                        child: FormInputField(
                          label: InputFieldsLabel.mobile,
                          controller: mobileEditingController,
                          style: theme.textTheme.labelLarge,
                          keyboardType: TextInputType.number,
                          contentPadding: const EdgeInsets.all(10),
                          hintText: "Enter your phone number",
                          hintStyle: theme.textTheme.bodySmall?.copyWith(
                              color: AppColor.whiteParaColor.withOpacity(.85)),
                          onChanged: (value) {
                            proceedButtonEvent(
                                emitEventFunc: emitEventFunc,
                                loginFormKey: loginFormKey);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                loginCheckBox(
                  [
                    Expanded(
                      child: Wrap(
                        children: [
                          Text(
                            "Receive updates and reminders on ",
                            style: p12_400WhiteTextStyle,
                          ),
                          SvgPicture.asset(Constant.whatsappSvg),
                          Text(" whatsapp",
                              style: p12_400WhiteTextStyle,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                  onChecked: (value) {
                    isWhatsappChecked = value;
                  },
                  value: isWhatsappChecked,
                ),
                loginCheckBox(
                  [
                    Expanded(
                      child: Wrap(
                        children: [
                          Text(
                            "By signing up, I agree to the ",
                            style: p12_400WhiteTextStyle,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, ScreenPaths.webViewScreen.name,
                                  arguments:
                                      "https://www.fittle.ai/terms-and-conditions");
                            },
                            child: Text("Terms of Service",
                                style: p12_400WhiteTextStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                )),
                          ),
                          Text(
                            " and ",
                            style: p12_400WhiteTextStyle,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, ScreenPaths.webViewScreen.name,
                                  arguments:
                                      "https://www.fittle.ai/privacy-policy");
                            },
                            child: Text(
                              "Privacy Policy",
                              style: p12_400WhiteTextStyle.copyWith(
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                  onChecked: (value) {
                    isTncChecked = value;
                    proceedButtonEvent(
                        emitEventFunc: emitEventFunc, loginFormKey: loginFormKey);
                  },
                  value: isTncChecked,
                ),
                
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom:20.0),
            child: Align(
              alignment: Alignment.bottomCenter,
                    child: BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, authState) {
                        switch (authState.runtimeType) {
                          case AuthOtpSentState:
                            context.read<LoaderBloc>().add(DisabledLoadingEvent(
                                ScreenPaths.authLoginScreenPath.name));
                            context.read<NavigationBloc>().add(ScreenPushedEvent(
                                ScreenPaths.authVerifyScreenPath.name,
                                arguments:
                                    countryCode + mobileEditingController.text));
                            break;
                          case AuthLoginLoadingState:
                            context.read<LoaderBloc>().add(EnabledLoadingEvent(
                                ScreenPaths.authLoginScreenPath.name));
                            break;
                          case AuthLoginErrorState:
                            context.read<LoaderBloc>().add(DisabledLoadingEvent(
                                ScreenPaths.authLoginScreenPath.name));
                            Toast.show(
                                context, (authState as AuthLoginErrorState).message);
                            break;
                          default:
                            break;
                        }
                      },
                      builder: (context, authState) {
                        return customButton(
                          title: "Agree & Proceed".toUpperCase(),
                          context: context,
                          isEnabled: isProceedButtonEnabled,
                          onPressed: () {
                            onAgreeAndProceed(
                              emitEventFunc: emitEventFunc,
                            );
                          },
                          minWidth: 165,
                        );
                      },
                      buildWhen: (previous, current) {
                        if (current is ProceedButtonEnabled &&
                            !isProceedButtonEnabled) {
                          isProceedButtonEnabled = true;
                          return true;
                        } else if (current is ProceedButtonDisabled &&
                            isProceedButtonEnabled) {
                          isProceedButtonEnabled = false;
                          return true;
                        }
                        return false;
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget loginCheckBox(List<Widget> widgetList,
      {required void Function(bool? value) onChecked, required bool? value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
            // ignore: unnecessary_cast
            StatefulBuilder(
              builder: (context, setState) => Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Checkbox(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    checkColor: AppColor.callToActionColor,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    fillColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return AppColor.whiteColor;
                    }),
                    value: value,
                    onChanged: (changedValue) {
                      onChecked(changedValue);
                      setState(() {
                        value = changedValue;
                      });
                    }),
              ),
            ) as Widget,
          ] +
          widgetList,
    );
  }

  void proceedButtonEvent(
      {required void Function(AuthEvent) emitEventFunc,
      required GlobalKey<FormState> loginFormKey}) {
    if (mobileEditingController.text.length == 10 &&
        isTncChecked! &&
        loginFormKey.currentState!.validate()) {
      emitEventFunc(EnabledProceedButtonEvent());
    } else {
      emitEventFunc(DisabledProceedButtonEvent());
    }
  }

  void onAgreeAndProceed({required void Function(AuthEvent) emitEventFunc}) {
    emitEventFunc(
      OtpSentEvent(
        inputRequiredDetail: AuthInputDetailModel(
          mobile: countryCode + mobileEditingController.text,
          isTncAccepted: isTncChecked ?? false,
          isWhatsappSubscribed: isWhatsappChecked ?? false,
        ),
      ),
    );
  }
}
