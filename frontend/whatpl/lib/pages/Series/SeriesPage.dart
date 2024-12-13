import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shimmer/shimmer.dart';
import 'package:whatpl/api/SeriesApi.dart';
import 'package:whatpl/pages/map/InnerMap.dart';

class SeriesPage extends StatefulWidget {
  final String title;
  final String mediaType;
  final dynamic places;

  const SeriesPage({
    super.key,
    required this.title,
    required this.mediaType,
    required this.places,
  });

  @override
  SeriesPageState createState() => SeriesPageState();
}

class SeriesPageState extends State<SeriesPage> {
  late Map<String, dynamic> series = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSeries();
  }

  Future<void> _loadSeries() async {
    try {
      final data = await SeriesApi.getSeriesByTitle(widget.title, widget.mediaType, Get.locale?.languageCode ?? 'en',);
      setState(() {
        series = data['data'];
        isLoading = false;
      });
    } catch (e) {
      print('Error loading series: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: isLoading ? _buildSkeletonBody() : _buildSeriesContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0,
      title: isLoading
          ? _buildSkeletonText(width: 150)
          : _buildAppBarTitle(),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, size: 30),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildAppBarTitle() {
    return Text(
      widget.title,
      style: TextStyle(
        color: Colors.black,
        fontSize: (series['name']?.length ?? 0) > 20 ? 16 : 20,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w600,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSeriesContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverview(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 300),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/heart.svg',
                ),
                const SizedBox(width: 7),
                const Text(
                  '2,372',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          _buildPlaces()
        ],
      ),
    );
  }

  Widget _buildOverview() {
    return Padding(
      padding: const EdgeInsets.only(left: 74, top: 28, right: 74),
      child: Text(
        series['overview']?.replaceAll('"', '').replaceAll('\n', '') ?? 
        'No description available',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w400,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
      ),
    );
  }

  Widget _buildPlaces() {
    return Padding(
      padding: const EdgeInsets.only(left: 19, top: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...widget.places.map((place) => PlaceCard(place: place)).toList(),
        ],
      ),
    );
  }

  Widget _buildSkeletonText({double width = 100}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: 20,
        color: Colors.grey[300],
      ),
    );
  }

  Widget _buildSkeletonBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 28),
      child: Column(
        children: [
          _buildSkeletonLine(),
          _buildSkeletonLine(),
        ],
      ),
    );
  }

  Widget _buildSkeletonLine() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: 16,
        color: Colors.grey[300],
        margin: const EdgeInsets.only(bottom: 8),
      ),
    );
  }
}

class PlaceCard extends StatelessWidget {
  final dynamic place;

  const PlaceCard({
    super.key,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector( 
      onTap: () {
        Get.to(() => InnerMap(
          title: place['placeName'],
          longitude: double.parse(place['longitude']),
          latitude: double.parse(place['latitude']),
        ));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30, right: 30),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/location.svg',
            ),
            const SizedBox(width: 15),
            SvgPicture.asset(
              'assets/icons/divider.svg',
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          place['placeName'] ?? 'No Name',
                          style: const TextStyle(
                            color: Color(0xFF121212),
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          place['address'] ?? 'No Address',
                          style: const TextStyle(
                            color: Color(0xFF717577),
                            fontSize: 12,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    place['hours'] ?? 'No Hours',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
