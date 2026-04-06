import 'package:flutter/foundation.dart';

class ViewedPropertiesManager {
  static final ViewedPropertiesManager _instance = ViewedPropertiesManager._internal();
  factory ViewedPropertiesManager() => _instance;
  ViewedPropertiesManager._internal();

  final Set<String> _viewedPropertyIds = {};
  final ValueNotifier<int> changeNotifier = ValueNotifier<int>(0);

  void markAsViewed(String id) {
    if (!_viewedPropertyIds.contains(id)) {
      _viewedPropertyIds.add(id);
      // تأجيل التحديث لتجنب خطأ "setState() during build"
      Future.microtask(() {
        changeNotifier.value++;
      });
    }
  }

  bool isViewed(String id) {
    return _viewedPropertyIds.contains(id);
  }
}
