import 'package:fittle_ai/bloc/event/workout_track_event.dart';
import 'package:fittle_ai/bloc/state/workout_track_state.dart';
import 'package:fittle_ai/bloc/workout_track_bloc.dart';
import 'package:fittle_ai/model/wokout_track_model.dart';
import 'package:fittle_ai/resources/components/try_again.dart';
import 'package:fittle_ai/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/loader_bloc.dart';
import '../../resources/app_color.dart';
import '../../resources/components/internet_connectivity_check.dart';
import '../../resources/components/texts/custom_text.dart';
import '../../resources/components/toast.dart';
import '../../utils/screen_paths.dart';
import '../common/custom_loader_screen.dart';
import '../dasboard/widget/date_slider.dart';

class WorkoutTrackingScreen extends StatelessWidget {
  const WorkoutTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double caloriesTarget =
        ModalRoute.of(context)!.settings.arguments as double;

    return CustomScreenWithLoader(
      withGradient: false,
      body: BlocProvider(
        create: (context) => WorkoutTrackBloc(),
        child: WorkoutTrackingBody(
          caloriesTarget: caloriesTarget,
        ),
      ),
      id: ScreenPaths.workoutTrackScreenPath.name,
    );
  }
}

class WorkoutTrackingBody extends StatelessWidget {
  WorkoutTrackingBody({super.key, required this.caloriesTarget});
  final double caloriesTarget;
  void fetchWorkoutTrackData(BuildContext context, DateTime selectedDate) {
    context.read<WorkoutTrackBloc>().add(
          WorkoutTrackingFetchedEvent(
              "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}"),
        );
  }

  bool isSaveBtnActive = false;

  WorkoutTrackData? workoutTrackData;
  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime.now();

    return InternetConnectivityChecked(
      onTryAgain: () => fetchWorkoutTrackData(context, selectedDate),
      child: BlocConsumer<WorkoutTrackBloc, WorkoutTrackingState>(
        buildWhen: (previous, current) =>
            current is WorkoutTrackingFetchedState,
        listener: (context, state) {
          switch (state.runtimeType) {
            case WorkoutTrackingErrorState:
              context.read<LoaderBloc>().add(DisabledLoadingEvent(
                  ScreenPaths.workoutTrackScreenPath.name));
              Toast.show(context, (state as WorkoutTrackingErrorState).message);
              break;
            case WorkoutTrackingLoadingState:
              context.read<LoaderBloc>().add(
                  EnabledLoadingEvent(ScreenPaths.workoutTrackScreenPath.name));
              break;
            case WorkoutTrackingFetchedState:
              context.read<LoaderBloc>().add(DisabledLoadingEvent(
                  ScreenPaths.workoutTrackScreenPath.name));
              isSaveBtnActive = false;
              workoutTrackData = (state as WorkoutTrackingFetchedState).data;
              if (state.message != null) {
                Toast.show(context, state.message!);
              }
              break;
          }
        },
        builder: (context, state) {
          if (state is WorkoutTrackingErrorState) {
            return TryAgain(
              onTryAgain: () => fetchWorkoutTrackData(context, selectedDate),
              message: state.message,
            );
          } else if (state is WorkoutTrackingFetchedState) {
            print(isSaveBtnActive);
            return StatefulBuilder(
              key: UniqueKey(),
              builder: (context, setState) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsetsDirectional.only(top: 44),
                      color: AppColor.whiteColor,
                      child: DateSlider(
                        color: AppColor.burntTargetProgressColor,
                        isDayBreakVisible: false,
                        title: "Workout Tracking",
                        selectedDate: selectedDate,
                        onDateChanged: (date) {
                          selectedDate = date;
                          fetchWorkoutTrackData(context, selectedDate);
                        },
                        isBackButtonVisible: true,
                      ),
                    ),
                    Expanded(
                      child: ColoredBox(
                        color: AppColor.backgroundColor,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 8),
                          itemCount:
                              (workoutTrackData?.userExerciseData?.length ??
                                      0) +
                                  1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return InkWell(
                                onTap: () {
                                  asyncNavigateToSearch(context, setState);
                                },
                                child: Container(
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
                                          text: caloriesTarget.toString(),
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
                                      const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircleAvatar(
                                          backgroundColor:
                                              AppColor.burntTargetProgressColor,
                                          foregroundColor: AppColor.whiteColor,
                                          child: Icon(
                                            Icons.add,
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            index = index - 1;
                            var data =
                                workoutTrackData?.userExerciseData?[index];
                            List<String> subTitles = [];
                            // data?.exerciseData?.first((key, value) {
                            //   subTitles.add("$value $key");
                            // });
                            subTitles.add(
                                "${data?.exerciseData?.keys.first} : ${data?.exerciseData?.values.first}");
                            return WorkoutTrackTile(
                              onCardClick: () {
                                asyncNavigateToDetail(context, setState, data);
                              },
                              key: UniqueKey(),
                              title: data?.exerciseName ?? "",
                              subTitles: subTitles,
                              id: data?.exerciseId ?? "",
                              onPopUpButtonClicked: (optionIndex) {
                                if (optionIndex ==
                                    WeightTrackingOptions.edit.index) {
                                  asyncNavigateToDetail(
                                      context, setState, data);
                                }
                                if (optionIndex ==
                                    WeightTrackingOptions.delete.index) {
                                  showDeletePopUp(
                                      workoutTrackData?.userExerciseData?[index]
                                              .exerciseName ??
                                          "",
                                      context, () {
                                    var exerciseId = workoutTrackData
                                        ?.userExerciseData?[index].exerciseId;

                                    context.read<WorkoutTrackBloc>().add(
                                        WorkoutTrackDeleteEvent(
                                            workoutTrackData ??
                                                WorkoutTrackData(),
                                            date:
                                                "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
                                            exerciseId: exerciseId ?? ""));
                                  });
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: isSaveBtnActive
                          ? () {
                              context.read<WorkoutTrackBloc>().add(
                                    PostUpdatedWorkoutTrackEvent(
                                        workoutTrackData ?? WorkoutTrackData(),
                                        "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}"),
                                  );
                            }
                          : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: isSaveBtnActive
                              ? null
                              : AppColor.burntTargetProgressColor
                                  .withOpacity(.5),
                          gradient: isSaveBtnActive
                              ? const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppColor.burntTargetProgressColor,
                                    AppColor.callToActionColor
                                  ],
                                )
                              : null,
                        ),
                        child: Center(
                            child: Text(
                          "SAVE CHANGES",
                          style: m12_600WhiteTextStyle,
                        )),
                      ),
                    )
                  ],
                );
              },
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  void asyncNavigateToSearch(
    BuildContext context,
    void Function(void Function()) setState,
  ) async {
    UserExerciseDatum? userExerciseData;
    var data = await Navigator.of(context).pushNamed(
      ScreenPaths.workoutSearchScreenPath.name,
    );
    if (data is UserExerciseDatum) {
      userExerciseData = data;
    }

    if (userExerciseData != null &&
        !(workoutTrackData?.userExerciseData ?? []).any(
          (element) => element.exerciseId == userExerciseData!.exerciseId,
        )) {
      workoutTrackData?.userExerciseData?.add(userExerciseData);
      isSaveBtnActive = true;
      setState(() {});
    }
  }

  void showDeletePopUp(
      String workout, BuildContext context, void Function() onDelete) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        title: Text(
          "Are you sure, you want to delete this",
          style: m12_600BlackTextStyle,
        ),
        content: Text(
          workout,
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

  void asyncNavigateToDetail(
      BuildContext context,
      void Function(void Function()) setState,
      UserExerciseDatum? pushedData) async {
    bool isForEdit = false;
    UserExerciseDatum? userExerciseData;
    var data = await Navigator.of(context).pushNamed(
        ScreenPaths.workoutDetailScreenPath.name,
        arguments: pushedData);
    if (data is UserExerciseDatum) {
      userExerciseData = data;
    } else if (data is List) {
      userExerciseData = data.first;
      isForEdit = data[1];
    }
    print(isForEdit);
    if (isForEdit &&
        workoutTrackData?.userExerciseData != null &&
        userExerciseData != null) {
      workoutTrackData!.userExerciseData!.asMap().forEach((key, value) {
        if (value.exerciseId == userExerciseData?.exerciseId) {
          workoutTrackData!.userExerciseData?[key] = userExerciseData!;
        }
      });
      isSaveBtnActive = true;
      setState(
        () {},
      );
    }
  }
}

class WorkoutTrackTile extends StatelessWidget {
  const WorkoutTrackTile({
    super.key,
    required this.title,
    required this.subTitles,
    required this.id,
    required this.onPopUpButtonClicked,
    required this.onCardClick,
  });
  final String title;
  final List<String> subTitles;
  final String id;
  final void Function(int) onPopUpButtonClicked;
  final void Function() onCardClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCardClick,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 7),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColor.whiteColor,
        ),
        child: Row(
          children: [
            Image.asset(
              Constant.workoutTilePng,
              height: 32,
              width: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$title\n",
                    style: p12_400BlackTextStyle.copyWith(fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "${subTitles.first}",
                    style: p8_400LBlackTextStyle.copyWith(fontSize: 12),
                  )
                ],
              ),
            ),
            // RichText(
            //   text: TextSpan(
            //     text: "$title\n",
            //     style: p12_400BlackTextStyle.copyWith(fontSize: 16),
            //     children: List.generate(
            //       subTitles.length,
            //       (index) {
            //         return TextSpan(
            //           text:

            //         );
            //       },
            //     ),
            //   ),
            // ),
            SizedBox(width: 6),
            // const Spacer(),
            PopupMenuButton(
              child: const Icon(
                Icons.more_vert_outlined,
                color: AppColor.lightBlackColor,
              ),
              onOpened: () {},
              onSelected: (value) {
                onPopUpButtonClicked(value);
              },
              itemBuilder: (ctx) => [
                _buildPopupMenuItem('Edit', WeightTrackingOptions.edit.index),
                _buildPopupMenuItem(
                    'Delete', WeightTrackingOptions.delete.index),
              ],
            )
          ],
        ),
      ),
    );
  }

  PopupMenuItem _buildPopupMenuItem(String title, int index) {
    return PopupMenuItem(
      value: index,
      child: Text(
        title,
        style: p12_400BlackTextStyle,
      ),
    );
  }
}
