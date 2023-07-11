import 'package:fittle_ai/Utils/constants.dart';
import 'package:fittle_ai/bloc/event/workout_track_event.dart';
import 'package:fittle_ai/bloc/state/workout_track_state.dart';
import 'package:fittle_ai/bloc/workout_track_bloc.dart';
import 'package:fittle_ai/common/form_input_field.dart';
import 'package:fittle_ai/resources/app_color.dart';
import 'package:fittle_ai/resources/components/app_loader.dart';
import 'package:fittle_ai/resources/components/texts/custom_text.dart';
import 'package:fittle_ai/resources/components/try_again.dart';
import 'package:fittle_ai/screens/common/custom_loader_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/wokout_track_model.dart';
import '../../resources/components/toast.dart';
import '../../utils/screen_paths.dart';
import 'package:fittle_ai/utils/extensions.dart';

class WorkoutDetailScreen extends StatelessWidget {
  const WorkoutDetailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isForEdit = false;
    String exerciseId = "";
    Map<String, dynamic>? exerciseData;
    final argument = ModalRoute.of(context)!.settings.arguments;
    if (argument is String) {
      exerciseId = argument;
    } else if (argument is UserExerciseDatum) {
      exerciseId = argument.exerciseId ?? "";
      exerciseData = argument.exerciseData;
      isForEdit = true;
    }

    return CustomScreenWithLoader(
      withGradient: false,
      body: BlocProvider(
        create: (context) => WorkoutTrackBloc(),
        child: WorkoutDetailBody(
          exerciseId: exerciseId,
          isForEdit: isForEdit,
          exerciseMapData: exerciseData,
        ),
      ),
      id: ScreenPaths.workoutDetailScreenPath.name,
    );
  }
}

class WorkoutDetailBody extends StatelessWidget {
  const WorkoutDetailBody({
    super.key,
    required this.exerciseId,
    this.exerciseMapData,
    this.isForEdit = false,
  });

  final String exerciseId;
  final Map<String, dynamic>? exerciseMapData;
  final bool isForEdit;

  @override
  Widget build(BuildContext context) {
    context.read<WorkoutTrackBloc>().add(WorkoutDetailFetchedEvent(exerciseId));
    return BlocBuilder<WorkoutTrackBloc, WorkoutTrackingState>(
      builder: (context, state) {
        if (state is! WorkoutDetailFetchedState) {
          if (state is WorkoutDetailErrorState) {
            return TryAgain(
              message: state.message,
              onTryAgain: () {
                context
                    .read<WorkoutTrackBloc>()
                    .add(WorkoutDetailFetchedEvent(exerciseId));
              },
            );
          }
          return Center(child: darkAppLoader());
        }
        var exerciseData = state.exerciseDetail.exercisePageData;

        exerciseData?.exerciseKeys?.forEach((element) {
        });
        List<TextEditingController> textEditingControllers = [];

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 22,
                top: 48,
                bottom: 24,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColor.blackColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  children: [
                    SizedBox(
                      height: 160,
                      width: double.infinity,
                      child: exerciseData?.exerciseImage == null ||
                              exerciseData!.exerciseImage!.isEmpty
                          ? Image.asset(
                              Constant.exerciseDetailPlaceholder,
                              fit: BoxFit.fill,
                            )
                          : Image.network(
                              exerciseData.exerciseImage!,
                              fit: BoxFit.fill,
                            ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        SizedBox(
                          height: 18,
                          width: 18,
                          child: Image.asset(
                            Constant.workoutTilePng,
                            color: AppColor.lightBlackColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          exerciseData?.exerciseName ?? "",
                          style: p14_500BlackTextStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Builder(builder: (context) {
                        String firstKey =
                            exerciseData?.exerciseKeys?.first ?? "";
                        if (firstKey != "Sets") {
                          return Column(
                            children: List.generate(
                              exerciseData?.exerciseKeys?.length ?? 0,
                              (index) {
                                textEditingControllers.add(
                                  TextEditingController(
                                    text: exerciseMapData?.values
                                        .toList()[index]
                                        .toString(),
                                  ),
                                );
                                return SizedBox(
                                  height: 58,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 42,
                                        width: 84,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: AppColor.d5d5d5Color),
                                        child: Center(
                                          child: Text(
                                            (exerciseData?.exerciseKeys?[index])
                                                    ?.capitalize() ??
                                                "",
                                            style: p10_400BlackTextStyle,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: SizedBox(
                                          height: 42,
                                          child: FormInputField(
                                            style: p12_400BlackTextStyle,
                                            contentPadding:
                                                const EdgeInsets.all(14),
                                            label: InputFieldsLabel.workout,
                                            hintText: "Enter",
                                            radius: 5,
                                            fillColor: AppColor.d5d5d5Color,
                                            keyboardType: TextInputType.number,
                                            hintStyle: p10_400LBlackTextStyle,
                                            cursorColor: AppColor.offBlackColor,
                                            showCursor: true,
                                            controller:
                                                textEditingControllers[index],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        int sets = exerciseMapData?.values.first ?? 0;
                        TextEditingController setEditingController =
                            TextEditingController(text: sets.toString());
                        textEditingControllers.add(setEditingController);
                        var keys = exerciseData?.exerciseKeys?.sublist(1);
                        return StatefulBuilder(builder: (context, setState) {
                          return ListView(
                            children: <Widget>[
                                  SizedBox(
                                    height: 58,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 42,
                                          width: 84,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: AppColor.d5d5d5Color),
                                          child: Center(
                                            child: Text(
                                              "Sets",
                                              style: p10_400BlackTextStyle,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: SizedBox(
                                            height: 42,
                                            child: FormInputField(
                                              style: p12_400BlackTextStyle,
                                              contentPadding:
                                                  const EdgeInsets.all(14),
                                              label: InputFieldsLabel.workout,
                                              hintText: "Enter",
                                              radius: 5,
                                              fillColor: AppColor.d5d5d5Color,
                                              keyboardType:
                                                  TextInputType.number,
                                              hintStyle: p10_400LBlackTextStyle,
                                              cursorColor:
                                                  AppColor.offBlackColor,
                                              showCursor: true,
                                              controller: setEditingController,
                                              onChanged: (val) {
                                                if (val.isNumeric()) {
                                                  setState(
                                                    () {
                                                      sets =
                                                          int.tryParse(val) ??
                                                              0;
                                                    },
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ] +
                                List.generate(
                                  sets,
                                  (index) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Text(
                                              "Set ${index + 1} :",
                                              style: m12_600LBlackTextStyle,
                                            ),
                                          )
                                        ] +
                                        List.generate(
                                          keys?.length ?? 0,
                                          (setIndex) {
                                            var val = (exerciseMapData
                                                            ?.values.first ??
                                                        0) >=
                                                    sets
                                                ? sets > 0
                                                    ? ((exerciseMapData?[
                                                                "weight_reps_sets"]
                                                            as List)[index]
                                                        as Map)[keys?[setIndex]]
                                                    : ""
                                                : "";
                                            var textEditingController =
                                                TextEditingController(
                                                    text: val.toString());
                                            textEditingControllers
                                                .add(textEditingController);
                                            return SizedBox(
                                              height: 58,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 42,
                                                    width: 84,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: AppColor
                                                            .d5d5d5Color),
                                                    child: Center(
                                                      child: Text(
                                                        (keys?[setIndex])
                                                                ?.capitalize() ??
                                                            "",
                                                        style:
                                                            p10_400BlackTextStyle,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: SizedBox(
                                                      height: 42,
                                                      child: FormInputField(
                                                        style:
                                                            p12_400BlackTextStyle,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .all(14),
                                                        label: InputFieldsLabel
                                                            .workout,
                                                        hintText: "Enter",
                                                        radius: 5,
                                                        fillColor: AppColor
                                                            .d5d5d5Color,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        hintStyle:
                                                            p10_400LBlackTextStyle,
                                                        cursorColor: AppColor
                                                            .offBlackColor,
                                                        showCursor: true,
                                                        controller:
                                                            textEditingController,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                  ),
                                ),
                          );
                        });
                      }),
                    )
                  ],
                ),
              ),
            ),
            // const Spacer(),
            InkWell(
              onTap: () {
                bool isAllValuesFilled = true;
                bool isAllValueValid = true;
                Map<String, dynamic>? exerciseDic = {};
                textEditingControllers.asMap().forEach(
                  (index, element) {
                    isAllValuesFilled = element.text.isNotEmpty;
                    if (isAllValuesFilled) {
                      isAllValueValid = element.text.isNumeric();
                    }
                    if (isAllValuesFilled &&
                        isAllValueValid &&
                        exerciseData?.exerciseKeys?.first != "Sets") {
                      exerciseDic[exerciseData?.exerciseKeys?[index] ?? ""] =
                          element.text;
                    }
                  },
                );

                if (!isAllValuesFilled) {
                  Toast.show(context, "Please fill all fields");
                  return;
                }
                if (!isAllValueValid) {
                  Toast.show(context, "Please enter valid input");
                  return;
                }
                if (exerciseData?.exerciseKeys?.first == "Sets") {
                  int sets =
                      int.tryParse(textEditingControllers.first.text) ?? 0;

                  exerciseDic[exerciseData?.exerciseKeys?.first ?? ""] = sets;
                  var weightRepsList = [];
                  int otherKeysCount =
                      (exerciseData?.exerciseKeys?.length ?? 1) - 1;

                  for (int i = 0; i < sets; i++) {
                    var obj = {};
                    for (int j = 0; j < otherKeysCount; j++) {
                      obj[exerciseData?.exerciseKeys?[j + 1]] =
                          textEditingControllers[(otherKeysCount * i) + j + 1]
                              .text;
                    }
                    weightRepsList.add(obj);
                  }
                  exerciseDic["weight_reps_sets"] = weightRepsList;
                }

                if (isForEdit) {
                  Navigator.pop(
                    context,
                    [
                      UserExerciseDatum(
                        exerciseName: exerciseData?.exerciseName,
                        exerciseId: exerciseData?.exerciseId,
                        exerciseData: exerciseDic,
                      ),
                      isForEdit
                    ],
                  );
                } else {
                  Navigator.pop(
                    context,
                    UserExerciseDatum(
                      exerciseName: exerciseData?.exerciseName,
                      exerciseId: exerciseData?.exerciseId,
                      exerciseData: exerciseDic,
                    ),
                  );
                }
              },
              child: Container(
                height: 42,
                color: AppColor.burntTargetProgressColor,
                child: const Center(
                  child: Text("SAVE"),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
