import 'package:fittle_ai/Utils/screen_paths.dart';
import 'package:fittle_ai/bloc/event/profile_event.dart';
import 'package:fittle_ai/bloc/loader_bloc.dart';
import 'package:fittle_ai/bloc/navigation_bloc.dart';
import 'package:fittle_ai/bloc/profile_bloc.dart';
import 'package:fittle_ai/bloc/state/profile_state.dart';
import 'package:fittle_ai/resources/components/toast.dart';
import 'package:fittle_ai/screens/profile_completion/screen_model.dart/profile_completion_data.dart';
import 'package:fittle_ai/screens/profile_completion/screen_model.dart/profile_completion_page_data.dart';
import 'package:fittle_ai/screens/profile_completion/widgets/page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../resources/resources.dart';
import '../common/custom_loader_screen.dart';

class ProfileCompeletionScreen extends StatelessWidget {
  const ProfileCompeletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreenWithLoader(
      body: BlocProvider(
        create: (context) => ProfileBloc(),
        child: ProfileCompletionBody(),
      ),
      id: ScreenPaths.profileCompletionScreenPath.name,
    );
  }
}

// ignore: must_be_immutable
class ProfileCompletionBody extends StatelessWidget {
  ProfileCompletionBody({super.key});

  ProfileCompletionData profileCompeletionData = ProfileCompletionData();
  @override
  Widget build(BuildContext context) {
    var addEventFunc = context.read<ProfileBloc>().add;
    int currentIndex = 0;
    int? incomingProfileIndex =
        ModalRoute.of(context)!.settings.arguments as int?;
    if (incomingProfileIndex != null) {
      currentIndex = incomingProfileIndex - 1;
    }
    List<ProfileCompletionPageData> listOfProfilePages =
        listOfCompleteProfilePages(profileCompeletionData);
    int pageLength = listOfProfilePages.length;

    bool isProceedEnabled = false;
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        switch (profileState.runtimeType) {
          case ProfileCreatedUpdatedState:
            context.read<LoaderBloc>().add(DisabledLoadingEvent(
                ScreenPaths.profileCompletionScreenPath.name));
            var nextIndex =
                (profileState as ProfileCreatedUpdatedState).nextPageIndex;
            if (profileState.isProfileComplete) {
              context.read<NavigationBloc>().add(
                  ScreenPushedAndRemoveUntilEvent(
                      ScreenPaths.homeDashBoardPath.name, ""));
              break;
            } else if (nextIndex <= pageLength - 1) {
              currentIndex = nextIndex;
            }

            break;
          case ProfileLoadingState:
            context.read<LoaderBloc>().add(EnabledLoadingEvent(
                ScreenPaths.profileCompletionScreenPath.name));
            break;
          case ProfileErrorState:
            context.read<LoaderBloc>().add(DisabledLoadingEvent(
                ScreenPaths.profileCompletionScreenPath.name));
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Toast.show(
                  context,
                  (profileState as ProfileErrorState)
                      .message); // Call showSnackBar() after the current frame
            });
            break;
          case ProfileBackState:
            if (currentIndex > 0) currentIndex--;
            break;

          case ProfileEnabledProceedState:
            if ((profileState as ProfileEnabledProceedState).index ==
                currentIndex) {
              isProceedEnabled = true;
            }
            break;
          case ProfileDisabledProceedState:
            if ((profileState as ProfileDisabledProceedState).index ==
                currentIndex) {
              isProceedEnabled = false;
            }
            break;
          default:
            break;
        }
        bool isFirstPage = currentIndex == 0;
        ProfileCompletionPageData currentPageModel =
            listOfProfilePages[currentIndex];

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 48,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 22,
                ),
                Expanded(
                  child: PageIndicator(
                    numberOfPages: pageLength,
                    currentIndex: currentIndex,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                const SizedBox(width: 22),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              currentPageModel.title,
              style: m24_600WhiteTextStyle,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 64, right: 64, top: 6),
              child: Text(
                currentPageModel.subTitle,
                style: p11_400ParaTextStyle.copyWith(fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 46,
              ),
              child: currentPageModel.child,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: Row(
                children: [
                  Visibility(
                    visible: !isFirstPage,
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: BaseTextButton(
                          isActive: true,
                          title: "BACK",
                          isFilled: false,
                          onPressed: () {
                            addEventFunc(ProfileBackEvent());
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: BaseTextButton(
                      isActive: isProceedEnabled,
                      title: isFirstPage
                          ? 'Get Started'
                          : currentIndex < pageLength - 1
                              ? "NEXT"
                              : "FINISH",
                      isFilled: true,
                      onPressed: () {
                        addCreateProfileEvent(currentIndex, addEventFunc,
                            isProfileFinished:
                                !(currentIndex < pageLength - 1));
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 46,
            ),
          ],
        );
      },
    );
  }

  void addCreateProfileEvent(
      int currentIndex, void Function(ProfileEvent) addEventFunc,
      {bool isProfileFinished = false}) {
    var data = profileCompeletionData.profileModelList[currentIndex].getData();
    addEventFunc(ProfileCreatedUpdatedEvent(currentIndex, data,
        isProfileFinished: isProfileFinished));
  }
}
