import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/utils/strings_ar.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/profile/presentation/views/seller_profile_view.dart';
import 'package:video_player/video_player.dart';

// 🔥 الكبسولة المعزولة لإدارة الفيديو بأمان ومنع الـ Bad State
class VideoPlayerItem extends StatefulWidget {
  final String url;
  const VideoPlayerItem({super.key, required this.url});

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() {
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
    );
    _videoPlayerController.initialize().then((_) {
      if (mounted) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController,
            autoPlay: true,
            looping: true,
            allowFullScreen: true,
            aspectRatio: _videoPlayerController.value.aspectRatio,
            placeholder: Container(
              color: Colors.black,
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorBuilder: (context, errorMessage) => Center(
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _chewieController != null &&
            _chewieController!.videoPlayerController.value.isInitialized
        ? Chewie(controller: _chewieController!)
        : Container(
            color: Colors.black,
            child: const Center(child: CircularProgressIndicator()),
          );
  }
}

class PropertyDetailsScreen extends StatefulWidget {
  final PropertyEntity property;
  const PropertyDetailsScreen({super.key, required this.property});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  int _currentMediaIndex = 0;
  bool _isFavorite = false;

  bool _isVideo(String url) => url.toLowerCase().endsWith('.mp4');

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');
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
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(numberFormat),
                      const SizedBox(height: 20),
                      Text(
                        widget.property.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildLocation(),
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

                      if (widget.property.facilities.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        _buildSectionTitle('المرافق والخدمات'),
                        _buildFacilitiesWrap(),
                      ],

                      _buildTypeSpecificDetails(),

                      const SizedBox(height: 24),
                      _buildSellerSection(),
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
      pinned: false,
      backgroundColor: Colors.black,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.center,
          children: [
            PageView.builder(
              itemCount: media.length,
              onPageChanged: (i) => setState(() => _currentMediaIndex = i),
              itemBuilder: (context, i) {
                if (_isVideo(media[i])) {
                  return VideoPlayerItem(url: media[i]);
                }
                return Image.network(
                  media[i],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.broken_image, color: Colors.grey),
                  ),
                );
              },
            ),
            Positioned(
              bottom: 16,
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
                          : Colors.white.withOpacity(0.5),
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

  Widget _buildHeader(NumberFormat format) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${format.format(widget.property.price)} ${widget.property.currency}',
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
    );
  }

  Widget _buildLocation() {
    return Row(
      children: [
        const Icon(Icons.location_on, color: AppColors.secondary, size: 20),
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

  Widget _buildTypeSpecificDetails() {
    final p = widget.property;
    final List<Map<String, String>> specs = [];
    if (p.buildingAge != null) {
      specs.add({'عمر البناء': '${p.buildingAge} سنوات'});
    }
    if (p.finishType != null) specs.add({'الكسوة': p.finishType!});
    switch (p.type) {
      case PropertyType.housesAndApartments:
      case PropertyType.villas:
        if (p.floorNumber != null) specs.add({'الطابق': '${p.floorNumber}'});
        if (p.heatingType != null) specs.add({'التدفئة': p.heatingType!});
        break;
      default:
        break;
    }
    if (specs.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        _buildSectionTitle('المواصفات الفنية'),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3.5,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: specs.length,
          itemBuilder: (context, index) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  '${specs[index].keys.first}: ',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Expanded(
                  child: Text(
                    specs[index].values.first,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
                const Text(
                  'عضو موثق',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
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

  Widget _buildTypeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
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
