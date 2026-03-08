import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSection extends StatefulWidget {
  final List<XFile> mediaFiles;
  final VoidCallback onAddMedia; // كبسة واحدة للصور والفيديو
  final Function(int) onRemoveMedia;

  const ImageSection({
    super.key,
    required this.mediaFiles,
    required this.onAddMedia,
    required this.onRemoveMedia,
  });

  @override
  State<ImageSection> createState() => _ImageSectionState();
}

class _ImageSectionState extends State<ImageSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الوسائط (صور وفيديو)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Text(
          'يمكنك اختيار الصور والفيديوهات معاً',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            reverse: true, // لتتناسب مع اللغة العربية
            itemCount: widget.mediaFiles.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildAddButton();
              }
              final file = widget.mediaFiles[index - 1];
              bool isVideo =
                  file.path.toLowerCase().endsWith('.mp4') ||
                  file.path.toLowerCase().endsWith('.mov') ||
                  file.path.toLowerCase().endsWith('.avi');
              return _buildMediaThumbnail(file, isVideo, index - 1);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: widget.onAddMedia,
      child: Container(
        width: 100,
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade300,
            style: BorderStyle.solid,
            width: 1.5,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              color: Colors.blue,
              size: 32,
            ),
            SizedBox(height: 4),
            Text(
              'إضافة وسائط',
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaThumbnail(XFile file, bool isVideo, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 100,
      height: 100,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: isVideo
                ? Container(
                    color: Colors.black87,
                    child: const Center(
                      child: Icon(
                        Icons.movie_outlined,
                        color: Colors.white30,
                        size: 40,
                      ),
                    ),
                  )
                : Image.file(
                    File(file.path),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
          ),
          if (isVideo)
            const Center(
              child: Icon(
                Icons.play_circle_fill,
                color: Colors.white,
                size: 35,
              ),
            ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => widget.onRemoveMedia(index),
              child: const CircleAvatar(
                radius: 10,
                backgroundColor: Colors.red,
                child: Icon(Icons.close, color: Colors.white, size: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
