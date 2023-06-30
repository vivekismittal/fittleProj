import 'package:fittle_ai/screens/profile_completion/screen_model.dart/profile_completion_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/event/profile_event.dart';
import '../../../bloc/profile_bloc.dart';
import '../../../resources/resources.dart';

class WorkLifeCycle extends StatefulWidget {
  const WorkLifeCycle(
      {super.key, required this.workLifeCycleModel});

  final WorkLifeCycleModel workLifeCycleModel;


  @override
  State<WorkLifeCycle> createState() => _WorkLifeCycleState();
}

class _WorkLifeCycleState extends State<WorkLifeCycle> {
  @override
  Widget build(BuildContext context) {
    fireProceedEvent(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 42),
      child: Column(
        children: List.generate(
          WorkLifeCycleModel.workLifeCycleOptions.length,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: CheckBoxSelectableTile(
              subTitle: WorkLifeCycleModel.workLifeCycleOptions.values
                  .toList()[index],
              isSelected: widget.workLifeCycleModel.getSelectedOption == index,
              onPressed: (isSelected) {
                if (isSelected) {
                  widget.workLifeCycleModel.selectedOption = index;
                } else {
                  widget.workLifeCycleModel.selectedOption = -1;
                }
                setState(() {});
              },
              title:
                  WorkLifeCycleModel.workLifeCycleOptions.keys.toList()[index],
            ),
          ),
        ),
      ),
    );
  }

  void fireProceedEvent(BuildContext context) {
    if (widget.workLifeCycleModel.isProceed) {
      context.read<ProfileBloc>().add(ProfileEnabledProceedEvent(ProfileCompletionData.workLifeCycleModelIndex));
    } else {
      context
          .read<ProfileBloc>()
          .add(ProfileDisabledProceedEvent(ProfileCompletionData.workLifeCycleModelIndex));
    }
  }
}

class CheckBoxSelectableTile extends StatelessWidget {
  const CheckBoxSelectableTile({
    super.key,
    required this.isSelected,
    required this.title,
    required this.subTitle,
    required this.onPressed,
  });

  final bool isSelected;
  final String title;
  final String subTitle;
  final void Function(bool value) onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      highlightElevation: 0,
      padding: EdgeInsets.zero,
      splashColor: Colors.white10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
      ),
      color: isSelected ? Colors.white : Colors.white38,
      onPressed: () => onPressed(!isSelected),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 14),
            Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: AppColor.whiteParaColor),
              height: 14,
              width: 14,
              child: Visibility(
                visible: isSelected,
                child: const Icon(
                  Icons.circle_rounded,
                  color: AppColor.callToActionColor,
                  size: 8,
                ),
              ),
            ),
            const SizedBox(width: 14),
            RichText(
              text: TextSpan(
                text: "$title\n",
                style: p12_500WhiteTextStyle.copyWith(
                  color: isSelected
                      ? AppColor.blackTitleColor
                      : AppColor.whiteColor,
                ),
                children: [
                  TextSpan(
                    text: subTitle,
                    style: p10_400ParaTextStyle.copyWith(
                      color: isSelected
                          ? AppColor.blackTitleColor
                          : AppColor.whiteColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
