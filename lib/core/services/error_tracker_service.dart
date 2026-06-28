import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';

/// Service responsible for tracking errors and logging information throughout the application.
/// This acts as a wrapper that can be easily extended to support Sentry, Firebase Crashlytics, etc.
class ErrorTrackerService {
  /// Logs an error with an optional stack trace and message.
  static void logError(dynamic error, {StackTrace? stackTrace, String? message}) {
    final String errorMessage = message != null ? '$message: $error' : error.toString();

    // Log to developer console
    dev.log(
      errorMessage,
      name: 'ERROR_TRACKER',
      error: error,
      stackTrace: stackTrace,
    );

    // If in debug mode, also print to console for visibility
    if (kDebugMode) {
      debugPrint('❌ [ErrorTracker] $errorMessage');
      if (stackTrace != null) {
        debugPrint(stackTrace.toString());
      }
    }

    // TODO: Add external tracking service integration here (e.g., Sentry, Crashlytics)
  }

  /// Logs informational messages.
  static void logInfo(String message) {
    dev.log(message, name: 'INFO_TRACKER');

    if (kDebugMode) {
      debugPrint('ℹ️ [InfoTracker] $message');
    }
  }
}
