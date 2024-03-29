import 'package:fittle_ai/bloc/event/workout_track_event.dart';
import 'package:fittle_ai/bloc/state/workout_track_state.dart';
import 'package:fittle_ai/bloc/workout_track_bloc.dart';
import 'package:fittle_ai/common/form_input_field.dart';
import 'package:fittle_ai/model/workout_search_model.dart';
import 'package:fittle_ai/resources/components/try_again.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/deboune_search.dart';
import '../../resources/components/app_loader.dart';
import '../../resources/resources.dart';
import '../../utils/screen_paths.dart';
import '../common/custom_loader_screen.dart';

class WorkoutSearchScreen extends StatelessWidget {
  const WorkoutSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreenWithLoader(
      withGradient: false,
      body: BlocProvider(
        create: (context) => WorkoutTrackBloc(),
        child: const WorkoutSearchBody(),
      ),
      id: ScreenPaths.workoutSearchScreenPath.name,
    );
  }
}

class WorkoutSearchBody extends StatelessWidget {
  const WorkoutSearchBody({super.key});

  @override
  Widget build(BuildContext context) {
    String searchedKeyWord = "";

    fetchWorkoutSearchData(context, null, true);
    return Column(
      children: [
        Material(
          elevation: 4,
          shadowColor: AppColor.lightBlackColor,
          child: Container(
            margin: const EdgeInsets.only(top: 40),
            height: 76,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: TextFormField(
                    onChanged: (input) {
                      searchedKeyWord=input;
                      debounceSearch(() {
                        fetchWorkoutSearchData(context, searchedKeyWord, searchedKeyWord.isEmpty);
                      });
                    },
                    cursorColor: AppColor.offBlackColor,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: "Search for Exercise",
                      fillColor: Colors.transparent,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        BlocBuilder<WorkoutTrackBloc, WorkoutTrackingState>(
            builder: (context, state) {
          if (state is! WorkoutSearchedState) {
            if (state is WorkoutSearchedErrorState) {
              return TryAgain(
                    message: state.message,
                    onTryAgain: () {
                      fetchWorkoutSearchData(
                          context, searchedKeyWord, searchedKeyWord.isEmpty);
                    },
                  );}
            return darkAppLoader();
          } else {
            return Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount:
                    state.exerciseList.length + (state.isFrequent ? 1 : 2),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 22),
                      child: Text(
                        state.isFrequent
                            ? "Frequently Tracked Exercises"
                            : "Search Results",
                        style: p12_500BlackTextStyle,
                      ),
                    );
                  }
                  if (!state.isFrequent &&
                      index == state.exerciseList.length + 1) {
                        return Container(
                        color: AppColor.burntTargetProgressColor,
                        padding: const EdgeInsets.symmetric(
                          vertical: 7,
                          horizontal: 22.0,
                        ),
                        child: InkWell(
                          onTap: () {
                            showMissingExercisePopup(context);
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: Text(
                                    "Can’t find your Exercise?",
                                    style: p10_400BlackTextStyle.copyWith(
                                      fontSize: 14,
                                      color: AppColor.whiteColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircleAvatar(
                                  backgroundColor: AppColor.whiteColor,
                                  foregroundColor: AppColor.progressBarColor,
                                  child: Icon(
                                    Icons.arrow_forward,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                      }

                  final exercise = state.exerciseList[index - 1];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 7, horizontal: 22),
                    child: InkWell(
                      onTap: () {
                        asyncNavigation(context, exercise);
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10,bottom: 10,right: 10),
                              child: Text(
                                exercise.exerciseName ?? "",
                                style: p10_400BlackTextStyle.copyWith(
                                    fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
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
                },
              ),
            );
          }
        })
      ],
    );
  }

  void showMissingExercisePopup(BuildContext context) {
     TextEditingController missingController =
        TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        title: Text(
          "Add your Exercise and track it",
          style: m12_600BlackTextStyle,
        ),
        content: SizedBox(
          height: 38,
          child: FormInputField(
            cursorColor: AppColor.blackColor,
            style:p12_400BlackTextStyle ,
            fillColor:
                AppColor.gray_1.withOpacity(.1),
            label: InputFieldsLabel.normal,
            radius: 6,
            controller: missingController,
            prefixWidget: Icon(
              Icons.sports_gymnastics_outlined,
              color: AppColor.gray_1,
            ),
            hintText: "Enter the Exercise Name",
            hintStyle: p10_400LBlackTextStyle
                .copyWith(fontSize: 12),
          ),
        ),
        actionsAlignment:
            MainAxisAlignment.spaceEvenly,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(ctx);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(5),
                // color: AppColor.,
              ),
              height: 26,
              width: 78,
              child: Center(
                child: Text(
                  "CANCEL",
                  style: m12_600LBlackTextStyle,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(ctx);
              context.read<WorkoutTrackBloc>().add(
                  WorkoutReportMissingEvent(
                      missingController.text));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(5),
                color: AppColor.burntTargetProgressColor,
              ),
              height: 26,
              width: 110,
              child: Center(
                child: Text(
                  "SAVE EXERCISE",
                  style: m12_600WhiteTextStyle,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void asyncNavigation(BuildContext context, ExerciseList exercise) async {
    final data = await Navigator.of(context).pushNamed(
        ScreenPaths.workoutDetailScreenPath.name,
        arguments: exercise.exerciseId);
    if (data != null) {
      Navigator.of(context).pop(data);
    }
  }

  void fetchWorkoutSearchData(
      BuildContext context, String? keyword, bool isFrequent) {
    context
        .read<WorkoutTrackBloc>()
        .add(WorkoutSearchedEvent(keyword: keyword, isFrequent: isFrequent));
  }
}
