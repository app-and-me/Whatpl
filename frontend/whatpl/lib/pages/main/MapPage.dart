import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  late KakaoMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KakaoMap(
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
        onMapTap: (latLng) {
          debugPrint('***** [JHC_DEBUG] ${latLng.toString()}');
        },
      ),
    );
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}