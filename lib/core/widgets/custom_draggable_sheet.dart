import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDraggableSheet extends StatefulWidget {
  final List<Widget> children;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final DraggableScrollableController? controller;

  const CustomDraggableSheet({
    super.key,
    required this.children,
    this.initialChildSize = 0.4,
    this.minChildSize = 0.4,
    this.maxChildSize = 0.9,
    this.borderRadius,
    this.padding,
    this.backgroundColor,
    this.controller,
  });

  @override
  State<CustomDraggableSheet> createState() => _CustomDraggableSheetState();
}

class _CustomDraggableSheetState extends State<CustomDraggableSheet> {
  late DraggableScrollableController _sheetController;
  late ValueNotifier<double> _sheetSizeNotifier;

  @override
  void initState() {
    super.initState();
    _sheetController = widget.controller ?? DraggableScrollableController();
    _sheetSizeNotifier = ValueNotifier<double>(widget.initialChildSize);

    _sheetController.addListener(_handleSizeChange);
  }

  void _handleSizeChange() {
    if (_sheetController.isAttached) {
      _sheetSizeNotifier.value = _sheetController.size;
    }
  }

  @override
  void didUpdateWidget(CustomDraggableSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleSizeChange);
      _sheetController = widget.controller ?? DraggableScrollableController();
      _sheetController.addListener(_handleSizeChange);
    }
  }

  @override
  void dispose() {
    _sheetController.removeListener(_handleSizeChange);
    if (widget.controller == null) {
      _sheetController.dispose();
    }
    _sheetSizeNotifier.dispose();
    super.dispose();
  }

  void _toggleSheet() {
    if (!_sheetController.isAttached) return;
    final double threshold = (widget.maxChildSize + widget.minChildSize) / 2;
    final double targetSize = _sheetController.size < threshold
        ? widget.maxChildSize
        : widget.minChildSize;
    _sheetController.animateTo(
      targetSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: widget.initialChildSize,
      minChildSize: widget.minChildSize,
      maxChildSize: widget.maxChildSize,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Theme.of(context).cardColor,
            borderRadius:
                widget.borderRadius ??
                BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: Theme.of(context).brightness == Brightness.dark
                      ? 0.3
                      : 0.1,
                ),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: _SheetHandle(
                  sizeNotifier: _sheetSizeNotifier,
                  onTap: _toggleSheet,
                  threshold: (widget.maxChildSize + widget.minChildSize) / 2,
                ),
              ),
              SliverPadding(
                padding: widget.padding ?? EdgeInsets.zero,
                sliver: SliverList(
                  delegate: SliverChildListDelegate(widget.children),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SheetHandle extends StatelessWidget {
  final ValueNotifier<double> sizeNotifier;
  final VoidCallback onTap;
  final double threshold;

  const _SheetHandle({
    required this.sizeNotifier,
    required this.onTap,
    required this.threshold,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        color: Colors.transparent,
        child: Center(
          child: Column(
            children: [
              ValueListenableBuilder<double>(
                valueListenable: sizeNotifier,
                builder: (context, size, _) {
                  return Icon(
                    size > threshold
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_up_rounded,
                    color: Colors.grey.shade400,
                    size: 32.sp,
                  );
                },
              ),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
