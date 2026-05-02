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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('yyyy/MM/dd').format(rating.createdAt),
                style: const TextStyle(color: Colors.grey, fontSize: 11),
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
                backgroundImage: rating.raterImage != null
                    ? NetworkImage(rating.raterImage!)
                    : null,
                child: rating.raterImage == null
                    ? const Icon(Icons.person, size: 20)
                    : null,
              ),
              const SizedBox(width: 10),
              Text(
                rating.raterName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          if (rating.comment.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              rating.comment,
              textAlign: locale.isEnLocale ? TextAlign.left : TextAlign.right,
              style: const TextStyle(
                color: Colors.black87,
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
