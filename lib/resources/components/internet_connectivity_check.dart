import 'dart:io';

import 'package:fittle_ai/resources/components/try_again.dart';
import 'package:flutter/material.dart';

class InternetConnectivityChecked extends StatefulWidget {
  const InternetConnectivityChecked(
      {super.key, required this.onTryAgain, required this.child});
  final void Function() onTryAgain;
  final Widget child;

  @override
  State<InternetConnectivityChecked> createState() =>
      _InternetConnectivityCheckedState();
}

class _InternetConnectivityCheckedState
    extends State<InternetConnectivityChecked> {
  late bool hasInternet = true;
  @override
  void initState() {
    super.initState();
    // widget.onTryAgain();
    updateStatus();
  }

  @override
  Widget build(BuildContext context) {
    return hasInternet
        ? widget.child
        : TryAgain(
            title: "No Internet Connection!",
            onTryAgain: () {
              updateStatus();
            },
          );
  }

  void updateStatus() async {
    hasInternet = await hasNetwork();
    if (hasInternet) {
      widget.onTryAgain();
    }
    setState(() {});
  }

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
