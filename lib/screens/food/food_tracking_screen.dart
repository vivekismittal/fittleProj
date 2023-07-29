import 'package:fittle_ai/bloc/food_track_bloc.dart';
import 'package:fittle_ai/model/food_tracking_model.dart';
import 'package:fittle_ai/resources/components/internet_connectivity_check.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../resources/resources.dart';
import 'package:fittle_ai/screens/dasboard/widget/date_slider.dart';
import 'package:fittle_ai/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/loader_bloc.dart';
import '../../resources/components/toast.dart';
import '../../utils/screen_paths.dart';
import '../common/custom_loader_screen.dart';
import '../dasboard/widget/food_tracking_tile.dart';

class FoodTrackingScreen extends StatelessWidget {
  const FoodTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate =
        ModalRoute.of(context)!.settings.arguments as DateTime;

    return CustomScreenWithLoader(
      withGradient: false,
      body: BlocProvider(
          create: (context) => FoodTrackBloc(),
          child: FoodTrackingBody(
            selectedDate: selectedDate,
          )),
      id: ScreenPaths.foodTrackScreenPath.name,
    );
  }
}

class FoodTrackingBody extends StatelessWidget {
  FoodTrackingBody({super.key, required this.selectedDate});

  DateTime selectedDate;

  int getCurrentTimeIndexForDayCard() {
    DateTime currentTime = DateTime.now();
    int hour = currentTime.hour;
    int minute = currentTime.minute;

    if (hour < 10 || hour == 10 && minute <= 0) {
      return 0; // Breakfast
    } else if (hour == 10 && minute > 0 ||
        hour < 12 ||
        (hour == 12 && minute <= 29)) {
      return 1; // Morning Snack
    } else if ((hour == 12 && minute >= 30) || (hour > 12 && hour < 15)) {
      return 2; // Lunch
    } else if (hour == 15 && minute <= 1 ||
        hour < 19 ||
        (hour == 19 && minute <= 0)) {
      return 3; // Evening Snack
    } else {
      return 4; // Dinner
    }
  }

  final dayBreakList = [
    'Breakfast',
    'Morning Snack',
    'Lunch',
    'Evening Snack',
    'Dinner',
  ];

  void fetchFoodTrackData(
      BuildContext context, DateTime selectedDate, String categoryType) {
    context.read<FoodTrackBloc>().add(
          FetchFoodTrackDataEvent(categoryType.toLowerCase(),
              "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}"),
        );
  }

  void copyMoveFoodTrackData(
    BuildContext context,
    DateTime selectedDate,
    String categoryTypeFrom,
    String categoryTypeTo,
    bool isMove,
    String foodId,
  ) {
    context.read<FoodTrackBloc>().add(
          FoodTrackDataMoveCopyEvent(
            "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
            categoryTypeFrom,
            categoryTypeTo,
            isMove,
            foodId,
          ),
        );
  }

  bool isSaveBtnActive = false;
  late String activeDayBreak;

  FoodTrackingData? foodTrackData;

  @override
  Widget build(BuildContext context) {
    activeDayBreak = dayBreakList[getCurrentTimeIndexForDayCard()];

    return InternetConnectivityChecked(onTryAgain: () {
      fetchFoodTrackData(context, selectedDate, activeDayBreak);
    }, child: StatefulBuilder(builder: (context, setState) {
      return BlocConsumer<FoodTrackBloc, FoodTrackState>(
        buildWhen: (previous, current) => current is FoodTrackSuccessState,
        listener: (context, foodTrackState) {
          switch (foodTrackState.runtimeType) {
            case FoodTrackErrorState:
              context.read<LoaderBloc>().add(
                  DisabledLoadingEvent(ScreenPaths.foodTrackScreenPath.name));
              Toast.show(
                  context, (foodTrackState as FoodTrackErrorState).message);
              break;
            case FoodTrackLoadingState:
              context.read<LoaderBloc>().add(
                  EnabledLoadingEvent(ScreenPaths.foodTrackScreenPath.name));
              break;
            case FoodTrackSuccessState:
              context.read<LoaderBloc>().add(
                  DisabledLoadingEvent(ScreenPaths.foodTrackScreenPath.name));
              isSaveBtnActive = false;
              foodTrackData =
                  (foodTrackState as FoodTrackSuccessState).foodData;

              if (foodTrackState.message != null) {
                Toast.show(context, foodTrackState.message!);
              }
              if (foodTrackState.isUpdated) {
                fetchFoodTrackData(context, selectedDate, activeDayBreak);
              }
              break;
          }
        },
        builder: (context, foodTrackState) {
          if (foodTrackState is! FoodTrackSuccessState) {
            return const SizedBox();
          }
          return Column(
            children: [
              Container(
                padding: const EdgeInsetsDirectional.only(top: 44),
                color: AppColor.whiteColor,
                child: DateSlider(
                  title: "Daily Nutrition",
                  selectedDate: selectedDate,
                  onDateChanged: (date) {
                    selectedDate = date;

                    fetchFoodTrackData(context, selectedDate, activeDayBreak);
                  },
                  isBackButtonVisible: true,
                  dayBreakList: dayBreakList,
                  onDayBreakChange: (dayBreak) {
                    activeDayBreak = dayBreak;
                    fetchFoodTrackData(context, selectedDate, activeDayBreak);
                  },
                  selectedDayBreak: activeDayBreak,
                ),
              ),
              Expanded(
                child: ColoredBox(
                  color: AppColor.backgroundColor,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 20),
                    itemCount: (foodTrackData?.userFoodData?.length ?? 0) + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColor.whiteColor,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 48,
                                height: 48,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    CircularProgressIndicator(
                                      value: (foodTrackData
                                                  ?.categoryCaloriePercentage ??
                                              0) /
                                          100,
                                      color: AppColor.progressBarColor,
                                      backgroundColor: AppColor.backgroundColor,
                                      strokeWidth: 3.2,
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "${(foodTrackData?.categoryCaloriePercentage ?? 0).round()}%",
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
                                  text: (((foodTrackData
                                                      ?.categoryCaloriePercentage ??
                                                  0) *
                                              (foodTrackData
                                                      ?.categoryCalorieTarget ??
                                                  0) /
                                              100)
                                          .round())
                                      .toString(),
                                  style: p14_500BlackTextStyle,
                                  children: [
                                    TextSpan(
                                      text:
                                          " of ${(foodTrackData?.categoryCalorieTarget ?? 0).round()} calories",
                                      style: p12_400BlackTitleTextStyle,
                                    ),
                                    TextSpan(
                                      text:
                                          "\nAll you need is some ${activeDayBreak.toLowerCase()}",
                                      style: p8_400LBlackTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      ScreenPaths.foodInsightsScreenPath.name,
                                      arguments:
                                          dayBreakList.indexOf(activeDayBreak));
                                },
                                child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: SvgPicture.asset(
                                      Constant.insightSvg,
                                      fit: BoxFit.fill,
                                    )),
                              ),
                              const SizedBox(width: 16),
                              InkWell(
                                onTap: () {
                                  asyncNavigation(
                                      context, activeDayBreak, setState);
                                },
                                child: const SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircleAvatar(
                                    backgroundColor: AppColor.progressBarColor,
                                    foregroundColor: AppColor.whiteColor,
                                    child: Icon(
                                      Icons.add,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      index--;
                      if (foodTrackData?.userFoodData?[index] != null) {
                        return FoodTrackingTile(
                          key: UniqueKey(),
                          foodTileData: foodTrackData!.userFoodData![index],
                          onQuantityChange: (foodTileData) {
                            foodTrackData?.userFoodData?[index] = foodTileData;

                            setState(() {
                              isSaveBtnActive = true;
                            });
                          },
                          onPopUpButtonClicked: (optionIndex) {
                            if (optionIndex == FoodTrackingOptions.copy.index) {
                              copyMoveBottomSheet(
                                  context,
                                  "where do you want to copy this food item?",
                                  false,
                                  foodTrackData?.userFoodData?[index].foodId ??
                                      "");
                            } else if (optionIndex ==
                                FoodTrackingOptions.move.index) {
                              copyMoveBottomSheet(
                                  context,
                                  "where do you want to move this food item?",
                                  true,
                                  foodTrackData?.userFoodData?[index].foodId ??
                                      "");
                            } else if (optionIndex ==
                                FoodTrackingOptions.delete.index) {
                              showDeletePopUp(
                                  foodTrackData
                                          ?.userFoodData?[index].foodName ??
                                      "",
                                  activeDayBreak,
                                  context, () {
                                var foodId =
                                    foodTrackData?.userFoodData?[index].foodId;

                                foodTrackData?.userFoodData?.removeAt(index);

                                foodTrackData?.userFoodData
                                    ?.forEach((element) {});
                                context.read<FoodTrackBloc>().add(
                                      FoodTrackDataDeleteEvent(
                                        "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
                                        activeDayBreak.toLowerCase(),
                                        foodId ?? "",
                                        true,
                                        foodTrackData ?? FoodTrackingData(),
                                      ),
                                    );
                              });
                            } else if (optionIndex ==
                                FoodTrackingOptions.report.index) {
                              reportDialogPopUp(
                                context,
                                (reportIssues) {
                                  var foodId = foodTrackData
                                      ?.userFoodData?[index].foodId;
                                  var foodName = foodTrackData
                                      ?.userFoodData?[index].foodName;
                                  if (foodId != null && foodName != null) {
                                    context.read<FoodTrackBloc>().add(
                                          FoodTrackReportIssuesEvent(
                                              foodId, foodName, reportIssues),
                                        );
                                  }
                                },
                              );
                            }
                          },
                        );
                      }
                      return null;
                    },
                  ),
                ),
              ),
              InkWell(
                onTap: isSaveBtnActive
                    ? () {
                        if (foodTrackData != null) {
                          context.read<FoodTrackBloc>().add(
                                FoodTrackDataUpdatedEvent(
                                  foodTrackData!,
                                  "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
                                  activeDayBreak.toLowerCase(),
                                ),
                              );
                        }
                      }
                    : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: isSaveBtnActive
                        ? null
                        : AppColor.progressBarColor.withOpacity(.5),
                    gradient: isSaveBtnActive
                        ? const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColor.progressBarColor,
                              AppColor.callToActionColor
                            ],
                          )
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      "SAVE CHANGES",
                      style: m12_600WhiteTextStyle,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }));
  }

  void reportDialogPopUp(
      BuildContext context, void Function(List<String>) onReport) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        var totalReportIssues = {
          "Missing Serving Qty": false,
          "Irrelevant Serving Quantities": false,
          "Incorrect Macro Nutrients": false,
          "Incorrect Calories": false
        };

        return AlertDialog(
          // insetPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: Column(
            children: <Widget>[
                  Container(
                    width: double.infinity,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                      ),
                      color: AppColor.red,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "Report Issue",
                      style: m12_600WhiteTextStyle,
                    ),
                  ),
                ] +
                List.generate(
                  totalReportIssues.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        StatefulBuilder(
                          builder: (ctx, checkBoxSetState) => Checkbox(
                            value: totalReportIssues.values.toList()[index],
                            onChanged: (val) {
                              if (val != null) {
                                totalReportIssues[totalReportIssues.keys
                                    .toList()[index]] = val;
                                checkBoxSetState(() {});
                              }
                            },
                            checkColor: AppColor.red,
                          ),
                        ),
                        Text(
                          totalReportIssues.keys.toList()[index],
                          style: p12_400BlackTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
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
                width: 90,
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
                var keys = totalReportIssues.keys.toList();
                keys.removeWhere(
                  (element) => !(totalReportIssues[element] ?? false),
                );
                onReport(keys);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.red,
                ),
                height: 26,
                width: 90,
                child: Center(
                  child: Text(
                    "Report Issue",
                    style: m12_600WhiteTextStyle,
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void showDeletePopUp(String foodItem, String dayBreak, BuildContext context,
      void Function() onDelete) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        title: Text(
          "Are you sure, you want to delete this $dayBreak",
          style: m12_600BlackTextStyle,
        ),
        content: Text(
          foodItem,
          style: p10_400BlackTextStyle,
          overflow: TextOverflow.clip,
          maxLines: 2,
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
              onDelete();
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
                  "Delete",
                  style: m12_600WhiteTextStyle,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<dynamic> copyMoveBottomSheet(
      BuildContext context, String int, bool isMove, String foodId) {
    return showModalBottomSheet(
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
                      "where do you want to copy this food item?",
                      style: p14_500BlackTextStyle.copyWith(
                        color: AppColor.progressBarColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(height: 1, color: AppColor.offBlackColor),
                    const SizedBox(height: 20),
                  ] +
                  List.generate(
                    dayBreakList.length,
                    (index) {
                      return InkWell(
                        onTap: () {
                          copyMoveFoodTrackData(
                              context,
                              selectedDate,
                              activeDayBreak.toLowerCase(),
                              dayBreakList[index].toLowerCase(),
                              isMove,
                              foodId);
                          Navigator.pop(ctx);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: AppColor.gray_1),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dayBreakList[index],
                                style: p12_400BlackTitleTextStyle,
                              ),
                              const Icon(
                                Icons.arrow_circle_right,
                                color: AppColor.progressBarColor,
                                size: 20,
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
  }

  void asyncNavigation(BuildContext context, String activeDayBreak,
      void Function(void Function()) setState) async {
    UserFoodDatum? foodData = await Navigator.of(context).pushNamed(
      ScreenPaths.foodSearchScreenPath.name,
      arguments: activeDayBreak,
    ) as UserFoodDatum?;
    if (foodData != null) {
      var data = foodTrackData?.userFoodData;
      if (!(data ?? []).any((element) => element.foodId == foodData.foodId)) {
        foodTrackData?.userFoodData?.add(foodData);
        isSaveBtnActive = true;
        setState(() {});
      }
    }
  }
}
