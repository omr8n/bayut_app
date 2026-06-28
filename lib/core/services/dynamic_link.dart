import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class DynamicLinkService {
  factory DynamicLinkService() => _instance;
  DynamicLinkService._();
  static final DynamicLinkService _instance = DynamicLinkService._();

  Future<String> generatePropertyLink({
    required String propertyId,
    required String title,
    String? imageUrl,
  }) async {
    final dynamicLinkParams = DynamicLinkParameters(
      socialMetaTagParameters: SocialMetaTagParameters(
        imageUrl: imageUrl != null ? Uri.parse(imageUrl) : null,
        description: 'Check out this property on Syrian Home',
        title: title,
      ),
      uriPrefix: 'https://syrianhome.page.link',
      link: Uri.parse('https://syrianhome.com/property/$propertyId'),
      androidParameters: const AndroidParameters(
        packageName: 'com.syrian.home', // Update with actual package name
        minimumVersion: 1,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.syrian.home', // Update with actual bundle ID
        minimumVersion: '1',
      ),
    );

    try {
      final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
      return dynamicLink.shortUrl.toString();
    } catch (e) {
      debugPrint('Error generating Dynamic Link: $e');
      return 'https://syrianhome.com/property/$propertyId';
    }
  }

  // Initialization logic can be added here if needed to handle deep links on app start
}
