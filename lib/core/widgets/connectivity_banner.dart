import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/services/connectivity_service.dart';
import 'package:test_graduation/core/utils/service_locator.dart';

class ConnectivityBanner extends StatefulWidget {
  final Widget child;
  const ConnectivityBanner({super.key, required this.child});

  @override
  State<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends State<ConnectivityBanner>
    with SingleTickerProviderStateMixin {
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isConnected = true;
  bool _wasOffline = false;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _checkInitialConnectivity();

    _subscription = getIt<ConnectivityService>().connectivityStream.listen((
      results,
    ) {
      _updateStatus(results);
    });
  }

  Future<void> _checkInitialConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    _updateStatus(result);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final connected =
        !results.contains(ConnectivityResult.none) && results.isNotEmpty;

    if (mounted) {
      setState(() {
        if (!connected) {
          _wasOffline = true;
          _controller.forward();
        } else {
          if (_wasOffline) {
            // تظهر رسالة "تم استعادة الاتصال" باللون الأخضر لفترة بسيطة ثم تختفي
            _showBackOnline();
          }
          _controller.reverse();
        }
        _isConnected = connected;
      });
    }
  }

  void _showBackOnline() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.wifi, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              AppLocalizations.of(
                context,
              )!.translate(LangKeys.connectionRestored),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
    _wasOffline = false;
  }

  @override
  void dispose() {
    _subscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          widget.child,
          SlideTransition(
            position: _offsetAnimation,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: double.infinity,
                color: const Color(0xFFD32F2F),
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 5.h,
                  bottom: 8.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off, color: Colors.white, size: 18.sp),
                    SizedBox(width: 10.w),
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.translate(LangKeys.noInternet),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Dubai',
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
