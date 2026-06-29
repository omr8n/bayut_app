# Admin Settings Enhancements & Limits Enforcement

Give the admin full control over pricing and media limits with intelligent automatic calculations for featured prices.

## My Analysis & Updated Strategy

1.  **Removal of Commission Rate:** As requested, I will remove the commission rate from the settings since transactions happen outside the app.
2.  **Smart Pricing Logic:** I will implement a "Smart Pricing" feature in the Admin Settings:
    - If the admin sets the **Monthly** price, the **Weekly** price will automatically update to **33%** of the monthly price.
    - If the admin sets the **Weekly** price, the **Monthly** price will automatically update (Weekly / 0.33).
    - This ensures pricing consistency and prevents human error.
3.  **Step-by-Step Distribution:** I will divide the work into clear phases to ensure Clean Architecture and MVVM patterns are strictly followed.

## Proposed Changes (Step-by-Step)

### Phase 1: Data Model & Localization
- **AppConfigModel:** Update to include `weeklyFeaturedPrice`, `monthlyFeaturedPrice`, `freePropertyLimitPerDay`, `extraPropertyPrice`, `maxImagesPerProperty`, `maxVideosPerProperty`, `baseCurrency`.
- **ar.json:** Add all necessary Arabic strings for the new settings and validation alerts.

### Phase 2: Admin Settings Logic (MVVM)
- **AdminSettingsCubit:** Implement `updateWeeklyPrice(double)` and `updateMonthlyPrice(double)` with the 33% cross-calculation logic.
- **MarketSettingsTab:**
    - Build a professional UI for these settings.
    - Use input fields that update each other in real-time or via a "Calculate" step to ensure the 33% rule.

### Phase 3: Limits Enforcement (Services)
- **ListingLimitService:** Inject the dynamic `freePropertyLimitPerDay` instead of the hardcoded `3`.
- **AddPropertyCubit:** Add validation logic for media counts before processing.

### Phase 4: Add Property flow (UI/UX)
- **AddPropertyBody:**
    - Update the media picker to count and validate against `maxImages` and `maxVideos`.
    - Block further selection and show a SnackBar if limits are reached.
    - Pass the dynamic `extraPropertyPrice` to the payment bottom sheet.

## User Review Required

- **Automatic Calculation Override:** Should the admin be able to manually override the 33% calculation if they want a special offer, or should it be strictly enforced?
- **Rounding:** For the 33% calculation, should I round the result to the nearest 100 or 500 (e.g., 3333 -> 3300) to keep prices "clean"?

---

## Verification Plan

1.  **Calculation Test:** In Admin Settings, enter 10,000 for Monthly. Verify Weekly becomes 3,300 (or rounded value).
2.  **Enforcement Test:** Set "Max Videos" to 0. Try picking a video in Add Property. Verify it's blocked.
3.  **Posting Limit Test:** Set "Free Limit" to 0. Try adding any property. Verify it asks for payment immediately.
