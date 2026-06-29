# Implementation Plan - Admin Performance Optimization

"Lighten" the data and UI complexity in the Admin section to resolve frame drops and connection issues, following the "graduation project" placeholder pattern where appropriate.

## Proposed Changes

### UI Simplification (Admin Dashboard)

#### [admin_dashboard_screen.dart](file:///D:/test_graduation/lib/features/admin/presentation/views/admin_dashboard_screen.dart)
- Replace `MainComparisonChart` and the horizontal `DonutChartCard` row with a single placeholder widget: `AdminSettingsPlaceholder`.
- Remove `CityDistributionCard` or simplify it.
- Keep `ModernStatGrid` but simplify its items.

#### [modern_stat_card.dart](file:///D:/test_graduation/lib/features/admin/presentation/views/widgets/admin_dashboard_screen/modern_stat_card.dart)
- Remove `MiniSparkline` to reduce the number of active `fl_chart` instances on the screen.

#### [recent_activity_timeline.dart](file:///D:/test_graduation/lib/features/admin/presentation/views/widgets/admin_dashboard_screen/recent_activity_timeline.dart)
- Simplify the layout to use standard widgets instead of complex `IntrinsicHeight` and custom drawings.

---

### Data Optimization

#### [admin_repo_impl.dart](file:///D:/test_graduation/lib/features/admin/data/repos/admin_repo_impl.dart)
- Introduce limits to the data fetching in `getAllProperties` and `getAllUsers` (e.g., limit to 20 items for now).
- Simplify stat calculations to avoid iterating over large collections multiple times.

---

### UI Bug Fixes

#### [custom_drawer.dart](file:///D:/test_graduation/lib/features/admin/presentation/views/widgets/custom_drawer.dart)
- Wrap the `Drawer` content in `Material` to resolve the `ListTile` background visibility warning.

## Verification Plan

### Manual Verification
- Navigate through the Admin Dashboard and verify that the UI is responsive (no "Skipped frames" logs).
- Verify that the `ListTile` warning is gone from the logs.
- Check that the data volume in the logs is reduced (fewer `PropertyEntity` objects in `PropertySuccess`).
