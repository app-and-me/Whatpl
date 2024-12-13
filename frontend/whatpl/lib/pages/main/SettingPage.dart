import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:whatpl/pages/main/LoginPage.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 22),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    tr('profile.setting'),
                    style: const TextStyle(
                      color: Color(0xFF121212),
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () {
                  },
                ),
                ListTile(
                  title: Text(
                    tr('profile.language'),
                    style: const TextStyle(
                      color: Color(0xFF121212),
                      fontSize: 16,
                      fontFamily: 'Pretendard Variable',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('language.title').tr(),
                          content: DropdownButton<String>(
                          value: Get.locale?.languageCode == 'en' ? 'English' 
                              : Get.locale?.languageCode == 'ko' ? '한국어'
                              : Get.locale?.languageCode == 'zh' ? '中文'
                              : 'Türkçe',
                          items: <String>['English', '한국어', '中文', 'Türkçe'].map((String value) {
                            return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                            Get.updateLocale(newValue == 'English' 
                              ? const Locale('en', "US") 
                              : newValue == '한국어' 
                              ? const Locale('ko', "KR")
                              : newValue == '中文'
                              ? const Locale('zh', "CN")
                              : const Locale('tr', "TR"));
                            EasyLocalization.of(Get.context!)!.setLocale(newValue == 'English' 
                              ? const Locale('en', "US") 
                              : newValue == '한국어' 
                              ? const Locale('ko', "KR")
                              : newValue == '中文'
                              ? const Locale('zh', "CN")
                              : const Locale('tr', "TR"));

                            Navigator.of(context).pop();
                            }
                          },
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('language.cancel').tr(),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    tr('profile.alarm'),
                    style: const TextStyle(
                      color: Color(0xFF121212),
                      fontSize: 16,
                      fontFamily: 'Pretendard Variable',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () {
                  },
                ),
              ],
            )
          ),
          const Divider(
            color: Color(0xFFD1D1D6),
            thickness: 0.5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 22),
            child: ListTile(
              title: Text(
                tr('profile.logout'),
                style: const TextStyle(
                  color: Color(0xFFFF2F2F),
                  fontSize: 16,
                  fontFamily: 'Pretendard Variable',
                  fontWeight: FontWeight.w400,
                ),
              ),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Get.offAll(() => const LoginPage());
              },
            ),
          ),
        ],
      )
    );
  }
}