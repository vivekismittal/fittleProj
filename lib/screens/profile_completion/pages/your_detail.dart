import 'package:fittle_ai/screens/profile_completion/screen_model.dart/profile_completion_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/event/profile_event.dart';
import '../../../bloc/profile_bloc.dart';
import '../../../common/form_input_field.dart';

class YourDetailFields extends StatelessWidget {
  const YourDetailFields({super.key, required this.yourDetailModel});

  final DetailModel yourDetailModel;

  @override
  Widget build(BuildContext context) {
    fireProceedEvent(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          FormInputField(
            label: InputFieldsLabel.name,
            controller: yourDetailModel.nameController,
            contentPadding: const EdgeInsets.all(10),
            hintText: "Enter your Name",
            onChanged: (_) {
              fireProceedEvent(context);
            },
          ),
          const SizedBox(height: 20),
          FormInputField(
            label: InputFieldsLabel.email,
            controller: yourDetailModel.emailController,
            contentPadding: const EdgeInsets.all(10),
            hintText: "Enter your Email ID",
            onChanged: (_) {
              fireProceedEvent(context);
            },
          ),
        ],
      ),
    );
  }

  void fireProceedEvent(BuildContext context) {
    if (yourDetailModel.isProceed) {
      context.read<ProfileBloc>().add(
          ProfileEnabledProceedEvent(ProfileCompletionData.detailModelIndex));
    } else {
      context.read<ProfileBloc>().add(
          ProfileDisabledProceedEvent(ProfileCompletionData.detailModelIndex));
    }
  }
}
