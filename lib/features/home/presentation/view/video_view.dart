import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:video_player/video_player.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideoView extends StatefulWidget {
  final List<String> videoUrls;
  final int initialIndex;
  final String? heroTag;
  final PropertyEntity? property;

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
  final Map<int, bool> _errorStates = {}; // 🔥 لتتبع الأخطاء لكل فيديو
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
      
      // 🔥 إضافة catchError لمنع الـ PlatformException
      controller.initialize().then((_) {
        if (mounted && _currentIndex == index) {
          setState(() {
            _errorStates[index] = false;
          });
          controller.play();
          controller.setLooping(true);
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            _errorStates[index] = true;
          });
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
          GestureDetector(
            onTap: () => setState(() => _showControls = !_showControls),
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.videoUrls.length,
              onPageChanged: (index) {
                if (_controllers.containsKey(_currentIndex)) {
                  _controllers[_currentIndex]!.pause();
                }
                setState(() {
                  _currentIndex = index;
                  _isShowingImages = !_isVideo(widget.videoUrls[index]);
                });
                if (_isVideo(widget.videoUrls[index])) {
                  _initializeController(index);
                }
              },
              itemBuilder: (context, index) {
                final url = widget.videoUrls[index];
                return _isVideo(url)
                    ? _buildVideoPlayer(index)
                    : _buildImageViewer(url, index);
              },
            ),
          ),

          // Header
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
        child: Center(
          child: Hero(
            tag: (index == widget.initialIndex && widget.heroTag != null)
                ? widget.heroTag!
                : 'gallery_item_$index',
            child: FancyShimmerImage(
              imageUrl: url,
              boxFit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoPlayer(int index) {
    // 🔥 التحقق من حالة الخطأ أولاً
    if (_errorStates[index] == true) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, color: Colors.white70, size: 50.sp),
            SizedBox(height: 10.h),
            const Text(
              'تعذر تحميل الفيديو، تأكد من الاتصال',
              style: TextStyle(color: Colors.white, fontFamily: 'Dubai'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _errorStates.remove(index);
                  _controllers.remove(index)?.dispose();
                });
                _initializeController(index);
              },
              child: const Text('إعادة المحاولة', style: TextStyle(color: AppColors.primary)),
            )
          ],
        ),
      );
    }

    final controller = _controllers[index];
    if (controller == null || !controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
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
                      setState(() {
                        controller.value.isPlaying ? controller.pause() : controller.play();
                      });
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
            if (firstImg != -1) {
              _pageController.animateToPage(
                firstImg,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            }
          }),
          _toggleItem('الفيديو', !_isShowingImages, () {
            int firstVid = widget.videoUrls.indexWhere((u) => _isVideo(u));
            if (firstVid != -1) {
              _pageController.animateToPage(
                firstVid,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            }
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
}
