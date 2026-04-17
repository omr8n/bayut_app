import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideoPlayerItem extends StatefulWidget {
  final String url;
  const VideoPlayerItem({super.key, required this.url});

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    
    try {
      await _videoPlayerController.initialize();
      if (mounted) {
        setState(() {
          _hasError = false;
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController,
            autoPlay: true,
            looping: true,
            allowFullScreen: true,
            aspectRatio: _videoPlayerController.value.aspectRatio,
            placeholder: Container(
              color: Colors.black,
              child: const Center(child: CircularProgressIndicator(color: Colors.white)),
            ),
            errorBuilder: (context, errorMessage) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.white, size: 40.sp),
                    SizedBox(height: 10.h),
                    Text(
                      AppLocalizations.of(context)!.translate(LangKeys.videoPlayFailed),
                      style: const TextStyle(color: Colors.white, fontFamily: 'Dubai'),
                    ),
                  ],
                ),
              );
            },
          );
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, color: Colors.white, size: 40.sp),
              SizedBox(height: 10.h),
              Text(
                AppLocalizations.of(context)!.translate(LangKeys.videoLoadFailed),
                style: const TextStyle(color: Colors.white, fontFamily: 'Dubai'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _hasError = false;
                  });
                  _initialize();
                },
                child: Text(
                  AppLocalizations.of(context)!.translate(LangKeys.retry),
                  style: const TextStyle(color: Colors.blue),
                ),
              )
            ],
          ),
        ),
      );
    }

    return _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
        ? Chewie(controller: _chewieController!)
        : Container(
            color: Colors.black,
            child: const Center(child: CircularProgressIndicator(color: Colors.white)),
          );
  }
}
