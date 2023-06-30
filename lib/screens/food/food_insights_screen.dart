import 'package:fittle_ai/model/food_insight_model.dart';
import 'package:fittle_ai/resources/components/internet_connectivity_check.dart';
import 'package:fittle_ai/resources/components/texts/custom_text.dart';
import 'package:fittle_ai/screens/dasboard/widget/date_slider.dart';
import 'package:fittle_ai/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/food_insights_bloc.dart';
import '../../bloc/loader_bloc.dart';
import '../../resources/app_color.dart';
import '../../resources/components/toast.dart';
import '../../utils/screen_paths.dart';
import '../common/custom_loader_screen.dart';

class FoodInsightsScreen extends StatelessWidget {
  const FoodInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreenWithLoader(
      withGradient: false,
      body: BlocProvider(
        create: (context) => FoodInsightsBloc(),
        child: const FoodInsightsBody(),
      ),
      id: ScreenPaths.foodInsightsScreenPath.name,
    );
  }
}

class FoodInsightsBody extends StatelessWidget {
  const FoodInsightsBody({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime.now();
    final dayBreakList = [
      'All',
      'Breakfast',
      'Morning Snack',
      'Lunch',
      'Evening Snack',
      'Dinner',
    ];
    var selectableDayCard = dayBreakList.first;
    int? dayBreakIndex = ModalRoute.of(context)!.settings.arguments as int?;
    if (dayBreakIndex != null) {
      selectableDayCard = dayBreakList[dayBreakIndex + 1];
    }
    return InternetConnectivityChecked(
        onTryAgain: () {
          fetchFoodInsightData(context, selectedDate, selectableDayCard);
        },
        child: BlocConsumer<FoodInsightsBloc, FoodInsightsState>(
          buildWhen: (previous, current) => current is FoodInsightsFetchedState,
          builder: (context, state) {
            if (state is! FoodInsightsFetchedState) return const SizedBox();
            final FoodInsightData insightData = state.foodInsightData;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsetsDirectional.only(top: 44),
                    color: AppColor.whiteColor,
                    child: DateSlider(
                      isBackButtonVisible: true,
                      title: "Your Food Insight",
                      selectedDate: selectedDate,
                      onDateChanged: (date) {
                        selectedDate = date;
                        fetchFoodInsightData(
                            context, selectedDate, selectableDayCard);
                      },
                      dayBreakList: dayBreakList,
                      selectedDayBreak: selectableDayCard,
                      onDayBreakChange: (dayBreak) {
                        selectableDayCard = dayBreak;
                        fetchFoodInsightData(
                            context, selectedDate, selectableDayCard);
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(22),
                    padding: const EdgeInsets.all(20),
                    height: 260,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: Constant.backgroundGradient,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${selectableDayCard == dayBreakList.first ? "Day" : selectableDayCard}’s Achievement",
                          style: p12_400WhiteTextStyle,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 28, right: 6),
                                width: 60,
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      Constant.humanPng,
                                      fit: BoxFit.cover,
                                    ),
                                    ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          stops: [
                                            (insightData.caloriePercentage ??
                                                    0) /
                                                100,
                                            (insightData.caloriePercentage ??
                                                    0) /
                                                100,
                                            1
                                          ],
                                          colors: const [
                                            AppColor.ffae35Color,
                                            Colors.transparent,
                                            Colors.transparent,
                                          ],
                                        ).createShader(bounds);
                                      },
                                      blendMode: BlendMode.darken,
                                      child: Image.asset(
                                        Constant.humanPng,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: "270",
                                        style: p12_500WhiteTextStyle,
                                        children: [
                                          TextSpan(
                                            text: " of 475 calories",
                                            style: p12_400WhiteTextStyle,
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 3,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(22),
                                      ),
                                      child: LinearProgressIndicator(
                                        value: (insightData.caloriePercentage ??
                                                0) /
                                            100,
                                        color: AppColor.ffae35Color,
                                        backgroundColor: AppColor
                                            .backgroundColor
                                            .withOpacity(.25),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "${insightData.caloriePercentage ?? 0.toStringAsFixed(1)}%",
                                style: p24_400OrangeTextStyle,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 22, right: 22, bottom: 16),
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.whiteColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nutrients Breakdown",
                          style: p12_400BlackTextStyle,
                        ),
                        const SizedBox(height: 28),
                        nutrientsBreakdown(
                          Constant.proteinPng,
                          "Protein",
                          insightData.targetProtein ?? 0,
                          insightData.proteinPercentage ?? 0,
                          AppColor.proteinGreenColor,
                        ),
                        nutrientsBreakdown(
                          Constant.fatPng,
                          "Fat",
                          insightData.targetFat ?? 0,
                          insightData.fatPercentage ?? 0,
                          AppColor.fatPurpleColor,
                        ),
                        nutrientsBreakdown(
                          Constant.carbsPng,
                          "Carbs",
                          insightData.targetCarbs ?? 0,
                          insightData.carbsPercentage ?? 0,
                          AppColor.carbsYellowColor,
                        ),
                        nutrientsBreakdown(
                          Constant.proteinPng,
                          "Fibre",
                          insightData.targetFibre ?? 0,
                          insightData.fibrePercentage ?? 0,
                          AppColor.fiberRedColor,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
          listener: (context, state) {
            switch (state.runtimeType) {
              case FoodInsightsErrorState:
                context.read<LoaderBloc>().add(DisabledLoadingEvent(
                    ScreenPaths.foodInsightsScreenPath.name));
                Toast.show(context, (state as FoodInsightsErrorState).message);
                break;
              case FoodInsightsLoadingState:
                context.read<LoaderBloc>().add(EnabledLoadingEvent(
                    ScreenPaths.foodInsightsScreenPath.name));
                break;
              case FoodInsightsFetchedState:
                context.read<LoaderBloc>().add(DisabledLoadingEvent(
                    ScreenPaths.foodInsightsScreenPath.name));
            }
          },
        ));
  }

  void fetchFoodInsightData(
      BuildContext context, DateTime selectedDate, String categoryType) {
    context.read<FoodInsightsBloc>().add(
          FoodInsightsFetchedEvent(
            "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
            categoryType.toLowerCase(),
          ),
        );
  }

  Padding nutrientsBreakdown(String assest, String title, double total,
      double percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                SizedBox(
                  height: 26,
                  width: 26,
                  child: Image.asset(assest),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: p12_500BlackTextStyle,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    text: (total * percentage / 100).toStringAsFixed(1),
                    style: p12_500BlackTextStyle,
                    children: [
                      TextSpan(
                          text: " g/${total.toStringAsFixed(1)} g",
                          style: p12_500LBlackTextStyle),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: LinearProgressIndicator(
                      value: percentage / 100,
                      color: color,
                      backgroundColor: color.withOpacity(.25),
                    ),
                  ),
                ),
                Text(
                  "${percentage.toStringAsFixed(1)}%",
                  style: p10_400BlackTextStyle.copyWith(color: color),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
