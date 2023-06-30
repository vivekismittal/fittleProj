import 'package:fittle_ai/common/form_input_field.dart';
import 'package:fittle_ai/model/profile_data.dart';
import 'package:fittle_ai/resources/app_color.dart';
import 'package:fittle_ai/resources/components/toast.dart';
import 'package:fittle_ai/screens/common/custom_loader_screen.dart';
import 'package:fittle_ai/utils/extensions.dart';
import 'package:fittle_ai/utils/screen_paths.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../resources/components/show_date_picker.dart';
import '../../resources/components/texts/custom_text.dart';
import '../../utils/countries.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileData userData =
        ModalRoute.of(context)!.settings.arguments as ProfileData;

    return CustomScreenWithLoader(
      withGradient: false,
      body: EditProfileBody(userData: userData),
      id: ScreenPaths.editProfileScreenPath.name,
    );
  }
}

class EditProfileBody extends StatelessWidget {
  const EditProfileBody({super.key, required this.userData});
  final ProfileData userData;
  @override
  Widget build(BuildContext context) {
    String countryCode = userData.profileData?.mobile
            ?.substring(0, (userData.profileData?.mobile?.length ?? 0) - 10) ??
        "+91";
    String mobile = userData.profileData?.mobile
            ?.substring((userData.profileData?.mobile?.length ?? 0) - 10) ??
        "";

    TextEditingController nameController =
        TextEditingController(text: userData.profileData?.fullName);
    TextEditingController emailController =
        TextEditingController(text: userData.profileData?.email);
    TextEditingController heightController = TextEditingController(
        text: userData.profileData?.height?.toStringAsFixed(2));
    TextEditingController weightController =
        TextEditingController(text: userData.profileData?.weight.toString());
    DateTime dob = userData.profileData?.dob ?? DateTime.now();
    TextEditingController mobileController =
        TextEditingController(text: mobile);
    String selectedGender = userData.profileData?.gender.toString() ?? "male";
    Map<String, IconData> genderOptions = {
      "Male": Icons.male_outlined,
      "Female": Icons.female_outlined,
      "Other": Icons.more_horiz_outlined,
    };
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                Text("Edit Profile", style: p12_400BlackTextStyle),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    String fullName = nameController.text;
                    String email = emailController.text;
                    double height = double.tryParse(heightController.text) ?? 0;
                    double weight = double.tryParse(weightController.text) ?? 0;
                    if (fullName.isEmpty ||
                        email.isEmpty ||
                        !email.isValidEmail() ||
                        height == 0 ||
                        weight == 0) {
                      Toast.show(context, "Please enter valid values");
                      return;
                    }
                    // ProfileData newProfileData =
                    userData.profileData?.dob=dob;
                    userData.profileData?.fullName=fullName;
                    userData.profileData?.email=email;
                    userData.profileData?.gender=selectedGender;
                    userData.profileData?.height=height;
                    userData.profileData?.weight=weight;

                    
                    Navigator.pop(context, userData);
                  },
                  child: Text(
                    "Save",
                    style: p12_400BlackTextStyle.copyWith(
                        color: AppColor.progressBarColor),
                  ),
                )
              ],
            ),
            const SizedBox(height: 34),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 85,
                width: 85,
                padding: const EdgeInsets.all(2),
                decoration: ShapeDecoration(
                  shape: CircleBorder(
                    side: BorderSide(
                        color: AppColor.progressBarColor.withOpacity(.2),
                        width: 3),
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: AppColor.progressBarColor.withOpacity(.3),
                  child: const Icon(
                    Icons.person,
                    color: AppColor.lightBlackColor,
                    size: 48,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              "Name",
              style: p10_400LBlackTextStyle,
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 44,
              child: FormInputField(
                label: InputFieldsLabel.normal,
                radius: 10,
                hintText: "Enter your Name",
                controller: nameController,
                style: p12_400BlackTitleTextStyle,
                contentPadding: const EdgeInsets.all(12),
                showCursor: true,
                cursorColor: AppColor.blackColor,
                hintStyle: p12_400GreyTextStyle,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              "Email Address",
              style: p10_400LBlackTextStyle,
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 44,
              child: FormInputField(
                label: InputFieldsLabel.normal,
                radius: 10,
                hintText: "Enter your Email",
                controller: emailController,
                style: p12_400BlackTitleTextStyle,
                contentPadding: const EdgeInsets.all(12),
                showCursor: true,
                cursorColor: AppColor.blackColor,
                hintStyle: p12_400GreyTextStyle,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              "Phone Number",
              style: p10_400LBlackTextStyle,
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 44,
              child: Row(
                children: [
                  Container(
                    height: 44,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.whiteColor.withOpacity(0.3),
                    ),
                    child: Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(
                              countries
                                  .firstWhere((element) =>
                                      element.dialCode == countryCode)
                                  .flag,
                              style: const TextStyle(fontSize: 24),
                            )
                            // icon,
                            ),
                        Text(
                          " $countryCode",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColor.blackColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FormInputField(
                      enabled: false,
                      label: InputFieldsLabel.normal,
                      radius: 10,
                      hintText: "Enter your Mobile",
                      controller: mobileController,
                      style: p12_400BlackTitleTextStyle,
                      contentPadding: const EdgeInsets.all(12),
                      showCursor: true,
                      cursorColor: AppColor.blackColor,
                      hintStyle: p12_400GreyTextStyle,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Text(
              "Gender",
              style: p10_400LBlackTextStyle,
            ),
            const SizedBox(height: 5),
            StatefulBuilder(
              builder: (context, setState) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    genderOptions.length,
                    (index) => InkWell(
                      onTap: () {
                        setState(
                          () {
                            selectedGender = genderOptions.keys
                                .toList()[index]
                                .toLowerCase();
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: (genderOptions.keys
                                      .toList()[index]
                                      .toLowerCase() ==
                                  selectedGender
                              ? AppColor.progressBarColor
                              : AppColor.whiteColor.withOpacity(.3)),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 22),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              genderOptions.values.toList()[index],
                              color: genderOptions.keys
                                          .toList()[index]
                                          .toLowerCase() ==
                                      selectedGender
                                  ? AppColor.whiteColor
                                  : AppColor.offBlackColor,
                            ),
                            Text(
                              genderOptions.keys.toList()[index],
                              style: p10_400OffBlackTextStyle.copyWith(
                                  color: genderOptions.keys
                                              .toList()[index]
                                              .toLowerCase() ==
                                          selectedGender
                                      ? AppColor.whiteColor
                                      : AppColor.offBlackColor),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 22),
            Text(
              "Height in ft",
              style: p10_400LBlackTextStyle,
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 44,
              child: FormInputField(
                label: InputFieldsLabel.normal,
                radius: 10,
                hintText: "Enter your height in ft",
                controller: heightController,
                style: p12_400BlackTitleTextStyle,
                contentPadding: const EdgeInsets.all(12),
                showCursor: true,
                cursorColor: AppColor.blackColor,
                hintStyle: p12_400GreyTextStyle,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              "Weight in kg",
              style: p10_400LBlackTextStyle,
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 44,
              child: FormInputField(
                label: InputFieldsLabel.normal,
                radius: 10,
                hintText: "Enter your weight in kg",
                controller: weightController,
                style: p12_400BlackTitleTextStyle,
                contentPadding: const EdgeInsets.all(12),
                showCursor: true,
                cursorColor: AppColor.blackColor,
                hintStyle: p12_400GreyTextStyle,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              "Date of Birth",
              style: p10_400LBlackTextStyle,
            ),
            const SizedBox(height: 5),
            StatefulBuilder(builder: (context, setState) {
              return SizedBox(
                height: 44,
                child: Row(
                  children: [
                    Expanded(
                      child: FormInputField(
                        enabled: false,
                        label: InputFieldsLabel.normal,
                        radius: 10,
                        hintText: "Select your dob from side calender",
                        controller: TextEditingController(
                            text: DateFormat('yMMMMd').format(dob)),
                        style: p12_400BlackTitleTextStyle,
                        contentPadding: const EdgeInsets.all(12),
                        showCursor: true,
                        cursorColor: AppColor.blackColor,
                        hintStyle: p12_400GreyTextStyle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        selectDate(
                          context,
                          DateTime.now(),
                          (dateSelected) {
                          
                            setState(
                              () {
                                dob = dateSelected;
                              },
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: AppColor.outlineColor, width: .5)),
                        child: const Center(
                          child: Icon(
                            Icons.calendar_month,
                            color: AppColor.outlineColor,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
