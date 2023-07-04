import 'package:fittle_ai/bloc/loader_bloc.dart';
import 'package:fittle_ai/bloc/profile_bloc.dart';
import 'package:fittle_ai/bloc/state/profile_state.dart';
import 'package:fittle_ai/model/profile_data.dart';
import 'package:fittle_ai/resources/components/app_loader.dart';
import 'package:fittle_ai/resources/components/internet_connectivity_check.dart';
import 'package:fittle_ai/resources/components/toast.dart';
import 'package:fittle_ai/resources/components/try_again.dart';
import 'package:fittle_ai/resources/resources.dart';
import 'package:fittle_ai/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/event/profile_event.dart';
import '../common/form_input_field.dart';
import '../utils/countries.dart';
import '../utils/screen_paths.dart';

class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileData? userData;
    return InternetConnectivityChecked(
      onTryAgain: () {
        fetchProfile(context);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22, vertical: 100),
        child:
         BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileErrorState) {
              context.read<LoaderBloc>().add(
                    DisabledLoadingEvent(
                      ScreenPaths.homeDashBoardPath.name,
                    ),
                  );
              Toast.show(context, state.message);
            }
            if (state is ProfileCreatedUpdatedState) {
              context.read<LoaderBloc>().add(
                    DisabledLoadingEvent(
                      ScreenPaths.homeDashBoardPath.name,
                    ),
                  );
              fetchProfile(context);
            }
          },
          buildWhen: (previous, current) =>
              current is ProfileFetchUserDataState ||
              current is ProfileFetchUserDataErrorState ||
              current is ProfileLoadingState,
          builder: (context, state) {
            if (state is ProfileFetchUserDataState) {
              userData = state.data;
              // else if (state is ProfileCreatedUpdatedState) {
              //   context.read<LoaderBloc>().add(
              //         DisabledLoadingEvent(
              //           ScreenPaths.homeDashBoardPath.name,
              //         ),
              //       );
              //   fetchProfile(context);
              // }
              String countryCode = userData?.profileData?.mobile?.substring(
                      0, (userData?.profileData?.mobile?.length ?? 0) - 10) ??
                  "+91";
              String mobile = userData?.profileData?.mobile?.substring(
                      (userData?.profileData?.mobile?.length ?? 0) - 10) ??
                  "";
              String content =
                  "Get a free premium subscription by joining our waitlist. Enjoy personalized food diet plans and workout regimens as one of our top 500 users. Don't miss out!";
              TextEditingController emailController =
                  TextEditingController(text: userData?.profileData?.email);
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Don't miss the chance",
                    style: m24_600WhiteTextStyle.copyWith(
                        color: AppColor.offBlackColor),
                  ),
                  SizedBox(height: 10),
                  Text(
                    content,
                    style: p12_400GreyTextStyle,
                  ),
                  // Spacer(),
                  SizedBox(height: 16),
                  if (userData?.profileData?.isWaitListJoined ?? false)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Thank you for joining the waitlist!",
                              style: p14_500BlackTextStyle,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            successTick(height: 200, width: 200),
                          ],
                        ),
                      ],
                    ),
                  if (!(userData?.profileData?.isWaitListJoined ?? false))
                    Column(
                      children: [
                        Text(
                          "Your Phone Number",
                          style: p10_400LBlackTextStyle,
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          height: 44,
                          child: Row(
                            children: [
                              Container(
                                height: 44,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColor.whiteColor.withOpacity(0.3),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: Text(
                                          countries
                                              .firstWhere((element) =>
                                                  element.dialCode ==
                                                  countryCode)
                                              .flag,
                                          style: const TextStyle(fontSize: 24),
                                        )
                                        // icon,
                                        ),
                                    Text(
                                      " $countryCode",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppColor.blackColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: FormInputField(
                                  enabled: false,
                                  label: InputFieldsLabel.normal,
                                  radius: 10,
                                  hintText: "Enter your Mobile",
                                  controller:
                                      TextEditingController(text: mobile),
                                  style: p12_400BlackTitleTextStyle,
                                  contentPadding: const EdgeInsets.all(12),
                                  showCursor: true,
                                  cursorColor: AppColor.blackColor,
                                  hintStyle: p12_400GreyTextStyle,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        Text(
                          "Your Email Address",
                          style: p10_400LBlackTextStyle,
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          height: 44,
                          child: FormInputField(
                            label: InputFieldsLabel.normal,
                            radius: 10,
                            hintText: "Enter your Email",
                            controller: emailController,
                            style: p12_400BlackTitleTextStyle,
                            contentPadding: const EdgeInsets.all(12),
                            showCursor: true,
                            cursorColor: AppColor.blackColor,
                            hintStyle: p12_400GreyTextStyle,
                          ),
                        ),
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                if (emailController.text.isEmpty ||
                                    !emailController.text.isValidEmail()) {
                                  Toast.show(
                                      context, "Please fill valid email");
                                  return;
                                }
                                context.read<ProfileBloc>().add(
                                      ProfileCreatedUpdatedEvent(
                                        7,
                                        {
                                          "email": emailController.text,
                                          "is_waitlist_joined": true
                                        },
                                      ),
                                    );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColor.progressBarColor,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Text(
                                    "Join the WaitList",
                                    style: p14_500WhiteTextStyle,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                  Spacer(),
                ],
              );
            } else if (state is ProfileFetchUserDataErrorState) {
              return TryAgain(
                onTryAgain: () {
                  fetchProfile(context);
                },
              );
            }
            return Center(child: darkAppLoader());
          },
        ),
      ),
    );
  }

  void fetchProfile(BuildContext context) {
    context.read<ProfileBloc>().add(ProfileFetchUserDataEvent());
  }
}
