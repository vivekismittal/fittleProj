import 'package:fittle_ai/bloc/event/profile_event.dart';
import 'package:fittle_ai/bloc/loader_bloc.dart';
import 'package:fittle_ai/bloc/profile_bloc.dart';
import 'package:fittle_ai/bloc/state/profile_state.dart';
import 'package:fittle_ai/model/profile_data.dart';
import 'package:fittle_ai/resources/app_color.dart';
import 'package:fittle_ai/resources/components/internet_connectivity_check.dart';
import 'package:fittle_ai/screens/profile_completion/pages/your_goal_options.dart';
import 'package:fittle_ai/screens/profile_completion/screen_model.dart/profile_completion_data.dart';
import 'package:fittle_ai/utils/extensions.dart';
import 'package:fittle_ai/utils/screen_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/navigation_bloc.dart';
import '../../resources/components/texts/custom_text.dart';
import '../../resources/components/toast.dart';
import '../../utils/singleton.dart';

class ProfileBody extends StatelessWidget {
  final void Function() onUpgradeClick;
  const ProfileBody({super.key, required this.onUpgradeClick});
  void fetchUserData(BuildContext context) {
    context.read<ProfileBloc>().add(ProfileFetchUserDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    ProfileData? userData;
    return InternetConnectivityChecked(
        onTryAgain: () {
          fetchUserData(context);
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: SingleChildScrollView(
              child: BlocConsumer<ProfileBloc, ProfileState>(
                buildWhen: (previous, current) =>
                    current is ProfileFetchUserDataState ||
                    current is ProfileCreatedUpdatedState,
                listener: (context, profileState) {
                  switch (profileState.runtimeType) {
                    case ProfileFetchUserDataErrorState:
                      context.read<LoaderBloc>().add(DisabledLoadingEvent(
                          ScreenPaths.homeDashBoardPath.name));
                      Toast.show(
                          context,
                          (profileState as ProfileFetchUserDataErrorState)
                              .message);
                      break;
                    case ProfileFetchUserDataLoadingState:
                      context.read<LoaderBloc>().add(EnabledLoadingEvent(
                          ScreenPaths.homeDashBoardPath.name));
                      break;
                    case ProfileFetchUserDataState:
                      context.read<LoaderBloc>().add(DisabledLoadingEvent(
                          ScreenPaths.homeDashBoardPath.name));
                      userData =
                          (profileState as ProfileFetchUserDataState).data;
                      break;
                    case ProfileErrorState:
                      context.read<LoaderBloc>().add(DisabledLoadingEvent(
                          ScreenPaths.homeDashBoardPath.name));
                      Toast.show(
                          context, (profileState as ProfileErrorState).message);
                      break;
                    case ProfileLoadingState:
                      context.read<LoaderBloc>().add(EnabledLoadingEvent(
                          ScreenPaths.homeDashBoardPath.name));
                      break;
                    case ProfileCreatedUpdatedState:
                      context.read<LoaderBloc>().add(DisabledLoadingEvent(
                          ScreenPaths.homeDashBoardPath.name));
                      userData = (profileState as ProfileCreatedUpdatedState)
                          .profileData;
                      break;
                  }
                },
                builder: (context, profileState) {
                  if (profileState is ProfileFetchUserDataState ||
                      profileState is ProfileCreatedUpdatedState) {
                    return Column(
                      children: [
                        const SizedBox(height: 54),
                        Container(
                          height: 85,
                          width: 85,
                          padding: const EdgeInsets.all(2),
                          decoration: ShapeDecoration(
                            shape: CircleBorder(
                              side: BorderSide(
                                  color:
                                      AppColor.progressBarColor.withOpacity(.2),
                                  width: 3),
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor:
                                AppColor.progressBarColor.withOpacity(.3),
                            child: const Icon(
                              Icons.person,
                              color: AppColor.lightBlackColor,
                              size: 48,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          userData?.profileData?.fullName ?? "",
                          style: p14_600BlackTitleTextStyle,
                        ),
                        Text(
                          userData?.profileData?.email ?? "",
                          style: p12_400GreyTextStyle,
                        ),
                        const SizedBox(height: 16),
                        ActionChip(
                          backgroundColor: AppColor.progressBarColor,
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 30),
                          label: Text(
                            "Edit",
                            style: p12_500WhiteTextStyle,
                          ),
                          onPressed: () {
                            asyncNavigation(context, userData);
                          },
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            keyValueCard("Height",
                                "${userData?.profileData?.height?.truncate()}ft ${(((userData?.profileData?.height ?? 0) - (userData?.profileData?.height?.truncate() ?? 0)) * 12).round()}in"),
                            keyValueCard("Weight",
                                "${userData?.profileData?.weight?.toString()}kg"),
                            keyValueCard(
                                userData?.profileData?.age.toString() ?? "",
                                "AGE"),
                          ],
                        ),
                        const SizedBox(height: 38),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColor.progressBarColor,
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Check out Fittlehealth Pro ",
                                style: p12_500WhiteTextStyle,
                              ),
                              Text(
                                "Get access to CGM, Smart scale and more.....",
                                style: p8_300ParaTextStyle,
                              ),
                              const SizedBox(height: 12),
                              InkWell(
                                onTap: () {
                                  onUpgradeClick();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: AppColor.whiteColor),
                                  child: Center(
                                    child: Text(
                                      "Upgrade",
                                      style: p12_500BlackTextStyle.copyWith(
                                        color: AppColor.progressBarColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        WorkoutEditingButton(
                          title: "Work Life Style",
                          value: WorkLifeCycleModel.workLifeCycleOptions[
                                  WorkLifeCycleModel.workLifeCycleOptions.keys
                                      .firstWhere(
                                (element) =>
                                    element.toLowerCase() ==
                                    userData?.profileData?.workingLifestyle,
                              )] ??
                              "",
                          onClick: () {
                            showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (ctx) {
                                return ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0),
                                  ),
                                  child: Container(
                                    color: AppColor.whiteColor,
                                    padding: const EdgeInsets.all(22),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                            Text(
                                              "Work Life Style",
                                              style: p14_500BlackTextStyle,
                                            ),
                                            const SizedBox(height: 20),
                                            const Divider(
                                                height: 1,
                                                color: AppColor.offBlackColor),
                                            const SizedBox(height: 20),
                                          ] +
                                          List.generate(
                                            WorkLifeCycleModel
                                                .workLifeCycleOptions.length,
                                            (index) => InkWell(
                                              onTap: () {
                                                var data = {
                                                  "working_lifestyle":
                                                      WorkLifeCycleModel
                                                          .workLifeCycleOptions
                                                          .keys
                                                          .toList()[index]
                                                          .toLowerCase()
                                                };
                                                userData?.profileData
                                                        ?.workingLifestyle =
                                                    WorkLifeCycleModel
                                                        .workLifeCycleOptions
                                                        .keys
                                                        .toList()[index]
                                                        .toLowerCase();
                                                context.read<ProfileBloc>().add(
                                                      ProfileCreatedUpdatedEvent(
                                                        7,
                                                        data,
                                                        isProfileFinished: true,
                                                        profileData: userData,
                                                      ),
                                                    );
                                                Navigator.pop(ctx);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: userData?.profileData
                                                              ?.workingLifestyle ==
                                                          WorkLifeCycleModel
                                                              .workLifeCycleOptions
                                                              .keys
                                                              .toList()[index]
                                                              .toLowerCase()
                                                      ? AppColor
                                                          .progressBarColor
                                                          .withOpacity(.15)
                                                      : null,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 6),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    RichText(
                                                      text: TextSpan(
                                                        text: WorkLifeCycleModel
                                                            .workLifeCycleOptions
                                                            .keys
                                                            .toList()[index],
                                                        style:
                                                            p12_400BlackTitleTextStyle,
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                "\n${WorkLifeCycleModel.workLifeCycleOptions.values.toList()[index]}",
                                                            style:
                                                                p10_400OffBlackTextStyle,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      decoration:
                                                          ShapeDecoration(
                                                        shape:
                                                            const CircleBorder(
                                                          side: BorderSide(
                                                            color: AppColor
                                                                .blackColor,
                                                          ),
                                                        ),
                                                        color: userData
                                                                    ?.profileData
                                                                    ?.workingLifestyle ==
                                                                WorkLifeCycleModel
                                                                    .workLifeCycleOptions
                                                                    .keys
                                                                    .toList()[
                                                                        index]
                                                                    .toLowerCase()
                                                            ? AppColor
                                                                .progressBarColor
                                                            : null,
                                                      ),
                                                      height: 20,
                                                      width: 20,
                                                      child: userData
                                                                  ?.profileData
                                                                  ?.workingLifestyle ==
                                                              WorkLifeCycleModel
                                                                  .workLifeCycleOptions
                                                                  .keys
                                                                  .toList()[
                                                                      index]
                                                                  .toLowerCase()
                                                          ? const Icon(
                                                              Icons.done,
                                                              color: AppColor
                                                                  .whiteColor,
                                                              size: 16,
                                                            )
                                                          : null,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        WorkoutEditingButton(
                            title: "Physical Acitivity Level",
                            value: userData?.profileData?.workoutlevel
                                    ?.capitalize() ??
                                "",
                            onClick: () {
                              showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (ctx) {
                                  return ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0),
                                    ),
                                    child: Container(
                                      color: AppColor.whiteColor,
                                      padding: const EdgeInsets.all(22),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                              Text(
                                                "Physical Acitivity Level",
                                                style: p14_500BlackTextStyle,
                                              ),
                                              const SizedBox(height: 20),
                                              const Divider(
                                                  height: 1,
                                                  color:
                                                      AppColor.offBlackColor),
                                              const SizedBox(height: 20),
                                            ] +
                                            List.generate(
                                              ActivityModel
                                                  .activityLevelOption.length,
                                              (index) {
                                                bool isSelected = userData
                                                        ?.profileData
                                                        ?.workoutlevel ==
                                                    ActivityModel
                                                        .activityLevelOption[
                                                            index]
                                                        .toLowerCase();
                                                return InkWell(
                                                  onTap: () {
                                                    var data = {
                                                      "workoutlevel": ActivityModel
                                                          .activityLevelOption[
                                                              index]
                                                          .toLowerCase()
                                                    };
                                                    userData?.profileData
                                                            ?.workoutlevel =
                                                        ActivityModel
                                                            .activityLevelOption[
                                                                index]
                                                            .toLowerCase();
                                                    context
                                                        .read<ProfileBloc>()
                                                        .add(
                                                          ProfileCreatedUpdatedEvent(
                                                            7,
                                                            data,
                                                            isProfileFinished:
                                                                true,
                                                            profileData:
                                                                userData,
                                                          ),
                                                        );
                                                    Navigator.pop(ctx);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      color: isSelected
                                                          ? AppColor
                                                              .progressBarColor
                                                              .withOpacity(.15)
                                                          : null,
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10,
                                                        horizontal: 6),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          ActivityModel
                                                                  .activityLevelOption[
                                                              index],
                                                          style:
                                                              p12_400BlackTitleTextStyle,
                                                        ),
                                                        Container(
                                                          decoration:
                                                              ShapeDecoration(
                                                            shape:
                                                                const CircleBorder(
                                                              side: BorderSide(
                                                                color: AppColor
                                                                    .blackColor,
                                                              ),
                                                            ),
                                                            color: isSelected
                                                                ? AppColor
                                                                    .progressBarColor
                                                                : AppColor
                                                                    .whiteColor,
                                                          ),
                                                          height: 20,
                                                          width: 20,
                                                          child: isSelected
                                                              ? const Icon(
                                                                  Icons.done,
                                                                  color: AppColor
                                                                      .whiteColor,
                                                                  size: 16,
                                                                )
                                                              : null,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                        WorkoutEditingButton(
                            title: "Goal Setting",
                            value: userData?.profileData?.profileGoal
                                    ?.map((e) => e.capitalize())
                                    .join(', ') ??
                                "",
                            onClick: () {
                              GoalModel goalModel = GoalModel();
                              var goalKeys =
                                  GoalModel.goalOptions.keys.toList();
                              for (int i = 0; i < goalKeys.length; i++) {
                                var profileGoals =
                                    userData?.profileData?.profileGoal ?? [];
                                if (profileGoals
                                    .contains(goalKeys[i].toLowerCase())) {
                                  goalModel.addSelectedOption = i;
                                }
                              }
                              bool isButtonEnabled = true;
                              showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (ctx) {
                                  return ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0),
                                    ),
                                    child: StatefulBuilder(
                                      builder: (ctx, setState) {
                                        return Container(
                                          color: AppColor.whiteColor,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 22),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SelectableGoalGridTiles(
                                                goalModel: goalModel,
                                                isFromProfileSetting: true,
                                                onSelect: () {
                                                  if (goalModel.isProceed) {
                                                    isButtonEnabled = true;
                                                  } else {
                                                    isButtonEnabled = false;
                                                  }
                                                  setState(() {});
                                                },
                                              ),
                                              const SizedBox(height: 12),
                                              InkWell(
                                                onTap: isButtonEnabled
                                                    ? () {
                                                        var data =
                                                            goalModel.getData();
                                                        userData?.profileData
                                                                ?.profileGoal =
                                                            data[
                                                                "profile_goal"];
                                                        context
                                                            .read<ProfileBloc>()
                                                            .add(
                                                              ProfileCreatedUpdatedEvent(
                                                                7,
                                                                data,
                                                                isProfileFinished:
                                                                    true,
                                                                profileData:
                                                                    userData,
                                                              ),
                                                            );
                                                        Navigator.pop(ctx);
                                                      }
                                                    : null,
                                                child: Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12),
                                                  height: 36,
                                                  color: AppColor
                                                      .progressBarColor
                                                      .withOpacity(
                                                          isButtonEnabled
                                                              ? 1
                                                              : .4),
                                                  child: Center(
                                                    child: Text(
                                                      "Save",
                                                      style:
                                                          m12_600WhiteTextStyle,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            }),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColor.whiteColor),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Support",
                                style: p14_500BlackTextStyle,
                              ),
                              const SizedBox(height: 12),
                              InkWell(
                                onTap: () {
                                    Navigator.pushNamed(
                                      context, ScreenPaths.webViewScreen.name,
                                      arguments:
                                          "https://www.fittle.ai/terms-and-conditions");
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Terms & Conditions",
                                      style: p12_400GreyTextStyle,
                                    ),
                                    const Icon(
                                      Icons.arrow_outward_sharp,
                                      color: AppColor.gray_1,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, ScreenPaths.webViewScreen.name,
                                      arguments:
                                          "https://www.fittle.ai/privacy-policy");
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Privacy Policy",
                                      style: p12_400GreyTextStyle,
                                    ),
                                    const Icon(
                                      Icons.arrow_outward_sharp,
                                      color: AppColor.gray_1,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColor.whiteColor),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Action",
                                  style: p14_500BlackTextStyle,
                                ),
                                const SizedBox(height: 12),
                                InkWell(
                                  onTap: () {
                                    showLogoutPopUp(context, () {
                                      Singleton().sharedRepo.clear();
                                      context.read<NavigationBloc>().add(
                                            ScreenPushedAndRemoveUntilEvent(
                                                ScreenPaths
                                                    .authLoginScreenPath.name,
                                                "",
                                                from: '/'),
                                          );
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Logout",
                                        style: p12_400GreyTextStyle,
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        color: AppColor.gray_1,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        const SizedBox(height: 22),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ));
  }

  void showLogoutPopUp(BuildContext context, void Function() onLogout) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        title: Text(
          "Are you sure, you want to logout",
          style: m12_600BlackTextStyle,
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(ctx);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                // color: AppColor.,
              ),
              height: 26,
              width: 78,
              child: Center(
                child: Text(
                  "Cancel",
                  style: m12_600LBlackTextStyle,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(ctx);
              onLogout();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColor.red,
              ),
              height: 26,
              width: 78,
              child: Center(
                child: Text(
                  "Logout",
                  style: m12_600WhiteTextStyle,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void asyncNavigation(BuildContext context, ProfileData? userData) async {
    var profileData = userData?.profileData;
    ProfileData? updateProfileData = await Navigator.of(context).pushNamed(
      ScreenPaths.editProfileScreenPath.name,
      arguments: ProfileData(
        profileData: ProfileDataClass(
            fullName: profileData?.fullName,
            age: profileData?.age,
            dob: profileData?.dob,
            email: profileData?.email,
            gender: profileData?.gender,
            height: profileData?.height,
            mobile: profileData?.mobile,
            profileGoal: profileData?.profileGoal,
            profileImage: profileData?.profileImage,
            weight: profileData?.weight,
            workingLifestyle: profileData?.workingLifestyle,
            workoutlevel: profileData?.workoutlevel),
      ),
    ) as ProfileData?;

    if (updateProfileData != null) {
      var selectedYear =
          updateProfileData.profileData?.dob?.year ?? DateTime.now().year;
      var selectedMonth =
          updateProfileData.profileData?.dob?.month ?? DateTime.now().month;
      var selectedDay =
          updateProfileData.profileData?.dob?.day ?? DateTime.now().day;
      context.read<ProfileBloc>().add(ProfileCreatedUpdatedEvent(
          7,
          {
            "full_name": updateProfileData.profileData?.fullName,
            "email": updateProfileData.profileData?.email,
            "dob":
                "$selectedYear-${selectedMonth < 10 ? "0$selectedMonth" : selectedMonth}-${selectedDay < 10 ? "0$selectedDay" : selectedDay}",
            "weight": updateProfileData.profileData?.weight,
            "height": updateProfileData.profileData?.height,
            "is_weight_in_lbs": false,
            "gender": updateProfileData.profileData?.gender,
            "is_height_in_feet": true
          },
          isProfileFinished: true,
          profileData: updateProfileData));
    }
  }

  Container keyValueCard(String key, String value) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(6),
      ),
      width: 95,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Text(
            value,
            style: p14_500BlackTextStyle.copyWith(
              color: AppColor.progressBarColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            key,
            style: p12_400BlackTextStyle.copyWith(
              color: AppColor.lightBlackColor,
            ),
          ),
        ],
      ),
    );
  }
}

class WorkoutEditingButton extends StatelessWidget {
  const WorkoutEditingButton({
    super.key,
    required this.title,
    required this.value,
    required this.onClick,
  });

  final String title;
  final String value;
  final void Function() onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColor.whiteColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                text: "$title\n",
                style: p12_500BlackTextStyle,
                children: [
                  TextSpan(
                    text: value,
                    style: p10_400LBlackTextStyle,
                  )
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColor.gray_1,
            ),
          ],
        ),
      ),
    );
  }
}
