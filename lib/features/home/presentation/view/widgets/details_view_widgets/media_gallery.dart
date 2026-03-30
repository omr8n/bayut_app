import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'video_player_item.dart';

class MediaGallery extends StatefulWidget {
  final List<String> media;
  const MediaGallery({super.key, required this.media});

  @override
  State<MediaGallery> createState() => _MediaGalleryState();
}

class _MediaGalleryState extends State<MediaGallery> {
  int _currentMediaIndex = 0;

  bool _isVideo(String url) => url.toLowerCase().endsWith('.mp4');

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: false,
      backgroundColor: Colors.black,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.center,
          children: [
            PageView.builder(
              itemCount: widget.media.length,
              onPageChanged: (i) => setState(() => _currentMediaIndex = i),
              itemBuilder: (context, i) {
                if (_isVideo(widget.media[i])) {
                  return VideoPlayerItem(url: widget.media[i]);
                }
                return FancyShimmerImage(
                  imageUrl: widget.media[i],
                  boxFit: BoxFit.cover,
                );
              },
            ),
            Positioned(
              bottom: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.media.length,
                  (i) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentMediaIndex == i ? Colors.white : Colors.white.withOpacity(0.5),
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
}
