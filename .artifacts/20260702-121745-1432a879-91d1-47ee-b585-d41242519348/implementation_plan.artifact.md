# Implementation Plan - Daily Free Listing Limits and Direct Payment

This plan outlines the changes required to enforce daily free listing limits (max 3), allow users to pay for extra listings using existing payment methods, and ensure these listings are published directly.

## User Review Required

- **Payment Details**: The user mentioned they already have bank accounts and SyriaTel cash "for show". I will use these existing labels/methods. I will not add a new admin field for these as per user request.
- **Direct Publishing**: Extra paid listings will be set to `isApproved: true` immediately. I will confirm if free listings should be `isApproved: false` by default (awaiting admin review).

## Proposed Changes

### UI & User Experience

#### [limit_reached_bottom_sheet.dart](file:///D:/test_graduation/lib/features/my_properties/presentation/views/widgets/limit_reached_bottom_sheet.dart)
- Add payment method selection (radio buttons for "Syrian Bank Card" and "Cash Method") to match the `PromotionSheet` UI.
- Update the "Pay and Publish" button logic to ensure a method is selected.

#### [promotion_sheet.dart](file:///D:/test_graduation/lib/features/my_properties/presentation/views/widgets/dashboard_widgets/promotion_sheet.dart)
- Keep current logic but ensure consistency with the new limit sheet.

---

### Business Logic

#### [add_property_body.dart](file:///D:/test_graduation/lib/features/my_properties/presentation/views/widgets/add_property_body.dart)
- Update `_showLimitReachedSheet` to handle the selected payment method.
- Ensure the price and currency are pulled correctly from `AdminSettingsCubit`.

#### [payment_service.dart](file:///D:/test_graduation/lib/core/services/payment_service.dart)
- Ensure the simulated payment record includes the selected payment method.
- Verify that the transaction is correctly recorded in the `financialTransfers` collection.

#### [listing_limit_service.dart](file:///D:/test_graduation/lib/core/services/listing_limit_service.dart)
- Ensure the 3-property limit is strictly enforced based on the last 24 hours.

---

### Data Models

#### [property_model.dart](file:///D:/test_graduation/lib/core/models/property_model.dart)
- Ensure `isApproved` is correctly serialized.

## Verification Plan

### Manual Verification Steps
1. **Enforce Limit**: Attempt to add a 4th property as a user. Verify `LimitReachedBottomSheet` appears.
2. **Payment Selection**: Verify that the sheet now allows selecting a payment method.
3. **Direct Publish**: After "paying", verify the property appears in the app immediately without admin action.
4. **Wallet Check**: As admin, verify the payment appears in the "Financial Wallet".
5. **Timer**: Verify the countdown timer accurately shows time remaining until the next free slot.
