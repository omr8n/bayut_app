import 'package:flutter/material.dart';
import 'package:test_graduation/core/widgets/custom_text_form_field.dart';

class ContactCard extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController whatsappController;

  const ContactCard({
    super.key,
    required this.phoneController,
    required this.whatsappController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextFormField(
              controller: phoneController,
              textAlign: TextAlign.right,
              labelText: 'رقم الهاتف للاتصال',
              hintText: '09xxxxxxxx',
              prefixIcon: Icons.phone_callback_outlined,
              prefixText: '+963 ',
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال رقم الهاتف';
                }
                if (!RegExp(r'^[3-9]\d{7}$').hasMatch(value)) {
                  return 'يرجى إدخال رقم سوري صحيح';
                }
                return null;
              },
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 16),
              child: Text(
                'تذكر إضافة رمز الدولة (مثلاً +963 لسوريا)',
                style: TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.chat_outlined, color: Colors.green),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'رقم واتساب',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'رقم واتساب إذا كان مختلف أو انسخ رقم ال...',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.copy, color: Colors.blue, size: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
