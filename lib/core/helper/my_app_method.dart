import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/app_images.dart';

// import '../widgets/subtitle_text.dart';
// import '../widgets/title_text.dart';

class MyAppMethods {
  static Future<void> showErrorORWarningDialog({
    required BuildContext context,
    required String subtitle,
    required VoidCallback fct,
    bool isError = true,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(Assets.imagesWarning, height: 60, width: 60),
              const SizedBox(height: 16.0),
              Text(subtitle, style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: !isError,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      fct();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "OK",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> imagePickerDialog({
    required BuildContext context,
    required VoidCallback cameraFCT,
    required VoidCallback galleryFCT,
    required VoidCallback removeFCT,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text("Choose option")),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextButton.icon(
                  onPressed: () {
                    cameraFCT();
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.camera),
                  label: const Text("Camera"),
                ),
                TextButton.icon(
                  onPressed: () {
                    galleryFCT();
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.image),
                  label: const Text("Gallery"),
                ),
                TextButton.icon(
                  onPressed: () {
                    removeFCT();
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.remove),
                  label: const Text("Remove"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:e_commerce_shop_smart/core/utils/app_images.dart';
// import '../widgets/subtitle_text.dart';
// import '../widgets/title_text.dart';

// class MyAppMethods {
//   static Future<void> showErrorOrWarningDialog({
//     required BuildContext context,
//     required String subtitle,
//     required VoidCallback onConfirm,
//     bool isError = true,
//   }) async {
//     await showGeneralDialog(
//       context: context,
//       barrierDismissible: true,
//       barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
//       transitionDuration: const Duration(milliseconds: 300),
//       pageBuilder: (context, animation, secondaryAnimation) {
//         return Center(
//           child: AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12.0),
//             ),
//             backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Image.asset(
//                   Assets.imagesWarning,
//                   height: 60,
//                   width: 60,
//                 ),
//                 const SizedBox(height: 16),
//                 SubtitleTextWidget(
//                   label: subtitle,
//                   fontWeight: FontWeight.w600,
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     if (!isError)
//                       TextButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: const SubtitleTextWidget(
//                           label: "Cancel",
//                           color: Colors.green,
//                         ),
//                       ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         onConfirm();
//                       },
//                       child: const SubtitleTextWidget(
//                         label: "OK",
//                         color: Colors.red,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//       transitionBuilder: (context, animation, secondaryAnimation, child) {
//         return ScaleTransition(
//           scale: animation,
//           child: child,
//         );
//       },
//     );
//   }

//   static Future<void> imagePickerDialog({
//     required BuildContext context,
//     required VoidCallback onCameraPick,
//     required VoidCallback onGalleryPick,
//     required VoidCallback onRemoveImage,
//   }) async {
//     await showDialog(
//       context: context,
//       builder: (context) {
//         final List<Map<String, dynamic>> options = [
//           {
//             'icon': Icons.camera,
//             'label': 'Camera',
//             'onTap': onCameraPick,
//           },
//           {
//             'icon': Icons.image,
//             'label': 'Gallery',
//             'onTap': onGalleryPick,
//           },
//           {
//             'icon': Icons.remove,
//             'label': 'Remove',
//             'onTap': onRemoveImage,
//           },
//         ];

//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12.0),
//           ),
//           title: const Center(
//             child: TitlesTextWidget(label: "Choose Option"),
//           ),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: options.map((option) {
//                 return TextButton.icon(
//                   onPressed: () {
//                     option['onTap']();
//                     if (Navigator.canPop(context)) {
//                       Navigator.pop(context);
//                     }
//                   },
//                   icon: Icon(option['icon']),
//                   label: Text(option['label']),
//                 );
//               }).toList(),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
