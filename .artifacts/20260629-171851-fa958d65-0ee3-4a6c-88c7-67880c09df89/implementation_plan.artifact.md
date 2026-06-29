# Synchronize Success Message with Background Upload (Minimal Changes)

The goal is to allow the user to navigate the app freely after clicking "Add Property" while the upload continues in the background. The success message (SnackBar) should only appear when the background process is actually complete.

## Proposed Changes

### Add Property Feature

#### [add_property_state.dart](file:///D:/test_graduation/lib/features/my_properties/presentation/cubit/add_property_state.dart)
- Add `AddPropertyInProgress` state to signify that the process has started and the UI can navigate away.

#### [add_property_cubit.dart](file:///D:/test_graduation/lib/features/my_properties/presentation/cubit/add_property_cubit.dart)
- In `submitProperty` and `editProperty`, replace `emit(AddPropertySuccess())` / `emit(UpdatePropertySuccess())` with `emit(AddPropertyInProgress())`.
- In `_processPropertyUpload`, after the successful repository call:
    - Trigger a global SnackBar using `RouterGenerationConfig.goRouter.configuration.navigatorKey.currentContext` to show the success message.
    - This ensures the message appears even if the user has navigated to another screen.

#### [add_property_view_body_bloc_builder.dart](file:///D:/test_graduation/lib/features/my_properties/presentation/views/widgets/add_property_view_body_bloc_builder.dart)
- Update the `BlocListener` to react to `AddPropertyInProgress` by navigating to the main screen immediately.
- Remove the SnackBar logic from the `BlocListener` for `AddPropertySuccess` as it will now be handled globally by the Cubit when the background task finishes.

## Verification Plan
1. Start property upload.
2. Verify app immediately returns to home screen.
3. Observe upload progress in notification "curtain".
4. Verify success SnackBar appears only after progress reaches 100% and notification shows success.
