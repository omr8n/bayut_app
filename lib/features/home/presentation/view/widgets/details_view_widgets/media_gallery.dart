import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:video_player/video_player.dart';
import 'package:test_graduation/core/routing/app_routes.dart';

class MediaGallery extends StatelessWidget {
  final List<String> mediaUrls;
  final List<String> propertyImages;
  final PropertyEntity property; // 🔥 إضافة العقار

  const MediaGallery({
    super.key, 
    required this.mediaUrls, 
    required this.propertyImages,
    required this.property,
  });

  bool _isVideo(String url) => url.toLowerCase().endsWith('.mp4');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(mediaUrls.length, (index) {
          final url = mediaUrls[index];
          final isVideo = _isVideo(url);

          return GestureDetector(
            onTap: () => context.push(
              AppRoutes.videoView, 
              extra: {
                'urls': mediaUrls, 
                'index': index,
                'property': property, // 🔥 تمرير البيانات هنا
              }
            ),
            child: Container(
              width: double.infinity,
              height: 380.h,
              margin: EdgeInsets.only(bottom: 2.h),
              child: Stack(
                children: [
                  // إذا كان فيديو، نعرض لقطة منه، وإذا كانت صورة نعرضها مباشرة
                  isVideo 
                    ? VideoThumbnailWidget(videoUrl: url)
                    : FancyShimmerImage(
                        imageUrl: url,
                        boxFit: BoxFit.cover,
                        width: double.infinity,
                        height: 380.h,
                      ),
                  
                  if (isVideo)
                    _buildPlayOverlay(),
                ],
              ),
            ),
          );
        }),
        SizedBox(height: 120.h), 
      ],
    );
  }

  Widget _buildPlayOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.15),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.black45,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.8), width: 2),
          ),
          child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 50.sp),
        ),
      ),
    );
  }
}

// 🔥 ويدجت ذكية لاستخراج صورة من الفيديو وعرضها كمعاينة
class VideoThumbnailWidget extends StatefulWidget {
  final String videoUrl;
  const VideoThumbnailWidget({super.key, required this.videoUrl});

  @override
  State<VideoThumbnailWidget> createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if (mounted) {
          // الانتقال لثانية واحدة لتجنب الشاشة السوداء في بداية بعض الفيديوهات
          _controller.seekTo(const Duration(seconds: 1));
          setState(() => _isInitialized = true);
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Container(
        color: Colors.grey.shade200,
        child: const Center(child: CircularProgressIndicator(color: Colors.green, strokeWidth: 2)),
      );
    }
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}
