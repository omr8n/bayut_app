# Implementation Plan - Reverse Admin Settings Tabs

The goal is to reverse the order of the tabs in the Admin Settings screen. This involves reversing both the `tabs` list in the `TabBar` and the `children` list in the `TabBarView`, and updating the `initialIndex` accordingly.

## Proposed Changes

### Admin Feature

#### [admin_settings_screen.dart](file:///D:/test_graduation/lib/features/admin/presentation/views/admin_settings_screen.dart)

- Reverse the order of `tabs` in `DefaultTabController`'s `TabBar`.
- Reverse the order of `children` in `TabBarView`.
- Update `initialIndex` from `4` to `0` to maintain the default starting tab as "Platform".

```diff
     return DefaultTabController(
       length: 5,
-      initialIndex: 4, // Starting from "Platform" (Right-most in RTL)
+      initialIndex: 0, // Starting from "Platform"
       child: Scaffold(
         backgroundColor: const Color(0xFFF8F9FB),
...
           bottom: TabBar(
...
             tabs: [
-               Tab(
-                text: local.legal_and_contact,
-                icon: const Icon(Icons.gavel_rounded),
-              ),
-              Tab(
-                text: local.property_data,
-                icon: const Icon(Icons.home_work_outlined),
-              ),
-              Tab(
-                text: local.geography,
-                icon: const Icon(Icons.public_rounded),
-              ),
-              Tab(
-                text: local.market,
-                icon: const Icon(Icons.shopping_bag_outlined),
-              ),
               Tab(
                 text: local.platform,
                 icon: const Icon(Icons.tune_rounded),
               ),
+              Tab(
+                text: local.market,
+                icon: const Icon(Icons.shopping_bag_outlined),
+              ),
+              Tab(
+                text: local.geography,
+                icon: const Icon(Icons.public_rounded),
+              ),
+              Tab(
+                text: local.property_data,
+                icon: const Icon(Icons.home_work_outlined),
+              ),
+              Tab(
+                text: local.legal_and_contact,
+                icon: const Icon(Icons.gavel_rounded),
+              ),
             ],
           ),
         ),
         body: const TabBarView(
           children: [
+            PlatformSettingsTab(),
+            MarketSettingsTab(),
+            GeographySettingsTab(),
+            PropertyDataSettingsTab(),
             LegalContactSettingsTab(),
-            PropertyDataSettingsTab(),
-            GeographySettingsTab(),
-            MarketSettingsTab(),
-            PlatformSettingsTab(),
           ],
         ),
```

## Verification Plan

### Manual Verification
- I will use `render_compose_preview` if applicable, but since this is a full screen with many dependencies, I'll rely on code inspection and ensuring the lists match.
- I'll check if there are any other files that define these tabs.
- I'll use `analyze_file` to ensure no syntax errors were introduced.
