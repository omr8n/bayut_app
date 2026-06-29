# Task: Implement Admin Settings Enhancements & Limits Enforcement

- [/] Phase 1: Research & Planning
	- [x] Analyze current Admin Settings and Add Property logic
	- [x] Create implementation plan
- [ ] Phase 2: Core Model & Data Layer
	- [ ] Update `AppConfigModel` with new fields
	- [ ] Update `AdminSettingsCubit` to handle new fields
	- [ ] Update localization files (`ar.json`, `en.json`)
- [ ] Phase 3: Admin Settings UI
	- [ ] Update `MarketSettingsTab` to show/edit new fields
	- [ ] Implement edit dialogs for settings
- [ ] Phase 4: Limits Enforcement in Add Property
	- [ ] Update `ListingLimitService` to use dynamic config
	- [ ] Enforce media limits in `AddPropertyBody`
	- [ ] Update `_showLimitReachedSheet` with dynamic pricing
- [ ] Phase 5: Verification & Refinement
	- [ ] Verify all settings persist and affect the app logic
	- [ ] Finalize Clean Arch & MVVM structure
