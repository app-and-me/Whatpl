import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class InnerMap extends StatefulWidget {
  final String title;
  final double longitude;
  final double latitude;

  const InnerMap({
    super.key,
    required this.title,
    required this.longitude,
    required this.latitude,
  });

  @override
  // ignore: library_private_types_in_public_api
  InnerMapState createState() => InnerMapState();
}

class InnerMapState extends State<InnerMap> {
  late KakaoMapController mapController;
  Set<Marker> markers = {};


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Text(widget.title),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: KakaoMap(
        onMapCreated: ((controller) async {
          mapController = controller;

          markers.add(Marker(
            markerId: UniqueKey().toString(),
            latLng: await mapController.getCenter(),
          ));

          setState(() { });
        }),
        markers: markers.toList(),
        center: LatLng(widget.latitude, widget.longitude),
      ),
    );
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}