import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/language/app_localizations.dart';
import '../../../../../core/language/lang_keys.dart';

class ImageSection extends StatefulWidget {
  final List<XFile> mediaFiles;
  final List<String>? existingMedia; // 🔥 الروابط القديمة من السيرفر
  final VoidCallback onAddMedia;
  final Function(int) onRemoveMedia;
  final Function(int)? onRemoveExistingMedia; // 🔥 دالة لحذف الصور القديمة

  const ImageSection({
    super.key,
    required this.mediaFiles,
    this.existingMedia,
    required this.onAddMedia,
    required this.onRemoveMedia,
    this.onRemoveExistingMedia,
  });

  @override
  State<ImageSection> createState() => _ImageSectionState();
}

class _ImageSectionState extends State<ImageSection> {
  @override
  Widget build(BuildContext context) {
    final int existingCount = widget.existingMedia?.length ?? 0;
    final locale = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.translate(LangKeys.mediaTitle),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          locale.translate(LangKeys.mediaSubtitle),
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            // عدد العناصر = زر الإضافة + الصور القديمة + الصور الجديدة
            itemCount: existingCount + widget.mediaFiles.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) return _buildAddButton(context);

              // عرض الصور القديمة (من السيرفر)
              if (index <= existingCount) {
                final imageUrl = widget.existingMedia![index - 1];
                return _buildNetworkThumbnail(imageUrl, index - 1);
              }

              // عرض الصور الجديدة (من الهاتف)
              final fileIndex = index - existingCount - 1;
              final file = widget.mediaFiles[fileIndex];
              bool isVideo = file.path.toLowerCase().endsWith('.mp4') ||
                  file.path.toLowerCase().endsWith('.mov');
              return _buildMediaThumbnail(file, isVideo, fileIndex);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: widget.onAddMedia,
      child: Container(
        width: 100,
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_photo_alternate_outlined,
              color: Colors.blue,
              size: 32,
            ),
            const SizedBox(height: 4),
            Text(
              locale.translate(LangKeys.addMedia),
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 ويدجت لعرض الصور القادمة من السيرفر
  Widget _buildNetworkThumbnail(String url, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 100, height: 100,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(url, width: 100, height: 100, fit: BoxFit.cover,
              errorBuilder: (_,__,___) => Container(color: Colors.grey.shade200, child: const Icon(Icons.broken_image)),
            ),
          ),
          Positioned(
            top: 4, right: 4,
            child: GestureDetector(
              onTap: () => widget.onRemoveExistingMedia?.call(index),
              child: const CircleAvatar(
                radius: 10, backgroundColor: Colors.red,
                child: Icon(Icons.close, color: Colors.white, size: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaThumbnail(XFile file, bool isVideo, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 100, height: 100,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: isVideo
                ? Container(color: Colors.black87, child: const Icon(Icons.movie_outlined, color: Colors.white30, size: 40))
                : Image.file(File(file.path), width: 100, height: 100, fit: BoxFit.cover),
          ),
          if (isVideo) const Center(child: Icon(Icons.play_circle_fill, color: Colors.white, size: 35)),
          Positioned(
            top: 4, right: 4,
            child: GestureDetector(
              onTap: () => widget.onRemoveMedia(index),
              child: const CircleAvatar(
                radius: 10, backgroundColor: Colors.red,
                child: Icon(Icons.close, color: Colors.white, size: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
