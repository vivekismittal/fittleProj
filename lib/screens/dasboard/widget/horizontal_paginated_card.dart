import 'dart:async';

import 'package:fittle_ai/resources/resources.dart';
import 'package:flutter/material.dart';

import '../../../model/home_dashboard_response.dart';

class HorizontalCardPager extends StatefulWidget {
  final List<BannerModel> bannerData;

  const HorizontalCardPager({
    super.key,
    required this.bannerData,
  });
  @override
  State<HorizontalCardPager> createState() => _HorizontalCardPagerState();
}

class _HorizontalCardPagerState extends State<HorizontalCardPager> {
  int _currentPage = 0;


 late final PageController _pageController ;

  @override
  void initState() {
    super.initState();
    _pageController=PageController(
    initialPage: 0,
  );
  Timer.periodic(const Duration(seconds: 2), (Timer timer) {

      if (_currentPage < widget.bannerData.length -1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 74,
          // margin: const EdgeInsets.symmetric(horizontal: 22),
          child: PageView.builder(
            controller: _pageController,
            padEnds: true,
            itemCount: widget.bannerData.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Image.network(
                  widget.bannerData[index].bannerImage ?? "",
                  fit: BoxFit.fill,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10.0),
        _buildPageIndicator(),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(widget.bannerData.length, (int index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          width: _currentPage == index ? 12.0 : 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                _currentPage == index ? AppColor.progressBarColor : Colors.grey,
          ),
        );
      }),
    );
  }
}
