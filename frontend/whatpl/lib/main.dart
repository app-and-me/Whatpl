import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:whatpl/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatpl/pages/MainPage.dart';
import 'package:whatpl/pages/main/LoginPage.dart';
import 'package:whatpl/pages/main/MapPage.dart';
import 'package:whatpl/pages/main/HomePage.dart';
import 'package:whatpl/pages/main/ProfilePage.dart';

Future<void> main() async {  
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();
  AuthRepository.initialize(appKey: 'f728b1e2612a4fb84bce03fec70c41d3');

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('ko', 'KR'), 
        Locale('en', 'US'),
        Locale('zh', 'CN'),
        Locale('tr', 'TR'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        GetPage(name: '/', page: () => const MainPage()),
        GetPage(name: '/profile', page: () => const ProfilePage()),
        GetPage(name: '/home', page: () => const HomePage()),
        GetPage(name: '/map', page: () => const MapPage()),
        GetPage(name: '/login', page: () => const LoginPage()),
      ],
      translations: null,
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/login' : '/',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
    );
  }
}


