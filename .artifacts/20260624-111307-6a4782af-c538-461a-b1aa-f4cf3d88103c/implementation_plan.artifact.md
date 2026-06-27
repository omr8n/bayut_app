# Radical Admin Management Hub - Technical Implementation Plan

This plan transforms the current static settings into a **Dynamic Management Engine**. Every change made by the admin will be immediately reflected across the entire user application (Cities, Featured Plans, Facilities, etc.).

## User Review Required

> [!IMPORTANT]
> - **Dynamism**: I will move hardcoded lists (like `AppConstants.governorates` or `PremiumPromotionSheet` plans) to the `AdminSettingsEntity` fetched from Firestore.
> - **Seamless Migration**: I will ensure that if a setting is missing in Firestore, the app falls back to the current hardcoded defaults to prevent any crashes.

## Proposed Changes

### 1. Data Model & Logic (The Foundation)

#### [admin_settings_entity.dart](file:///D:/test_graduation/lib/features/admin/domain/entities/admin_settings_entity.dart)
- Add `cancellationReasons` (List<String>).
- Add `featuredPlans` (List<Map<String, dynamic>>). Each plan: `id`, `name`, `price`, `days`, `desc`, `iconCode`.

#### [admin_settings_model.dart](file:///D:/test_graduation/lib/features/admin/data/models/admin_settings_model.dart)
- Update `fromJson` and `toJson` to support new fields.

#### [admin_settings_repository_impl.dart](file:///D:/test_graduation/lib/features/admin/data/repos/admin_settings_repository_impl.dart)
- Update `getSettings()` default values to include standard cancellation reasons (e.g., "Sold outside app", "Decided not to sell").

---

### 2. Radical UI Redesign (The Management Hub)

#### [admin_settings_screen.dart](file:///D:/test_graduation/lib/features/admin/presentation/views/admin_settings_screen.dart)
- **New Layout**: A high-end grid of **"Engine Cards"**:
    - **Finance Engine**: Control Currency & Featured Plans.
    - **Geographic Engine**: Managed allowed Cities & Governorates.
    - **Property Engine**: Manage Types, Facilities, Finishings.
    - **Operational Engine**: Manage Cancellation Reasons.
    - **Platform Identity**: Maintenance, Support, Policies.
- **Global Search**: Floating search bar to find any setting instantly.

#### [NEW] [engine_card.dart](file:///D:/test_graduation/lib/features/admin/presentation/views/widgets/settings/engine_card.dart)
- Interactive card showing real-time stats (e.g., "15 Cities", "5 Active Plans").

#### [NEW] [dynamic_list_manager.dart](file:///D:/test_graduation/lib/features/admin/presentation/views/widgets/settings/dynamic_list_manager.dart)
- A reusable, smooth UI for adding/removing items from any setting list (Cities, Reasons, Types).

---

### 3. Application-Wide Integration (The Impact)

#### [premium_promotion_sheet.dart](file:///D:/test_graduation/lib/features/my_properties/presentation/views/widgets/premium_promotion_sheet.dart)
- **Change**: Replace hardcoded `plans` list with dynamic data from `AdminSettingsCubit`.

#### [dashboard_bottom_actions.dart](file:///D:/test_graduation/lib/features/my_properties/presentation/views/widgets/dashboard_widgets/dashboard_bottom_actions.dart)
- **Change**: Replace the `TextField` for reason with a **Dropdown/Selection** populated from `AdminSettingsCubit.cancellationReasons`.

#### [add_property_body.dart](file:///D:/test_graduation/lib/features/my_properties/presentation/views/widgets/add_property_body.dart)
- **Change**: Fetch lists like `governorates` and `finishTypes` dynamically from the Admin Settings instead of `AppConstants`.

## Verification Plan

### Manual Verification (The "Smart" Proof)
1.  **Dynamic Update**: Add a new city "New Latakia" in Admin Hub -> Verify it appears instantly in the "Add Property" dropdown.
2.  **Plan Flexibility**: Change the price of the "Basic" plan in Admin Hub -> Verify `PremiumPromotionSheet` reflects the new price immediately.
3.  **Seamless Search**: Search for "Damascus" in the new Admin Hub search bar and ensure it takes you to the Geographic Engine.
4.  **Cancellation Flow**: Mark a property as "Sold" -> Verify that the pre-defined reasons from Admin Hub are displayed in the dialog.
