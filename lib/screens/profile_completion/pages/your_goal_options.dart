import 'package:fittle_ai/bloc/event/profile_event.dart';
import 'package:fittle_ai/bloc/profile_bloc.dart';
import 'package:fittle_ai/screens/profile_completion/screen_model.dart/profile_completion_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Utils/constants.dart';
import '../../../resources/resources.dart';

class SelectableGoalGridTiles extends StatefulWidget {
  const SelectableGoalGridTiles({
    super.key,
    required this.goalModel,
    this.isFromProfileSetting = false,
    this.onSelect,
  });
  final bool isFromProfileSetting;
  final GoalModel goalModel;
  final void Function()? onSelect;

  @override
  State<SelectableGoalGridTiles> createState() =>
      _SelectableGoalGridTilesState();
}

class _SelectableGoalGridTilesState extends State<SelectableGoalGridTiles> {
  @override
  Widget build(BuildContext context) {
    // Set<int> selectedIndices = {};
    if (!widget.isFromProfileSetting) {
      if (widget.goalModel.isProceed) {
        context.read<ProfileBloc>().add(
            ProfileEnabledProceedEvent(ProfileCompletionData.goalModelIndex));
      } else {
        context.read<ProfileBloc>().add(
            ProfileDisabledProceedEvent(ProfileCompletionData.goalModelIndex));
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        // clipBehavior: Clip.none,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 128 / 114,
          crossAxisSpacing: 27,
          mainAxisSpacing: 27,
        ),
        itemBuilder: (_, index) {
          String title = GoalModel.goalOptions.keys.toList()[index];
          return GridSelectionTile(
            isFromProfileSetting: widget.isFromProfileSetting,
            isSelected: widget.goalModel.getSelectedOption.contains(index),
            index: index,
            title: title,
            assetPath: GoalModel.goalOptions[title] ?? Constant.musclePng,
            onPressed: (value) {
              if (value) {
                widget.goalModel.addSelectedOption = index;
              } else {
                widget.goalModel.removeSelectedOption = index;
              }
              if (widget.onSelect != null) {
                widget.onSelect!();
              }
              setState(() {});
            },
          );
        },
      ),
    );
  }
}

class GridSelectionTile extends StatelessWidget {
  const GridSelectionTile({
    super.key,
    required this.index,
    required this.onPressed,
    this.title = 'text',
    required this.assetPath,
    required this.isSelected,
    required this.isFromProfileSetting,
  });

  final int index;
  final String title;
  final String assetPath;
  final void Function(bool value) onPressed;
  final bool isSelected;
  final bool isFromProfileSetting;

  void toggleSelection() {
    onPressed(!isSelected);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      highlightElevation: 0,
      padding: EdgeInsets.zero,
      splashColor: Colors.white10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9),
      ),
      color: isSelected
          ? AppColor.progressBarColor
          : (isFromProfileSetting ? AppColor.whiteParaColor : Colors.white38),
      onPressed: toggleSelection,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 7,
                backgroundColor: isSelected
                    ? AppColor.whiteColor
                    : AppColor.progressBarColor,
                child: Icon(
                  isSelected ? Icons.remove : Icons.add,
                  size: 10,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox.square(
                    dimension: 45,
                    child: Image.asset(
                      assetPath,
                      color: isFromProfileSetting
                          ? isSelected
                              ? AppColor.whiteColor
                              : AppColor.blackTitleColor
                          : isSelected
                              ? AppColor.blackTitleColor
                              : AppColor.whiteColor,
                    ),
                  ),
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: p12_500WhiteTextStyle.copyWith(
                    color: isFromProfileSetting
                        ? isSelected
                            ? AppColor.whiteColor
                            : AppColor.blackTitleColor
                        : isSelected
                            ? AppColor.blackTitleColor
                            : AppColor.whiteColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}
