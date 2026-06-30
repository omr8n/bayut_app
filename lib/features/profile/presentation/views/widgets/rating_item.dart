import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/profile/domain/entities/rating_entity.dart';

class RatingItem extends StatelessWidget {
  final RatingEntity rating;

  const RatingItem({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('yyyy/MM/dd').format(rating.createdAt),
                style: TextStyle(color: isDark ? AppColors.textSecondaryDark : Colors.grey, fontSize: 11),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < rating.rating
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: AppColors.primary,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: isDark ? AppColors.primary.withOpacity(0.2) : Colors.grey.shade200,
                backgroundImage: rating.raterImage != null
                    ? NetworkImage(rating.raterImage!)
                    : null,
                child: rating.raterImage == null
                    ? Icon(Icons.person, size: 20, color: isDark ? Colors.white : Colors.grey)
                    : null,
              ),
              const SizedBox(width: 10),
              Text(
                rating.raterName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          if (rating.comment.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              rating.comment,
              textAlign: locale.isEnLocale ? TextAlign.left : TextAlign.right,
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black87,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
