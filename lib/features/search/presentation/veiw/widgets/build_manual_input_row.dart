import 'package:flutter/material.dart';

class BuildManualInputRow extends StatelessWidget {
  const BuildManualInputRow({
    super.key,
    required this.min,
    required this.max,
    required this.onManualChange,
    required this.maxLimit,
    required this.isPrice,
    this.onChangedMain,
    this.onChangedMax,
  });
  final TextEditingController min, max;

  final Function(double, double) onManualChange;
  final double maxLimit;
  final bool isPrice;
  final void Function(String)? onChangedMain, onChangedMax;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: min,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'من',
              border: OutlineInputBorder(),
            ),
            onChanged: onChangedMain,
            //  double val = double.tryParse(v) ?? 0;
            //   if (val <= (isPrice ? _priceRange.end : _areaRange.end)) {
            //     onManualChange(val, isPrice ? _priceRange.end : _areaRange.end);
            //   }
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('إلى'),
        ),
        Expanded(
          child: TextField(
            controller: max,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'إلى',
              border: OutlineInputBorder(),
            ),
            onChanged: onChangedMax,
            // onChanged: (v) {
            //   double val = double.tryParse(v) ?? maxLimit;
            //   if (val >= (isPrice ? _priceRange.start : _areaRange.start)) {
            //     onManualChange(
            //       isPrice ? _priceRange.start : _areaRange.start,
            //       val,
            //     );
            //   }
            // },
          ),
        ),
      ],
    );
  }
}
