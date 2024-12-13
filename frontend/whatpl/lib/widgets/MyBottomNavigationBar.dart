import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MyBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xFF4D4D4D),
            width: 0.4,
          ),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: const Color(0xffffffff),
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/home.svg',
              color: currentIndex == 0 ? const Color(0xFFFD7E14) : null,
            ),
            label: 'nav.home'.tr(),
          ),
            BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/map.svg',
              color: currentIndex == 1 ? const Color(0xFFFD7E14) : null,
            ),
            label: 'nav.map'.tr(),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/profile.svg',
              color: currentIndex == 2 ? const Color(0xFFFD7E14) : null,
            ),
            label: 'nav.profile'.tr(),
          ),
        ],
        selectedItemColor: const Color(0xFFFD7E14),
        unselectedItemColor: const Color(0xFF717577),
      ),
    );
  }
}