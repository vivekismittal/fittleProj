import 'package:fittle_ai/common/deboune_search.dart';
import 'package:fittle_ai/model/food_search_model.dart';
import 'package:fittle_ai/resources/components/app_loader.dart';
import 'package:fittle_ai/resources/components/internet_connectivity_check.dart';
import 'package:fittle_ai/resources/resources.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/food_track_bloc.dart';
import '../../utils/screen_paths.dart';
import '../common/custom_loader_screen.dart';

class FoodSearchScreen extends StatelessWidget {
  const FoodSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String categoryType =
        ModalRoute.of(context)!.settings.arguments as String;

    return CustomScreenWithLoader(
      withGradient: false,
      body: BlocProvider(
        create: (context) => FoodTrackBloc(),
        child: FoodSearchBody(categoryType: categoryType),
      ),
      id: ScreenPaths.foodSearchScreenPath.name,
    );
  }
}

class FoodSearchBody extends StatelessWidget {
  const FoodSearchBody({super.key, required this.categoryType});
  final String categoryType;
  @override
  Widget build(BuildContext context) {
    return InternetConnectivityChecked(
        onTryAgain: () {
          fetchFoodSearchData(context, null, true);
        },
        child: Column(
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
                            fetchFoodSearchData(context, input, input.isEmpty);
                          });
                        },
                        cursorColor: AppColor.offBlackColor,
                        decoration: const InputDecoration(
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: "Search for food",
                          fillColor: Colors.transparent,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            BlocBuilder<FoodTrackBloc, FoodTrackState>(
                builder: (context, state) {
              if (state is! FoodSearchedState) {
                if (state is FoodSearchErrorState) {
                  // Toast.show(context, state.message);
                  return const SizedBox();
                }
                return darkAppLoader();
              } else {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: state.foodList.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              state.isFrequent
                                  ? "Frequently Tracked Foods"
                                  : "Search Results",
                              style: p12_500BlackTextStyle,
                            ),
                          );
                        }
                        final food = state.foodList[index - 1];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: InkWell(
                            onTap: () {
                              asyncNavigation(context, food);
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical:10),
                                    child: Text(
                                      food.foodName ?? "",
                                      style: p10_400BlackTextStyle.copyWith(fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircleAvatar(
                                    backgroundColor: AppColor.progressBarColor,
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
        ));
  }

  void asyncNavigation(BuildContext context, FoodList food) async {
    var data = await Navigator.of(context).pushNamed(
        ScreenPaths.foodDetailScreenPath.name,
        arguments: [food.foodId, categoryType]);
    if (data != null) {
      Navigator.pop(context, data);
    }
  }

  void fetchFoodSearchData(
      BuildContext context, String? keyword, bool isFrequent) {
    context
        .read<FoodTrackBloc>()
        .add(FoodSearchedEvent(foodKeyword: keyword, isFrequent: isFrequent));
  }
}
