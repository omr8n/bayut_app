# Synchronized Background Upload & Feedback Walkthrough

I have implemented the requested synchronization for property uploads. The user can now navigate the application freely while the upload happens in the background, and the success message will appear globally once the process is truly finished.

## Changes Overview

### 1. New State for Immediate Navigation
Added `AddPropertyInProgress` in [add_property_state.dart](file:///D:/test_graduation/lib/features/my_properties/presentation/cubit/add_property_state.dart) to signal that the background process has started.

### 2. Decoupled UI Response from Completion
In [add_property_cubit.dart](file:///D:/test_graduation/lib/features/my_properties/presentation/cubit/add_property_cubit.dart):
- `submitProperty` and `editProperty` now emit `AddPropertyInProgress` instead of a success state. This triggers immediate navigation.
- Added `_showGlobalSuccessSnackBar(bool isUpdate)` which uses the global `navigatorKey` context to show a floating SnackBar.
- The `_processPropertyUpload` background method now calls `_showGlobalSuccessSnackBar` only after the server repository confirms the property is saved.

### 3. Updated View Logic
In [add_property_view_body_bloc_builder.dart](file:///D:/test_graduation/lib/features/my_properties/presentation/views/widgets/add_property_view_body_bloc_builder.dart):
- The listener now watches for `AddPropertyInProgress` to trigger the `pushReplacement(AppRoutes.mainScreen)` immediately.
- Removed the local SnackBar logic as it's now handled globally by the Cubit.

## Verification Summary

### Manual Verification Flow
1. **Initiate Upload**: User clicks "Add Property".
2. **Immediate Feedback**: The app immediately navigates back to the Main screen.
3. **Background Progress**: The user can navigate to "Search" or "Profile" while the notification tray shows progress.
4. **Final Success**: Once the notification reaches 100% and shows "Process Completed", a floating SnackBar appears on whatever screen the user is currently viewing, saying "Property Uploaded Successfully".

### Key Code Diffs

#### `AddPropertyCubit` Completion Logic
```dart
          (_) {
            _showSuccessNotification(id, params.title, isUpdate: isUpdate);
            _showGlobalSuccessSnackBar(isUpdate);
          },
```

#### Global SnackBar Implementation
```dart
  void _showGlobalSuccessSnackBar(bool isUpdate) {
    final context = RouterGenerationConfig.goRouter.configuration.navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isUpdate ? ... : ...),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
```
