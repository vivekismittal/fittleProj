import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/event/profile_event.dart';
import '../../../bloc/profile_bloc.dart';
import '../screen_model.dart/profile_completion_data.dart';
import '../widgets/selection_tile.dart';

class ActivityLevel extends StatefulWidget {
  const ActivityLevel(
      {super.key, required this.activityModel});

  final ActivityModel activityModel;
  @override
  State<ActivityLevel> createState() => _ActivityLevelState();
}

class _ActivityLevelState extends State<ActivityLevel> {
  @override
  Widget build(BuildContext context) {
    fireProceedEvent(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 42),
      child: Column(
        children: List.generate(
          ActivityModel.activityLevelOption.length,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SelectableTile(
              isSelected: widget.activityModel.getSelectedOption == index,
              onPressed: (isSelected) {
                if (isSelected) {
                  widget.activityModel.selectedOption = index;
                } else {
                  widget.activityModel.selectedOption = -1;
                }
                setState(() {});
              },
              title: ActivityModel.activityLevelOption[index],
            ),
          ),
        ),
      ),
    );
  }

  void fireProceedEvent(BuildContext context) {
    if (widget.activityModel.isProceed) {
      context.read<ProfileBloc>().add(ProfileEnabledProceedEvent(ProfileCompletionData.activityModelIndex));
    } else {
      context
          .read<ProfileBloc>()
          .add(ProfileDisabledProceedEvent(ProfileCompletionData.activityModelIndex));
    }
  }
}
