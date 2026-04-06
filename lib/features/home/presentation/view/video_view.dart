import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/widgets/communication.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:video_player/video_player.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideoView extends StatefulWidget {
  final List<String> videoUrls;
  final int initialIndex;
  final String? heroTag;
  final PropertyEntity? property; // 🔥 إضافة بيانات العقار

  const VideoView({
    super.key,
    required this.videoUrls,
    this.initialIndex = 0,
    this.heroTag,
    this.property,
  });

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late PageController _pageController;
  late int _currentIndex;
  final Map<int, VideoPlayerController> _controllers = {};
  bool _isShowingImages = true;
  bool _showControls = true;

  bool _isVideo(String url) => url.toLowerCase().endsWith('.mp4');

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _isShowingImages = !_isVideo(widget.videoUrls[_currentIndex]);

    if (_isVideo(widget.videoUrls[_currentIndex])) {
      _initializeController(_currentIndex);
    }
  }

  void _initializeController(int index) {
    if (_isVideo(widget.videoUrls[index]) && !_controllers.containsKey(index)) {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrls[index]),
      );
      _controllers[index] = controller;
      controller.initialize().then((_) {
        if (mounted && _currentIndex == index) {
          setState(() {});
          controller.play();
          controller.setLooping(true);
        }
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. الميديا (خلف كل شيء)
          GestureDetector(
            onTap: () => setState(() => _showControls = !_showControls),
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.videoUrls.length,
              onPageChanged: (index) {
                if (_controllers.containsKey(_currentIndex))
                  _controllers[_currentIndex]!.pause();
                setState(() {
                  _currentIndex = index;
                  _isShowingImages = !_isVideo(widget.videoUrls[index]);
                });
                if (_isVideo(widget.videoUrls[index]))
                  _initializeController(index);
              },
              itemBuilder: (context, index) {
                final url = widget.videoUrls[index];
                return _isVideo(url)
                    ? _buildVideoPlayer(index)
                    : _buildImageViewer(url, index);
              },
            ),
          ),

          // 2. الواجهة العلوية (Header)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildAnimatedOverlay(
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _circleIconButton(
                        Icons.close,
                        () => Navigator.pop(context),
                      ),
                      _buildTopToggle(),
                      _buildCounter(),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 3. أزرار التواصل (Bottom) بأسلوب Hero للاستمرارية البصرية
          // Positioned(
          //   bottom: 30.h,
          //   left: 20.w,
          //   right: 20.w,
          //   child: _buildAnimatedOverlay(
          //     child: Hero(
          //       tag: 'contact_buttons_${widget.property?.id}', // 🔥 التاج السحري المشترك
          //       child: Material(
          //         color: Colors.transparent, // للحفاظ على خلفية الـ Row المخصصة
          //         child: _buildContactRow(),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildAnimatedOverlay({required Widget child}) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _showControls ? 1.0 : 0.0,
      child: IgnorePointer(ignoring: !_showControls, child: child),
    );
  }

  Widget _buildImageViewer(String url, int index) {
    return InteractiveViewer(
      clipBehavior: Clip.none,
      minScale: 1.0,
      maxScale: 4.0,
      onInteractionStart: (_) => setState(() => _showControls = false),
      onInteractionEnd: (_) => setState(() => _showControls = true),
      child: SizedBox.expand(
        // 🔥 جعل الصورة تملأ كامل المساحة المتاحة
        child: Center(
          child: Hero(
            tag: (index == widget.initialIndex && widget.heroTag != null)
                ? widget.heroTag!
                : 'gallery_item_$index',
            child: FancyShimmerImage(
              imageUrl: url,
              boxFit: BoxFit
                  .contain, // يحافظ على أبعاد الصورة مع تكبيرها لأقصى حد ممكن
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoPlayer(int index) {
    final controller = _controllers[index];
    if (controller == null || !controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.green),
      );
    }
    return InteractiveViewer(
      minScale: 1.0,
      maxScale: 3.0,
      onInteractionStart: (_) => setState(() => _showControls = false),
      onInteractionEnd: (_) => setState(() => _showControls = true),
      child: Center(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              VideoPlayer(controller),
              if (_showControls)
                Center(
                  child: IconButton(
                    icon: Icon(
                      controller.value.isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      color: Colors.white70,
                      size: 65.sp,
                    ),
                    onPressed: () {
                      // 🔥 الإصلاح: تنفيذ الأوامر أولاً ثم تحديث الحالة بشكل متزامن
                      if (controller.value.isPlaying) {
                        controller.pause();
                      } else {
                        controller.play();
                      }
                      setState(() {}); // تحديث الواجهة فقط لتغيير الأيقونة
                    },
                  ),
                ),
              VideoProgressIndicator(
                controller,
                allowScrubbing: true,
                colors: const VideoProgressColors(
                  playedColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopToggle() {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _toggleItem('الصور', _isShowingImages, () {
            int firstImg = widget.videoUrls.indexWhere((u) => !_isVideo(u));
            if (firstImg != -1)
              _pageController.animateToPage(
                firstImg,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
          }),
          _toggleItem('الفيديو', !_isShowingImages, () {
            int firstVid = widget.videoUrls.indexWhere((u) => _isVideo(u));
            if (firstVid != -1)
              _pageController.animateToPage(
                firstVid,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
          }),
        ],
      ),
    );
  }

  Widget _toggleItem(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCounter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Text(
        '${_currentIndex + 1} / ${widget.videoUrls.length}',
        style: TextStyle(color: Colors.white, fontSize: 12.sp),
      ),
    );
  }

  Widget _circleIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: const BoxDecoration(
          color: Colors.black45,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20.sp),
      ),
    );
  }

  // Widget _buildContactRow() {
  //   // إذا لم تتوفر بيانات العقار، لا نعرض أزرار التواصل
  //   if (widget.property == null) return const SizedBox.shrink();

  //   return Container(
  //     padding: EdgeInsets.all(12.w),
  //     decoration: BoxDecoration(
  //       color: Colors.white, // أبيض ناصع كما في الصورة الأصلية لبيوت
  //       borderRadius: BorderRadius.circular(16.r), // زوايا منحنية فخمة
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.3),
  //           blurRadius: 20,
  //           offset: const Offset(0, 10),
  //         ),
  //       ],
  //     ),
  //     child: CommunicationButtons(property: widget.property!),
  //   );
  // }
}
