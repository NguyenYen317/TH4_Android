import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:th4_e_commerce_app/utils/constants.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final height = screenWidth < 600 ? 160 : 200;

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: AppConstants.bannerUrls.length,
          itemBuilder: (context, index, _) {
            final imageUrl = AppConstants.bannerUrls[index];
            final borderRadius = screenWidth < 420 ? 8.0 : 12.0;
            return ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Container(
                        color: Colors.grey.shade200,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      );
                    },
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.45),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 14,
                    bottom: 12,
                    child: Text(
                      'Khuyến mãi tới 70%',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          options: CarouselOptions(
            height: height.toDouble(),
            autoPlay: true,
            viewportFraction: 1,
            autoPlayInterval: const Duration(seconds: 4),
            onPageChanged: (index, _) {
              setState(() {
                _activeIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            AppConstants.bannerUrls.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _activeIndex == index ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _activeIndex == index
                    ? const Color(0xFF0096D6)
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
