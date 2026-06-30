import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/admin/presentation/views/widgets/admin_dashboard_screen/header_mini_stat.dart';

class SummaryHeader extends StatelessWidget {
  const SummaryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkGradient
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
              ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withValues(
              alpha: Theme.of(context).brightness == Brightness.dark
                  ? 0.4
                  : 0.3,
            ),
            blurRadius: 25,
            offset: const Offset(0, 15),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    local.smart_control_center,
                    style: TextStyle(
                      color: Colors.blueAccent.withValues(alpha: 0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    local.welcome_leader,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: const Icon(
                  Icons.bolt_rounded,
                  color: Colors.amber,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                HeaderMiniStat(
                  label: local.status,
                  value: local.online_now,
                  icon: Icons.circle,
                  color: Colors.greenAccent,
                ),
                Container(
                  width: 1,
                  height: 20,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                HeaderMiniStat(
                  label: local.updateStatus,
                  value: local.automatic,
                  icon: Icons.sync_rounded,
                  color: Colors.blueAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
