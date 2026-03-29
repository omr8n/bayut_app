import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/features/profile/presentation/manager/rating_cubit/rating_cubit.dart';
import 'package:test_graduation/features/profile/presentation/manager/rating_cubit/rating_state.dart';

class AddRatingDialog extends StatefulWidget {
  final String sellerId; // 🔥 التأكد من وجود هذا الحقل

  const AddRatingDialog({super.key, required this.sellerId});

  @override
  State<AddRatingDialog> createState() => _AddRatingDialogState();
}

class _AddRatingDialogState extends State<AddRatingDialog> {
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<RatingCubit>(),
      child: BlocConsumer<RatingCubit, RatingState>(
        listener: (context, state) {
          if (state is RatingSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم إرسال تقييمك بنجاح! ✅'), backgroundColor: AppColors.success),
            );
            Navigator.pop(context);
          } else if (state is RatingFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Center(
                      child: Text('تقييم تجربة المعلن', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const Divider(height: 32),
                    const Text(':التقييم العام', style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => IconButton(
                          onPressed: () => setState(() => _rating = index + 1),
                          icon: Icon(
                            index < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                            color: index < _rating ? Colors.amber : Colors.grey.shade300,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(':اكتب رأيك (اختياري)', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _commentController,
                      maxLines: 3,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'مثلاً: المعلن صادق والبيانات دقيقة...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: (state is RatingLoading || _rating == 0)
                                ? null
                                : () {
                                    context.read<RatingCubit>().addRating(
                                          sellerId: widget.sellerId,
                                          rating: _rating.toDouble(),
                                          comment: _commentController.text.trim(),
                                        );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: state is RatingLoading
                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Text('إرسال التقييم', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
