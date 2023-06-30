import 'package:fittle_ai/resources/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/loader_bloc.dart';
import '../../resources/components/app_loader.dart';
import '../../utils/constants.dart';
import 'custom_screen.dart';

class CustomScreenWithLoader extends StatelessWidget {
  const CustomScreenWithLoader({
    super.key,
    required this.body,
    required this.id,
    this.appBar,
    this.withGradient = true,
    this.bottomNavigationBar,
  });

  final Widget body;
  final String id;
  final PreferredSizeWidget? appBar;
  final bool withGradient;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      scaffold: DecoratedBox(
        decoration: BoxDecoration(
          gradient: withGradient ? Constant.backgroundGradient : null,
          color: withGradient ? null : AppColor.backgroundColor,
        ),
        child: Stack(
          children: [
            Scaffold(
              bottomNavigationBar: bottomNavigationBar,
              appBar: appBar,
              backgroundColor: Colors.transparent,
              body: body,
            ),
            // BlocBuilder<LoaderBloc, LoaderState>(
            //   builder: (context, loaderState) =>
            //       (loaderState is LoadingEnabled) && (loaderState.id == id)
            //           ? const Opacity(
            //               opacity: 0.5,
            //               child: ModalBarrier(
            //                   dismissible: false, color: Colors.black))
            //           : const SizedBox(),
            // ),
            BlocBuilder<LoaderBloc, LoaderState>(
              builder: (context, loaderState) =>
                  (loaderState is LoadingEnabled) && (loaderState.id == id)
                      ? Center(child: darkAppLoader())
                      : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
