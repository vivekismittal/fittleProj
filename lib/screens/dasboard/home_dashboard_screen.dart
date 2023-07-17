import 'package:fittle_ai/Utils/constants.dart';
import 'package:fittle_ai/bloc/home_dashboard_bloc.dart';
import 'package:fittle_ai/bloc/loader_bloc.dart';
import 'package:fittle_ai/bloc/navigation_bloc.dart';
import 'package:fittle_ai/model/home_dashboard_response.dart';
import 'package:fittle_ai/resources/components/internet_connectivity_check.dart';
import 'package:fittle_ai/screens/dasboard/widget/horizontal_paginated_card.dart';
import 'package:fittle_ai/utils/extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../resources/resources.dart';
import 'package:fittle_ai/utils/screen_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/form_input_field.dart';
import '../../resources/components/app_loader.dart';
import '../../resources/components/toast.dart';
import 'widget/date_slider.dart';

class HomeDasboardBody extends StatelessWidget {
  const HomeDasboardBody({super.key});

  void fetchHomeData(BuildContext context, DateTime selectedDate) {
    context.read<HomeDashboardBloc>().add(FetchHomeDasboardDataEvent(
        "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}"));
  }

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime.now();

    HomeDashBoardResponse? homeData;
    // fetchHomeData(context, selectedDate);

    return InternetConnectivityChecked(
        child: RefreshIndicator(
          backgroundColor: AppColor.offBlackColor,
          onRefresh: () async {
            fetchHomeData(context, selectedDate);
          },
          child: BlocConsumer<HomeDashboardBloc, HomeDasboardState>(
            buildWhen: (previous, current) =>
                current is HomeDasboardSuccessState,
            listener: (context, homeState) {
              switch (homeState.runtimeType) {
                case HomeDasboardErrorState:
                  context.read<LoaderBloc>().add(
                      DisabledLoadingEvent(ScreenPaths.homeDashBoardPath.name));
                  Toast.show(
                      context, (homeState as HomeDasboardErrorState).message);
                  break;
                case HomeDasboardLoadingState:
                  context.read<LoaderBloc>().add(
                      EnabledLoadingEvent(ScreenPaths.homeDashBoardPath.name));
                  break;
                case HomeDasboardSuccessState:
                  context.read<LoaderBloc>().add(
                      DisabledLoadingEvent(ScreenPaths.homeDashBoardPath.name));
                  homeData = (homeState as HomeDasboardSuccessState).homeData;
                  break;
              }
            },
            builder: (context, homeState) {
              if (homeState is HomeDasboardSuccessState) {
                if (homeData?.showPopupForWeight != null &&
                    homeData!.showPopupForWeight!) {
                  showPopForAskWeight(context, selectedDate);
                } else if (homeData?.targetData != null) {
                  showTargetBottomSheet(homeData, context);
                }
                return CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.only(top: 44),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          children: [
                            DateSlider(
                              selectedDate: selectedDate,
                              title: greetingString(),
                              onDateChanged: (date) {
                                selectedDate = date;
                                fetchHomeData(context, selectedDate);
                              },
                              isDayBreakVisible: false,
                            ),
                            const SizedBox(height: 30),
                            if (homeData?.bannerData != null &&
                                homeData!.bannerData!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30),
                                child: HorizontalCardPager(
                                    bannerData: homeData?.bannerData ?? []),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsetsDirectional.only(
                        start: 22,
                        end: 22,
                      ),
                      sliver: SliverList.list(
                        children: [
                          Text("Nutrition",
                              style:
                                  p12_400BlackTextStyle.copyWith(fontSize: 16)),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () {
                              context.read<NavigationBloc>().add(
                                  ScreenPushedEvent(
                                      ScreenPaths.foodTrackScreenPath.name));
                            },
                            child: Container(
                              // height: 200,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColor.whiteColor,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 48,
                                        height: 48,
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            CircularProgressIndicator(
                                              value: ((homeData?.dietWorkoutData
                                                              ?.caloriePercentage ??
                                                          0) /
                                                      100) /
                                                  1,
                                              color: AppColor.progressBarColor,
                                              backgroundColor:
                                                  AppColor.backgroundColor,
                                              strokeWidth: 3.2,
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "${(homeData?.dietWorkoutData?.caloriePercentage ?? 0).round()}%",
                                                textAlign: TextAlign.center,
                                                style: p12_500BlackTextStyle,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      RichText(
                                        text: TextSpan(
                                          text:
                                              "${((homeData?.dietWorkoutData?.targetCalorie ?? 0) * (homeData?.dietWorkoutData?.caloriePercentage ?? 0) / 100).round()}",
                                          style: p14_500BlackTextStyle,
                                          children: [
                                            TextSpan(
                                              text:
                                                  " kcal of ${(homeData?.dietWorkoutData?.targetCalorie ?? 0).round()}",
                                              style: p12_400BlackTitleTextStyle,
                                            ),
                                            TextSpan(
                                              text: "\nTotal Calory gained",
                                              style: p8_400LBlackTextStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                            ScreenPaths
                                                .foodInsightsScreenPath.name,
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: AppColor
                                                  .progressBarColor
                                                  .withOpacity(.1),
                                              radius: 20,
                                              child: SvgPicture.asset(
                                                Constant.insightSvg,
                                                fit: BoxFit.fill,
                                                height: 20,
                                              ),
                                            ),
                                            Text(
                                              "Insights",
                                              style:
                                                  p8_500WhiteTextStyle.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    AppColor.progressBarColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Column(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                                AppColor.progressBarColor,
                                            radius: 20,
                                            child: SvgPicture.asset(
                                              Constant.foodTrackSvg,
                                              height: 20,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Text(
                                            "Track food",
                                            style:
                                                p8_500WhiteTextStyle.copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: AppColor.progressBarColor,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  // progressTracking(
                                  //     color: AppColor.progressBarColor,
                                  //     assest2: Constant.activityInsightPng,
                                  //     percentValue: ,
                                  //     subTitle: ,
                                  //     title:
                                  //         ,
                                  // total: ,
                                  //     assest1: Constant.restaurantPng,
                                  //     onAsset1Tap: ,
                                  //     onAsset2Tap:),
                                  const SizedBox(height: 20),
                                  // Divider(
                                  //     thickness: 1,
                                  //     color: AppColor.lightBlackColor
                                  //         .withOpacity(.5)),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      nutrientsProgress(
                                          color: AppColor.proteinGreenColor,
                                          label: "Protein",
                                          total: (homeData?.dietWorkoutData
                                                      ?.targetProtein ??
                                                  0) /
                                              1,
                                          percentage: (homeData?.dietWorkoutData
                                                  ?.proteinPercentage ??
                                              0)),
                                      nutrientsProgress(
                                          color: AppColor.fatPurpleColor,
                                          label: "Fat",
                                          total: homeData?.dietWorkoutData
                                                  ?.targetFat ??
                                              0,
                                          percentage: (homeData?.dietWorkoutData
                                                  ?.fatPercentage ??
                                              0))
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      nutrientsProgress(
                                          color: AppColor.carbsYellowColor,
                                          label: "Carbs",
                                          total: homeData?.dietWorkoutData
                                                  ?.targetCarbs ??
                                              0,
                                          percentage: (homeData?.dietWorkoutData
                                                  ?.carbsPercentage ??
                                              0)),
                                      nutrientsProgress(
                                          color: AppColor.fiberRedColor,
                                          label: "Fiber",
                                          total: homeData?.dietWorkoutData
                                                  ?.targetFibre ??
                                              0,
                                          percentage: (homeData?.dietWorkoutData
                                                  ?.fibrePercentage ??
                                              0))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Container(
                            height: 80,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColor.progressBarColor,
                                  AppColor.callToActionColor
                                ],
                              ),
                            ),
                            child: BlocBuilder<HomeDashboardBloc,
                                    HomeDasboardState>(
                                buildWhen: (previous, current) =>
                                    current is HomeDasboardWaterIntakeLoadingState ||
                                    current
                                        is HomeDasboardWaterIntakeSuccessState ||
                                    current is HomeDasboardSuccessState,
                                builder: (context, state) {
                                  if (state
                                      is HomeDasboardWaterIntakeLoadingState) {
                                    return appLoader();
                                  }
                                  if (state
                                      is HomeDasboardWaterIntakeSuccessState) {
                                    homeData?.dietWorkoutData?.waterIntake =
                                        state.updatedIntake;
                                  }

                                  return Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: AppColor.whiteColor
                                            .withOpacity(.20),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SvgPicture.asset(
                                              Constant.glassSvg,
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      RichText(
                                        text: TextSpan(
                                          text: (homeData?.dietWorkoutData
                                                      ?.waterIntake ??
                                                  0)
                                              .toString(),
                                          style: p14_500WhiteTextStyle,
                                          children: [
                                            TextSpan(
                                                text:
                                                    " of ${homeData?.dietWorkoutData?.waterTarget ?? 0} Water Glasses\n",
                                                style: p10_400WhiteTextStyle),
                                            TextSpan(
                                                text:
                                                    "250ml per glass and take your next glass in 60 minutes.",
                                                style: p6_400ParaTextStyle),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      InkWell(
                                        onTap: () {
                                          context.read<HomeDashboardBloc>().add(
                                                HomeDasboardUpdateWaterIntakeEvent(
                                                  "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
                                                  ((homeData?.dietWorkoutData!
                                                                      .waterIntake ??
                                                                  0) -
                                                              1) <
                                                          0
                                                      ? 0
                                                      : ((homeData?.dietWorkoutData!
                                                                  .waterIntake ??
                                                              0) -
                                                          1),
                                                ),
                                              );
                                        },
                                        child: SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircleAvatar(
                                            backgroundColor: AppColor.whiteColor
                                                .withOpacity(.20),
                                            foregroundColor:
                                                AppColor.whiteColor,
                                            child: const Icon(
                                              Icons.remove,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      InkWell(
                                        onTap: () {
                                          context.read<HomeDashboardBloc>().add(
                                                HomeDasboardUpdateWaterIntakeEvent(
                                                    "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
                                                    (homeData?.dietWorkoutData!
                                                                .waterIntake ??
                                                            0) +
                                                        1),
                                              );
                                        },
                                        child: const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircleAvatar(
                                            foregroundColor:
                                                AppColor.progressBarColor,
                                            backgroundColor:
                                                AppColor.whiteColor,
                                            child: Icon(
                                              Icons.add,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          ),
                          const SizedBox(height: 28),
                          Text("Workout Tracking",
                              style:
                                  p12_400BlackTextStyle.copyWith(fontSize: 16)),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                ScreenPaths.workoutTrackScreenPath.name,
                                arguments: homeData
                                        ?.dietWorkoutData?.calorieBurntTarget ??
                                    0,
                              );
                            },
                            child: Container(
                              // height: 78,
                              padding: const EdgeInsets.all(16),

                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColor.whiteColor),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 48,
                                    height: 48,
                                    child: CircleAvatar(
                                      backgroundColor: AppColor
                                          .burntTargetProgressColor
                                          .withOpacity(0.2),
                                      radius: 24,
                                      child: Center(
                                        child: SizedBox(
                                          height: 28,
                                          width: 28,
                                          child: Image.asset(
                                            Constant.pilatesPng,
                                            color: AppColor
                                                .burntTargetProgressColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  RichText(
                                    text: TextSpan(
                                      text: ((homeData?.dietWorkoutData
                                                      ?.calorieBurntTarget ??
                                                  0)
                                              .round())
                                          .toString(),
                                      style: p14_500BlackTextStyle,
                                      children: [
                                        TextSpan(
                                          text: " kcal",
                                          style: p12_400BlackTitleTextStyle,
                                        ),
                                        TextSpan(
                                          text: "\nCalories Target",
                                          style: p8_400LBlackTextStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Column(
                                    children: [
                                      CircleAvatar(
                                          backgroundColor:
                                              AppColor.burntTargetProgressColor,
                                          radius: 20,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 10),
                                            child: SvgPicture.asset(
                                              Constant.dumbell2Svg,
                                              fit: BoxFit.fill,
                                            ),
                                          )
                                          // Image.asset(
                                          //   Constant.dumbbellPng,
                                          //   fit: BoxFit.fill,
                                          //   filterQuality: FilterQuality.high,
                                          //   height: 18,
                                          //   width: 18,
                                          //   // color: AppColor.blackColor,
                                          // ),
                                          ),
                                      Text(
                                        "Track Workout",
                                        style: p8_500WhiteTextStyle.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color:
                                              AppColor.burntTargetProgressColor,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          ProgressTracker(selectedDate: selectedDate),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
        onTryAgain: () {
          fetchHomeData(context, selectedDate);
        });
  }

  void showTargetBottomSheet(
      HomeDashBoardResponse? homeData, BuildContext context) {
    Map targetData = homeData!.targetData!;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await showModalBottomSheet(
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
              // height: 60,
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                      SizedBox(
                        height: 100,
                        child: Image.asset(Constant.targetGoalJpg),
                      ),
                      Text(
                        "Your Calorie Target To Achieve Your Goals",
                        style: m12_600LBlackTextStyle.copyWith(
                          fontSize: 16,
                        ),
                      ),
                    ] +
                    List.generate(
                      targetData.length,
                      (index) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          "${targetData.keys.toList()[index]} : ${targetData.values.toList()[index]}",
                          style: p12_400GreyTextStyle,
                        ),
                      ),
                    ),
              ),
            ),
          );
        },
      );
    });
  }

  void showPopForAskWeight(BuildContext context, DateTime selectedDate) {
    TextEditingController weightController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Please Update your weight",
                style: p14_500BlackTextStyle,
              ),
              SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 44,
                child: FormInputField(
                  label: InputFieldsLabel.normal,
                  radius: 10,
                  hintText: "Enter your current weight in kg",
                  controller: weightController,
                  style: p12_400BlackTitleTextStyle,
                  contentPadding: const EdgeInsets.all(12),
                  showCursor: true,
                  cursorColor: AppColor.blackColor,
                  hintStyle: p12_400GreyTextStyle,
                  fillColor: AppColor.backgroundColor,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            GestureDetector(
              onTap: () {
                if (weightController.text.isNotEmpty &&
                    weightController.text.isDecimalNumeric()) {
                  Navigator.of(context).pop();
                  context.read<HomeDashboardBloc>().add(
                        HomeWeightUpdateEvent(weightController.text,
                            "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}"),
                      );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.progressBarColor,
                ),
                height: 40,
                width: 90,
                child: Center(
                  child: Text(
                    "Save",
                    style: m12_600WhiteTextStyle.copyWith(fontSize: 14),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  // Row progressTracking({
  //   required Color color,
  //   required double percentValue,
  //   required String title,
  //   required String subTitle,
  //   required double total,
  //   required String assest1,
  //   String? assest2,
  //   void Function()? onAsset1Tap,
  //   void Function()? onAsset2Tap,
  // }) {
  //   return;
  // }

  SizedBox nutrientsProgress({
    required Color color,
    required double percentage,
    required String label,
    required double total,
  }) {
    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: p12_500BlackTextStyle),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: "${total * percentage ~/ 100}",
                  style: p12_400BlackTextStyle,
                  children: [
                    TextSpan(
                        text: " g/${total.toInt()} g",
                        style: p10_400BlackTextStyle),
                  ],
                ),
              ),
              Text(
                "$percentage%",
                style: p8_400OffBlackTextStyle,
              )
            ],
          ),
          LinearProgressIndicator(
            value: percentage / 100,
            color: color,
            backgroundColor: color.withOpacity(.15),
            minHeight: 2.5,
          )
        ],
      ),
    );
  }

  String greetingString() {
    var hour = DateTime.now().hour;
    String greet;
    if (hour > 4 && hour < 12) {
      greet = "Good Morning";
    } else if (hour > 12 && hour < 16) {
      greet = "Good Afternoon";
    } else {
      greet = "Good Evening";
    }
    return greet;
  }
}

class ProgressTracker extends StatelessWidget {
  ProgressTracker({
    super.key,
    required this.selectedDate,
  });
  final DateTime selectedDate;
  List<String> keys = [];
  double interval = 0.1;

  @override
  Widget build(BuildContext context) {
    var progressTrackerFilters = {
      "current_month": "1 Month",
      "last_9_months": "9 Month",
      "current_year": "1 Year",
      "last_3_years": "3 Year"
    };
    int activeProgressTrackerFilter = 0;
    List<Map<String, double>> progressData = [];

    List<Point> points = [];
    fetchProgressData(
      context,
      progressTrackerFilters,
      activeProgressTrackerFilter,
    );
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 28),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: Constant.backgroundGradient),
      child: BlocBuilder<HomeDashboardBloc, HomeDasboardState>(
        buildWhen: (previous, current) {
          if (current is HomeDasboardProgressDataErrorState) {
            Toast.show(context, current.message);
          }
          return current is HomeDasboardProgressDataLoadingState ||
              current is HomeDasboardProgressDataFetchedState;
        },
        builder: (context, state) {
          if (state is HomeDasboardProgressDataLoadingState) {
            return appLoader();
          }
          if (state is HomeDasboardProgressDataFetchedState) {
            progressData = state.progressData;
            points = getPoints(progressData);
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Weight Progress",
                style: p12_400WhiteTextStyle,
              ),
              const SizedBox(height: 10),
              Wrap(
                // crossAxisAlignment:WrapCrossAlignment.center,
                spacing: 8,
                children: List.generate(
                  progressTrackerFilters.length,
                  (index) => ActionChip(
                    label: Text(
                      progressTrackerFilters.values.toList()[index],
                      style: p8_500WhiteTextStyle.copyWith(
                          color: activeProgressTrackerFilter == index
                              ? AppColor.whiteColor
                              : AppColor.whiteParaColor),
                    ),
                    onPressed: () {
                      activeProgressTrackerFilter = index;
                      fetchProgressData(context, progressTrackerFilters, index);
                    },
                    backgroundColor: AppColor.progressBarColor,
                    side: BorderSide(
                      color: activeProgressTrackerFilter == index
                          ? AppColor.ff855dColor
                          : AppColor.progressBarColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 224,
                child: BarChart(
                  BarChartData(
                    gridData: const FlGridData(
                      show: false,
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          interval: interval,
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toString(),
                              style: p8_500WhiteTextStyle,
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              keys[value.toInt() - 1],
                              style: p8_500WhiteTextStyle,
                            );
                          },
                        ),
                      ),
                    ),
                    minY: 0,
                    maxY: maxY,
                    barGroups: points
                        .map(
                          (e) => BarChartGroupData(
                            x: e.x,
                            barRods: [
                              BarChartRodData(
                                toY: e.y,
                                color: AppColor.ff855dColor,
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void fetchProgressData(
      BuildContext context,
      Map<String, String> progressTrackerFilters,
      int activeProgressTrackerFilter) {
    context.read<HomeDashboardBloc>().add(HomeDasboardProgressDataFetchedEvent(
        progressTrackerFilters.keys.toList()[activeProgressTrackerFilter],
        "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}"));
  }

  List<Point> getPoints(List<Map<String, double>> data) {
    List<Point> points = [];
    keys = [];
    maxY = 0;
    for (int i = 0; i < data.length; i++) {
      if (data[i].values.first > maxY) {
        maxY = data[i].values.first;
      }
      points.add(Point(i + 1, data[i].values.first));
      keys.add(data[i].keys.first);
    }

    int x = maxY ~/ 5;
    interval = x + 1;
    maxY = interval * 5;
    return points;
  }

  double maxY = 0;
}

class Point {
  final int x;
  final double y;

  Point(this.x, this.y);
}
