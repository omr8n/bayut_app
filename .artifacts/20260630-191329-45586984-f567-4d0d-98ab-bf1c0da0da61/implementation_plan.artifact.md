# Search and Filter UI Fixes (Colors, Localization, Dark Mode, Syntax)

This plan covers fixing a syntax error, aligning search and filter screens with the app's primary blue color, ensuring full localization (Arabic/English), and improving dark mode support.

## Proposed Changes

### 1. Fix Syntax Error

#### [location_step.dart](file:///D:/test_graduation/lib/features/on_boarding/presentation/views/widgets/interactive_steps/location_step.dart)
- Fix typo: `AppColors.primarwithValues` -> `AppColors.primary.withValues`.

### 2. Search Location Page

#### [location_search_page_body.dart](file:///D:/test_graduation/lib/features/search/presentation/veiw/widgets/location_search_page_body.dart)
- Update "Done" button background: `backgroundColor: isDark ? AppColors.primary : const Color(0xFF005F5F)` -> `backgroundColor: AppColors.primary`.
- Ensure "Reset Search" button text color adapts to dark mode (using `Colors.white` in dark mode).

### 3. Filter Screen

#### [build_counter_row.dart](file:///D:/test_graduation/lib/features/search/presentation/veiw/widgets/build_counter_row.dart)
- Replace hardcoded `'الكل'` with `locale.translate(LangKeys.all)`.
- Support dark mode for the unselected item background (`isDark ? AppColors.darkSurface : Colors.white`) and text color (`isDark ? Colors.white70 : Colors.black`).

#### [filter_form.dart](file:///D:/test_graduation/lib/features/search/presentation/veiw/widgets/filter_form.dart)
- Ensure all sections and buttons use `AppColors.primary`.
- Improve RangeSlider styling for dark mode.

#### [filter_buttons.dart](file:///D:/test_graduation/lib/features/search/presentation/veiw/widgets/filter_buttons.dart)
- Update "Reset" button text color: `color: AppColors.primary` -> `color: isDark ? Colors.white : AppColors.primary`.

---

## Verification Plan

### Manual Verification
- **Fix Verification**: Ensure `location_step.dart` compiles correctly.
- **Localization**: Switch language to English and verify "All" appears in the Room/Bath filters.
- **Colors**: Verify the "Done" and "Apply" buttons are Blue (`#0D47A1`).
- **Dark Mode**: Check readability and contrast in dark mode for all modified screens.
