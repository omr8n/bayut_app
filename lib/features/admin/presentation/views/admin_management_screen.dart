import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';

class AdminManagementScreen extends StatelessWidget {
  const AdminManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(local.admins_management), centerTitle: true),

      body: Column(
        children: [
          const SizedBox(height: 16),

          // ===================== SEARCH BAR =====================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: local.search_admin_hint,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ===================== ADD NEW ADMIN BUTTON =====================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showAddAdminDialog(context),
                icon: const Icon(Icons.person_add),
                label: Text(local.add_new_admin),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ===================== ADMINS LIST =====================
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _adminTile(
                  name: "Omar Al-Ali",
                  email: "omar@example.com",
                  role: "Super Admin",
                  context: context,
                ),
                _adminTile(
                  name: "Mohammad Yousef",
                  email: "mohammad@example.com",
                  role: "Editor",
                  context: context,
                ),
                _adminTile(
                  name: "Layan Khaled",
                  email: "lian@example.com",
                  role: "Viewer",
                  context: context,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===================== ADMIN ITEM TILE =====================
  Widget _adminTile({
    required String name,
    required String email,
    required String role,
    required BuildContext context,
  }) {
    final local = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withValues(alpha: 0.04),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          const CircleAvatar(radius: 24, child: Icon(Icons.person, size: 28)),

          const SizedBox(width: 14),

          // Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 4),
                Text(
                  "${local.permission_label}: $role",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          // Edit & Delete Actions
          IconButton(
            onPressed: () => _showEditAdminDialog(context, name, email, role),
            icon: const Icon(Icons.edit, color: Colors.blue),
          ),

          IconButton(
            onPressed: () => _deleteAdmin(context, name),
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }

  // ===================== ADD ADMIN DIALOG =====================
  void _showAddAdminDialog(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final roleController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(local.add_new_admin),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _inputField(local.name, nameController),
              const SizedBox(height: 10),
              _inputField(local.email, emailController),
              const SizedBox(height: 10),
              _inputField(local.permission_label, roleController),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(local.cancel),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(local.register),
            ), // Or localized Add
          ],
        );
      },
    );
  }

  // ===================== EDIT ADMIN DIALOG =====================
  void _showEditAdminDialog(
    BuildContext context,
    String oldName,
    String oldEmail,
    String oldRole,
  ) {
    final local = AppLocalizations.of(context)!;
    final nameController = TextEditingController(text: oldName);
    final emailController = TextEditingController(text: oldEmail);
    final roleController = TextEditingController(text: oldRole);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(local.edit_admin_details),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _inputField(local.name, nameController),
              const SizedBox(height: 10),
              _inputField(local.email, emailController),
              const SizedBox(height: 10),
              _inputField(local.permission_label, roleController),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(local.cancel),
            ),
            ElevatedButton(onPressed: () {}, child: Text(local.save)),
          ],
        );
      },
    );
  }

  // ===================== DELETE CONFIRM =====================
  void _deleteAdmin(BuildContext context, String name) {
    final local = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(local.delete_admin),
        content: Text(
          local.delete_admin_confirm_label.replaceFirst('{name}', name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(local.cancel),
          ),
          ElevatedButton(onPressed: () {}, child: Text(local.delete)),
        ],
      ),
    );
  }

  // ===================== TEXT FIELD GENERATOR =====================
  Widget _inputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
