import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:whatpl/pages/main/MapPage.dart';
import 'package:whatpl/pages/main/HomePage.dart';
import 'package:whatpl/pages/main/ProfilePage.dart';
import 'package:whatpl/widgets/MyAppBar.dart';
import 'package:whatpl/widgets/MyBottomNavigationBar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final pages = [
    const HomePage(),
    const MapPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: MyAppBar(
          onNotificationPressed: () {
            Get.to(() => const ());
          },
          currentIndex: _currentIndex
        ),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}