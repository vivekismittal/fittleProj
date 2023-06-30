import 'package:fittle_ai/bloc/event/workout_track_event.dart';
import 'package:fittle_ai/bloc/state/workout_track_state.dart';
import 'package:fittle_ai/bloc/workout_track_bloc.dart';
import 'package:fittle_ai/model/workout_search_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/deboune_search.dart';
import '../../resources/components/app_loader.dart';
import '../../resources/components/toast.dart';
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
    fetchWorkoutSearchData(context, null, true);
    return Column(
      children: [
        Material(
          elevation: 4,
          shadowColor: AppColor.lightBlackColor,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22),
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
                      debounceSearch(() {
                        fetchWorkoutSearchData(context, input, input.isEmpty);
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
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                Toast.show(context, state.message);
              });
              return const SizedBox();
            }
            return darkAppLoader();
          } else {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: state.exerciseList.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          state.isFrequent
                              ? "Frequently Tracked Exercises"
                              : "Search Results",
                          style: p12_500BlackTextStyle,
                        ),
                      );
                    }
                    final exercise = state.exerciseList[index - 1];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: InkWell(
                        onTap: () {
                          asyncNavigation(context, exercise);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              exercise.exerciseName ?? "",
                              style: p10_400BlackTextStyle,
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
              ),
            );
          }
        })
      ],
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
