# Localization of Admin Section

This plan outlines the steps to fully localize the Admin section of the application for Arabic and English. This involves extracting all hardcoded strings, updating the localization layer, and refactoring the UI to use translated strings.

## User Review Required

> [!IMPORTANT]
> - All hardcoded Arabic strings in the Admin section will be replaced with localized keys.
> - Extensions for `NotificationType`, `ReportStatus`, and `ReportReason` will be modified to use the current locale.
> - `DateHelpers` will be updated to handle localization dynamically.

## Proposed Changes

### [Core Localization]

#### [lang_keys.dart](file:///D:/test_graduation/lib/core/language/lang_keys.dart)

- Add a comprehensive list of keys for the Admin section, prefixed with `admin_`.

#### [ar.json](file:///D:/test_graduation/lang/ar.json)

- Add Arabic translations for all new keys.

#### [en.json](file:///D:/test_graduation/lang/en.json)

- Add English translations for all new keys.

#### [notification_model.dart](file:///D:/test_graduation/lib/core/models/notification_model.dart)

- Refactor `arabicName` to `getName(BuildContext context)` to support multi-language.

#### [report_entity.dart](file:///D:/test_graduation/lib/features/reports/domain/entities/report_entity.dart)

- Refactor `arabicName` for `ReportStatus` and `ReportReason` to `getName(BuildContext context)`.

#### [date_helpers.dart](file:///D:/test_graduation/lib/core/utils/date_helpers.dart)

- Update `formatArabicDateTime` and `formatArabicDate` to be locale-aware (renaming them to `formatDateTime` and `formatDate`).

---

### [Admin Feature Refactoring]

#### [admin_dashboard_screen.dart](file:///D:/test_graduation/lib/features/admin/presentation/views/admin_dashboard_screen.dart)
#### [admin_settings_screen.dart](file:///D:/test_graduation/lib/features/admin/presentation/views/admin_settings_screen.dart)
#### [admin_users_screen.dart](file:///D:/test_graduation/lib/features/admin/presentation/views/admin_users_screen.dart)
#### [admin_reports_screen.dart](file:///D:/test_graduation/lib/features/admin/presentation/views/admin_reports_screen.dart)
#### [admin_notifications_screen.dart](file:///D:/test_graduation/lib/features/admin/presentation/views/admin_notifications_screen.dart)
#### [admin_analytics_screen.dart](file:///D:/test_graduation/lib/features/admin/presentation/views/admin_analytics_screen.dart)
#### [admin_properties_view.dart](file:///D:/test_graduation/lib/features/admin/presentation/views/admin_properties_view.dart)

- Replace all hardcoded Arabic strings with `AppLocalizations.of(context)!.translate(LangKeys.admin_...)`.

---

### [Admin Widgets Refactoring]

#### All widgets in `lib/features/admin/presentation/views/widgets/`

- Refactor widgets to use localized strings.

## Verification Plan

### Manual Verification
- Launch the application and navigate to the Admin section.
- Switch the application language between Arabic and English.
- Verify that:
    - All titles, labels, hints, and messages are correctly translated.
    - The UI layout (RTL/LTR) adjusts correctly.
    - Dates are formatted according to the selected language.
    - Enum names (Notification Type, Report Status, etc.) are translated.
- Screenshots will be taken for both languages to confirm the fix.
