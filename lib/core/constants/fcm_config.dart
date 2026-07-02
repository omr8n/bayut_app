import 'package:flutter_dotenv/flutter_dotenv.dart';

class FCMConfig {
  // 🔥 تنبيه هام: يجب وضع بيانات الـ Service Account هنا
  // يمكنك الحصول عليها من Firebase Console -> Project Settings -> Service Accounts -> Generate new private key
  static const Map<String, dynamic> serviceAccount = {
    "type": "service_account",
    "project_id": "real-estate-541c5",
    // الصق بقية محتويات ملف الـ JSON هنا (client_email, private_key, etc.)
  };

  static String get fcmV1Url => dotenv.get('FCM_V1_URL', fallback: '');
}
