import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationButtons extends StatelessWidget {
  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
  }

  final bool isLastPage;
  final VoidCallback onSkip;
  final VoidCallback onNext;
  final Color primaryColor;
  final Color fontColor;
  final double width;

  const NavigationButtons({
    super.key,
    required this.isLastPage,
    required this.onSkip,
    required this.onNext,
    required this.primaryColor,
    required this.fontColor,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return isLastPage
        ? Padding(
            padding: const EdgeInsets.all(30),
            child: ElevatedButton(
              onPressed: () async {
                await _completeOnboarding();
                Get.offAllNamed('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: fontColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                elevation: 5,
                padding: (width <= 550)
                    ? const EdgeInsets.symmetric(horizontal: 100, vertical: 20)
                    : EdgeInsets.symmetric(
                        horizontal: width * 0.2, vertical: 25),
                textStyle: TextStyle(fontSize: (width <= 550) ? 13 : 17),
              ),
              child: const Text("COMENZAR"),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: onSkip,
                  style: TextButton.styleFrom(
                    foregroundColor: fontColor,
                    elevation: 0,
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: (width <= 550) ? 13 : 17,
                    ),
                  ),
                  child: const Text("SALTAR"),
                ),
                ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: fontColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    elevation: 5,
                    padding: (width <= 550)
                        ? const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20)
                        : const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 25),
                    textStyle: TextStyle(fontSize: (width <= 550) ? 13 : 17),
                  ),
                  child: const Text("SIGUIENTE"),
                ),
              ],
            ),
          );
  }
}
