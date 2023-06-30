import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class BaseGradientBackGround extends StatelessWidget {
  const BaseGradientBackGround({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: Constant.backgroundGradient,
      ),
      child: child,
    );
  }
}
