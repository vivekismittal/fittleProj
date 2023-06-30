import 'package:fittle_ai/screens/profile_completion/screen_model.dart/profile_completion_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/event/profile_event.dart';
import '../../../bloc/profile_bloc.dart';
import '../widgets/selection_tile.dart';

class GenderSelection extends StatefulWidget {
  const GenderSelection(
      {super.key, required this.genderSelectionModel});

  final GenderSelectionModel genderSelectionModel;
  @override
  State<GenderSelection> createState() => _GenderSelectionState();
}

class _GenderSelectionState extends State<GenderSelection> {
  @override
  Widget build(BuildContext context) {
    Map<String, IconData> options = {
      "Male": Icons.male_outlined,
      "Female": Icons.female_outlined,
      "Other": Icons.more_horiz_outlined,
    };
    fireProceedEvent(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: List.generate(
          options.length,
          (index) {
            var title = options.keys.toList()[index];
            var icon = options.values.toList()[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SelectableTile(
                isSelected:
                    widget.genderSelectionModel.getSelectedOption == index,
                onPressed: (isSelected) {
                  if (isSelected) {
                    widget.genderSelectionModel.selectedOption = index;
                  } else {
                    widget.genderSelectionModel.selectedOption = -1;
                  }
                  setState(() {});
                },
                title: title,
                icon: icon,
              ),
            );
          },
        ),
      ),
    );
  }

  void fireProceedEvent(BuildContext context) {
    if (widget.genderSelectionModel.isProceed) {
      context.read<ProfileBloc>().add(ProfileEnabledProceedEvent(ProfileCompletionData.genderSelectionModelIndex));
    } else {
      context
          .read<ProfileBloc>()
          .add(ProfileDisabledProceedEvent(ProfileCompletionData.genderSelectionModelIndex));
    }
  }
}
