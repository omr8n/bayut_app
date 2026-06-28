import 'dart:async';
import 'package:flutter/material.dart';
import 'package:test_graduation/core/services/listing_limit_service.dart';
import 'package:test_graduation/features/auth/domain/entites/user_entity.dart';

class ListingLimitViewModel extends ChangeNotifier {
  final ListingLimitService _limitService = ListingLimitService();

  Timer? _timer;
  Duration _remainingTime = Duration.zero;
  bool _canListFree = true;
  int _remainingListings = 0;

  Duration get remainingTime => _remainingTime;
  bool get canListFree => _canListFree;
  int get remainingListings => _remainingListings;

  String get formattedRemainingTime {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(_remainingTime.inHours);
    final minutes = twoDigits(_remainingTime.inMinutes.remainder(60));
    final seconds = twoDigits(_remainingTime.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  Future<void> checkLimits(UserEntity user) async {
    final result = await _limitService.checkListingLimit(user);
    _canListFree = result['canListFree'];
    _remainingListings = result['remaining'];

    if (!_canListFree && result['nextFreeTime'] != null) {
      _remainingTime = result['nextFreeTime'];
      _startTimer();
    }
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        _remainingTime -= const Duration(seconds: 1);
        notifyListeners();
      } else {
        _timer?.cancel();
        _canListFree = true;
        _remainingListings = 3;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
