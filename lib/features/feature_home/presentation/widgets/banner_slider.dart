import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nike_app/common/widgets/cached_images.dart';
import 'package:nike_app/features/feature_home/data/model/banner.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerSlider extends StatefulWidget {
  final List<BannerModel> bannerList;
  BannerSlider({super.key, required this.bannerList});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final PageController pageController = PageController();

  Timer? timer;

  int currentPage = 0;

  @override
  void initState() {
    sliderTimer(widget.bannerList);
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          PageView.builder(
              itemCount: widget.bannerList.length,
              controller: pageController,
              itemBuilder: (context, index) {
                return BannerItems(
                  banner: widget.bannerList[index],
                );
              }),
          Positioned(
              bottom: 8,
              child: SmoothPageIndicator(
                controller: pageController,
                count: widget.bannerList.length,
                axisDirection: Axis.horizontal,
                effect: WormEffect(
                    spacing: 4.0,
                    radius: 4.0,
                    dotWidth: 20.0,
                    dotHeight: 2.0,
                    paintStyle: PaintingStyle.fill,
                    dotColor: Colors.grey.shade400,
                    activeDotColor: Theme.of(context).colorScheme.onBackground),
              ))
        ],
      ),
    );
  }

  sliderTimer(List<BannerModel> bannerList) {
    timer ??= Timer.periodic(const Duration(seconds: 3), (timer) {
      if (currentPage < bannerList.length - 1) {
        currentPage++;
      } else {
        currentPage = 0;
      }
      if (pageController.positions.isNotEmpty) {
        pageController.animateToPage(currentPage,
            duration: const Duration(milliseconds: 350), curve: Curves.easeIn);
      }
    });
  }
}

class BannerItems extends StatelessWidget {
  final BannerModel banner;
  const BannerItems({
    super.key,
    required this.banner,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: CachedImage(
        imageUrl: banner.imageUrl,
        borderRadius: 12,
      ),
    );
  }
}
