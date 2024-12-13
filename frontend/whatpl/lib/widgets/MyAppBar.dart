import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:whatpl/pages/main/SettingPage.dart';

class MyAppBar extends StatelessWidget {
  final VoidCallback onNotificationPressed;
  final int currentIndex;

  const MyAppBar({
    super.key,
    required this.onNotificationPressed,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return currentIndex == 0 ?
      AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/images/logo.png',
          width: 135,
          height: 72,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/search.svg',
            ),
            onPressed: () {
              
            },
          ),
        ],
      ) : 
      currentIndex == 2 ?
      AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/setting.svg',
            ),
            onPressed: () {
              Get.to(() => const SettingPage());
            },
          ),
        ],
      ) : AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
      );
  }
}