import 'dart:async';
import 'package:flutter/material.dart';

/// ويدجت احترافي لمنع النقر المزدوج (Double Click)
/// يضمن تنفيذ العملية مرة واحدة فقط حتى لو ضغط المستخدم بسرعة
class SafeClickBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, bool isLoading, VoidCallback onTap) builder;
  final Future<void> Function() onTap;

  const SafeClickBuilder({
    super.key,
    required this.onTap,
    required this.builder,
  });

  @override
  State<SafeClickBuilder> createState() => _SafeClickBuilderState();
}

class _SafeClickBuilderState extends State<SafeClickBuilder> {
  bool _isLoading = false;

  Future<void> _handleTap() async {
    if (_isLoading) return; // منع النقر إذا كانت العملية جارية

    if (mounted) setState(() => _isLoading = true);

    try {
      await widget.onTap();
    } catch (e) {
      debugPrint("SafeClickBuilder Error: $e");
    } finally {
      // ننتظر قليلاً قبل السماح بالنقر مرة أخرى لضمان ثبات الواجهة
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _isLoading, // يمنع أي تفاعل مع العناصر الداخلية أثناء التحميل
      child: widget.builder(context, _isLoading, _handleTap),
    );
  }
}
