import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/colors.dart';

class BuildCounterRow extends StatelessWidget {
  const BuildCounterRow({
    super.key,
    required this.title,
    this.value,
    required this.onSelect,
  });
  final String title;
  final int? value;
  final Function(int?) onSelect;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [0, 1, 2, 3, 4, 5].map((i) {
            bool isSelected = (value == i) || (i == 0 && value == null);
            String label = i == 0 ? 'الكل' : (i == 5 ? '+5' : '$i');
            return Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: InkWell(
                  onTap: () => onSelect(i == 0 ? null : i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        label,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
