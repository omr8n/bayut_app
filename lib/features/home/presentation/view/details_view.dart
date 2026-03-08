import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/utils/strings_ar.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/profile/presentation/views/seller_profile_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final PropertyEntity property;

  const PropertyDetailsScreen({super.key, required this.property});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  int _currentMediaIndex = 0;
  bool _isFavorite = false;

  // مشغل الفيديو
  VideoPlayerController? _videoPlayerController;

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  void _initializeVideo(String url) {
    _videoPlayerController?.dispose();
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController?.play();
      });
  }

  bool _isVideo(String url) {
    final path = url.toLowerCase();
    return path.contains('.mp4') ||
        path.contains('.mov') ||
        path.contains('.avi');
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');
    final dateFormat = DateFormat('yyyy/MM/dd');
    final mediaList = widget.property.media.isNotEmpty
        ? widget.property.media
        : widget.property.images;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.black,
            ),
            onPressed: () => setState(() => _isFavorite = !_isFavorite),
          ),
        ],
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildMediaGallery(mediaList),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${numberFormat.format(widget.property.price)} ${widget.property.currency}',
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.property.listingType.arabicName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          _buildTypeBadge(),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.property.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: AppColors.secondary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${widget.property.governorate} - ${widget.property.city}\n${widget.property.location}',
                              style: const TextStyle(
                                fontSize: 15,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildMainDetailsRow(),
                      const SizedBox(height: 24),
                      _buildSectionTitle(AppStrings.description),
                      Text(
                        widget.property.description,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle('المرافق والخدمات'),
                      _buildFacilitiesWrap(),
                      const SizedBox(height: 24),
                      _buildSellerSection(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildContactButtons(),
        ],
      ),
    );
  }

  Widget _buildMediaGallery(List<String> media) {
    return SliverAppBar(
      expandedHeight: 300,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            PageView.builder(
              itemCount: media.length,
              onPageChanged: (i) {
                setState(() => _currentMediaIndex = i);
                if (!_isVideo(media[i])) {
                  _videoPlayerController?.pause();
                }
              },
              itemBuilder: (context, i) {
                if (_isVideo(media[i])) {
                  return _buildVideoPlayer(media[i]);
                }
                return Image.network(media[i], fit: BoxFit.cover);
              },
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  media.length,
                  (i) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentMediaIndex == i
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer(String url) {
    if (_videoPlayerController == null ||
        _videoPlayerController!.dataSource != url) {
      _initializeVideo(url);
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        if (_videoPlayerController != null &&
            _videoPlayerController!.value.isInitialized)
          AspectRatio(
            aspectRatio: _videoPlayerController!.value.aspectRatio,
            child: VideoPlayer(_videoPlayerController!),
          )
        else
          const CircularProgressIndicator(),
        IconButton(
          icon: Icon(
            _videoPlayerController?.value.isPlaying == true
                ? Icons.pause_circle_filled
                : Icons.play_circle_fill,
            color: Colors.white,
            size: 60,
          ),
          onPressed: () => setState(
            () => _videoPlayerController!.value.isPlaying
                ? _videoPlayerController!.pause()
                : _videoPlayerController!.play(),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        widget.property.type.arabicName,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildMainDetailsRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDetailItem(
            Icons.meeting_room_outlined,
            '${widget.property.totalRooms ?? 0}',
            'غرف',
          ),
          _buildDetailItem(
            Icons.bathroom_outlined,
            '${widget.property.bathrooms ?? 0}',
            'حمامات',
          ),
          _buildDetailItem(
            Icons.square_foot,
            '${widget.property.area.toInt()}',
            'م²',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildFacilitiesWrap() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.property.facilities
          .map(
            (f) => Chip(
              label: Text(f, style: const TextStyle(fontSize: 12)),
              avatar: const Icon(
                Icons.check_circle,
                size: 16,
                color: AppColors.success,
              ),
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.grey.shade200),
            ),
          )
          .toList(),
    );
  }

  Widget _buildSellerSection() {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SellerProfileView(property: widget.property),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.property.sellerName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.property.sellerJoinDate,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildContactButtons() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.phone),
                label: const Text('اتصال'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.chat),
                label: const Text('واتساب'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
