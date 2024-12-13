import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:whatpl/api/ImageApi.dart';
import 'package:whatpl/api/SeriesApi.dart';
import 'package:whatpl/pages/Series/SeriesPage.dart';
import 'package:easy_localization/easy_localization.dart';

class PosterSection {
  final String title;
  final List<PosterData> posters;

  const PosterSection({
    required this.title,
    required this.posters,
  });
}

class PosterData {
  final String imageUrl;
  final String title;
  final String mediaType;
  final String type;
  final String original;

  const PosterData({
    required this.imageUrl,
    required this.title,
    required this.mediaType,
    required this.type,
    required this.original,
  });
}

class SeriesData {
  final String title;
  final String mediaType;
  final String placeName;
  final String type;
  final String description;
  final String hours;
  final String breakTime;
  final String holidays;
  final String address;
  final String latitude;
  final String longitude;
  final String phone;

  SeriesData.fromMap(Map<String, dynamic> map)
      : title = map['제목'],
        mediaType = map['미디어타입'],
        placeName = map['장소명'],
        type = map['장소타입'],
        description = map['장소설명'],
        hours = map['영업시간'],
        breakTime = map['브레이크타임'],
        holidays = map['휴무일'],
        address = map['주소'],
        latitude = map['위도'],
        longitude = map['경도'],
        phone = map['전화번호'];
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static const int _postersPerSection = 5;
  
  final List<String> _sectionTitles = [
    tr('sectionTitle.1'),
    tr('sectionTitle.2'),
    tr('sectionTitle.3'),
    tr('sectionTitle.4'),
  ];

  final Map<String, List<Map<String, dynamic>>> _places = {};
  final List<PosterSection> _sections = [];
  
  bool _isLoading = true;
  bool _isLoadingMore = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeSections();
    _loadInitialData();
  }

  void _initializeSections() {
    _sections.clear();
    _sections.addAll(_sectionTitles.map(
      (title) => PosterSection(title: title, posters: [])
    ));
  }

  Future<void> _loadInitialData() async {
    try {
      final response = await SeriesApi.getSeriesByCsv();
      final seriesData = _processSeriesData(response);
      await _processAndUpdateData(seriesData);
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<SeriesData> _processSeriesData(Map<String, dynamic> response) {
    return (response['data'] as List)
        .map((item) => SeriesData.fromMap(item))
        .toList();
  }

  Future<void> _processAndUpdateData(List<SeriesData> seriesData) async {
    if (!mounted) return;

    final Map<String, SeriesData> uniqueSeries = {};
    final Map<String, List<Map<String, dynamic>>> groupedPlaces = {};
    
    for (var item in seriesData) {
      uniqueSeries[item.title] = item;
      
      if (!groupedPlaces.containsKey(item.title)) {
        groupedPlaces[item.title] = [];
      }
      
      groupedPlaces[item.title]!.add({
        "type": item.type,
        "placeName": item.placeName,
        "description": item.description,
        "hours": item.hours,
        "breakTime": item.breakTime,
        "holidays": item.holidays,
        "address": item.address,
        "latitude": item.latitude,
        "longitude": item.longitude,
        "phone": item.phone,
      });
    }

    _places.clear();
    _places.addAll(groupedPlaces);

    setState(() => _isLoading = false);
    await _loadNextBatch(uniqueSeries);
  }

  Future<void> _loadNextBatch(Map<String, SeriesData> uniqueSeries) async {
    if (!mounted || _isLoadingMore) return;
    
    setState(() => _isLoadingMore = true);

    try {
      final posters = await _fetchValidPosters(uniqueSeries);
      _updateSectionsWithPosters(posters);
    } finally {
      if (mounted) {
        setState(() => _isLoadingMore = false);
      }
    }
  }

  Future<List<PosterData>> _fetchValidPosters(
    Map<String, SeriesData> uniqueSeries) async {
    final batch = _sections.length * _postersPerSection;
    final titles = uniqueSeries.keys.toList();
    final end = min(_currentIndex + batch, titles.length);
    final currentBatch = titles.sublist(_currentIndex, end);

    List<PosterData> validPosters = [];
    
    for (var title in currentBatch) {
      if (!mounted) break;

      try {
        final seriesInfo = await SeriesApi.getSeriesByTitle(
          title,
          uniqueSeries[title]!.mediaType,
          Get.locale?.languageCode ?? 'en'
        );

        final englishName = seriesInfo['data']['name'] ?? title;
        if (englishName.toString().isEmpty) {
          continue;
        }
        

        final poster = await _createPoster(
          title,
          uniqueSeries[title]!,
          seriesInfo['data']['name'],
          seriesInfo['data']['original_name'],
        );
        
        if (poster != null) {
          validPosters.add(poster);
        }
      } catch (e) {
        // Skip on error
        continue;
      }
    }

    return validPosters;
  }

  Future<PosterData?> _createPoster(
    String title,
    SeriesData item,
    String englishName,
    String original,
  ) async {
    final img = await ImageApi.getImage(
      title,
      Get.locale?.languageCode ?? 'en',
      item.mediaType,
    );

    if (!mounted || img['image'].toString().contains('status')) {
      return null;
    }

    return PosterData(
      imageUrl: img['image'],
      title: englishName,
      mediaType: item.mediaType,
      type: item.type,
      original: original,
    );
  }

  void _updateSectionsWithPosters(List<PosterData> posters) {
    if (!mounted) return;

    setState(() {
      _currentIndex += posters.length;
      
      for (var i = 0; i < _sectionTitles.length; i++) {
        final start = i * _postersPerSection;
        final end = min(start + _postersPerSection, posters.length);
        
        if (start < posters.length) {
          _sections[i] = PosterSection(
            title: _sections[i].title,
            posters: posters.sublist(start, end),
          );
        }
      }
    });
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
      _currentIndex = 0;
      _initializeSections();
    });
    await _loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              ..._sections.map(_buildSection),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(PosterSection section) {
    if (_isLoading) {
      return const SkeletonPosterSection();
    }

    if (section.posters.isEmpty && !_isLoadingMore) {
      return const SizedBox.shrink();
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 16, top: 38),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(section),
          const SizedBox(height: 16),
          _buildPosterList(section),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(PosterSection section) {
    if (_isLoadingMore && section.posters.isEmpty) {
      return _buildShimmerTitle();
    }

    return Text(
      section.title,
      style: const TextStyle(
        color: Color(0xFF121212),
        fontSize: 20,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildShimmerTitle() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 200,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildPosterList(PosterSection section) {
    return SizedBox(
      height: 180,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...section.posters.map((poster) => Padding(
              padding: const EdgeInsets.only(right: 10),
              child: PosterCard(
                imageUrl: poster.imageUrl,
                title: poster.title,
                mediaType: poster.mediaType,
                places: _places[poster.original] ?? [], // List로 전달
              ),
            )),
            if (_isLoadingMore) ..._buildLoadingPosters(section),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildLoadingPosters(PosterSection section) {
    return List.generate(
      _postersPerSection - section.posters.length,
      (index) => const Padding(
        padding: EdgeInsets.only(right: 10),
        child: SkeletonPosterCard(),
      ),
    );
  }
}

class SkeletonPosterSection extends StatelessWidget {
  const SkeletonPosterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 16, top: 38),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 200,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 145,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                children: List.generate(
                  5,
                  (index) => const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: SkeletonPosterCard(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SkeletonPosterCard extends StatelessWidget {
  const SkeletonPosterCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 103,
        height: 133,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
      ),
    );
  }
}

class PosterCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String mediaType;
  final List<Map<String, dynamic>> places;

  const PosterCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.mediaType,
    required this.places,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => SeriesPage(
        title: title,
        mediaType: mediaType,
        places: places,
      )),
      child: SizedBox(
        width: 103,
        height: 180,
        child: Column(
          children: [
            _buildPosterImage(),
            const SizedBox(height: 9),
            _buildPosterTitle(),
          ],
        ),
      ),
    );
  }

  Widget _buildPosterImage() {
    return Container(
      width: 103,
      height: 133,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          frameBuilder: _buildImageFrame,
          errorBuilder: _buildErrorWidget,
        ),
      ),
    );
  }

  Widget _buildPosterTitle() {
    return Expanded(
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 13,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.start,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildImageFrame(
      BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
    if (wasSynchronouslyLoaded || frame != null) {
      return child;
    }
    return const SkeletonPosterCard();
  }

  Widget _buildErrorWidget(BuildContext context, Object error, StackTrace? stackTrace) {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.error_outline, color: Colors.grey),
      ),
    );
  }
}