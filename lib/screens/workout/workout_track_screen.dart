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
            current is WorkoutTrackingFetchedState ||
            current is WorkoutTrackingErrorState,
        listener: (context, state) {
          switch (state.runtimeType) {
            case WorkoutTrackingErrorState:
              context.read<LoaderBloc>().add(DisabledLoadingEvent(
                  ScreenPaths.workoutTrackScreenPath.name));
              Toast.show(context, (state as WorkoutTrackingErrorState).message);

              break;
            case PostUpdatedWorkoutErrorState:
              context.read<LoaderBloc>().add(DisabledLoadingEvent(
                  ScreenPaths.workoutTrackScreenPath.name));
              Toast.show(context, (state as WorkoutTrackingErrorState).message);

              break;
            case WorkoutTrackingLoadingState:
              context.read<LoaderBloc>().add(
                  EnabledLoadingEvent(ScreenPaths.workoutTrackScreenPath.name));
              break;
            case PostUpdatedWorkoutLoadingState:
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
                                        text: caloriesTarget.toStringAsFixed(1),
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
                                    InkWell(
                                      onTap: () {
                                        asyncNavigate(context, setState);
                                      },
                                      child: const SizedBox(
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
                                    ),
                                  ],
                                ),
                              );
                            }
                            var data =
                                workoutTrackData?.userExerciseData?[index - 1];
                            List<String> subTitles = [];
                            data?.exerciseData?.forEach((key, value) {
                              subTitles.add("$value $key");
                            });

                            return WorkoutTrackTile(
                                key: UniqueKey(),
                                title: data?.exerciseName ?? "",
                                subTitles: subTitles,
                                id: data?.exerciseId ?? "");
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

  void asyncNavigate(
      BuildContext context, void Function(void Function()) setState) async {
    UserExerciseDatum? data = await Navigator.of(context)
            .pushNamed(ScreenPaths.workoutSearchScreenPath.name)
        as UserExerciseDatum?;
    if (data != null &&
        !(workoutTrackData?.userExerciseData ?? []).any(
          (element) => element.exerciseId == data.exerciseId,
        )) {
      workoutTrackData?.userExerciseData?.add(data);
      isSaveBtnActive = true;
      setState(() {});
    }
    
  }
}

class WorkoutTrackTile extends StatelessWidget {
  const WorkoutTrackTile({
    super.key,
    required this.title,
    required this.subTitles,
    required this.id,
  });
  final String title;
  final List<String> subTitles;
  final String id;
  @override
  Widget build(BuildContext context) {
    return Container(
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
          RichText(
            text: TextSpan(
              text: "$title\n",
              style: p12_400BlackTextStyle,
              children: List.generate(
                subTitles.length,
                (index) {
                  return TextSpan(
                      text:
                          "${subTitles[index]}${index != subTitles.length - 1 ? " | " : ""}",
                      style: p8_400LBlackTextStyle);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
