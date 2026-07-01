# Implementation Plan - Fix Top Buttons Localization and Theme

The goal is to ensure that the top floating buttons (Back, Share, Favorite) on the Property Dashboard and Property Details screens handle localization (Arabic/English) and themes (Dark/Light) correctly, focusing on icon direction and positioning.

## User Review Required

> [!IMPORTANT]
> - I will use `Icons.arrow_back_ios_new` for English (points Left) and `Icons.arrow_forward_ios` for Arabic (points Right) as the back button.
> - I will wrap the buttons in a `SafeArea` to ensure they don't overlap with status bar icons or notches, which might slightly change their vertical position from the current hardcoded `40.h`.

## Proposed Changes

### UI Components

#### [PropertyDashboardView](file:///D:/test_graduation/lib/features/my_properties/presentation/views/property_dashboard_view.dart)
- Replace the hardcoded `top: 40.h` with a `SafeArea` wrapped `Positioned` for better device compatibility.
- Ensure the back button icon and position flip correctly in RTL.

#### [PropertyDetailsScreen](file:///D:/test_graduation/lib/features/home/presentation/view/details_view.dart)
- Fix the hardcoded `Icons.arrow_back_ios_new` which points the wrong way in Arabic.
- Wrap the top buttons in `SafeArea`.
- Ensure the trailing actions (Share/Favorite) are correctly positioned in RTL.

#### [CustomCircleButton](file:///D:/test_graduation/lib/core/widgets/custom_circle_button.dart)
- I will keep the existing white background and black icon as requested ("don't change their colors"), but I will ensure they are consistently applied across screens.

---

## Verification Plan

### Automated Tests
- No specific automated tests are available for UI positioning, but I will perform manual verification.

### Manual Verification
1.  **Language Toggle**:
    *   Switch the app to Arabic.
    *   Verify the back button is on the **Top Right** and points **Right**.
    *   Verify the Share/Favorite buttons are on the **Top Left**.
    *   Switch to English and verify the reverse.
2.  **Theme Toggle**:
    *   Switch to Dark Mode and Light Mode.
    *   Verify the buttons are still visible and look consistent with the user's provided screenshot.
3.  **Device Compatibility**:
    *   Check how the buttons sit relative to the status bar (ensuring they are not too high/low).
