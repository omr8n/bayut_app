import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/models/admin_action_model.dart';
import 'package:test_graduation/core/models/notification_model.dart';
import 'package:test_graduation/features/admin/domain/repos/admin_action_repo.dart';
import 'package:test_graduation/features/admin/domain/repos/admin_repo.dart';
import 'package:test_graduation/features/notifications/domain/use_cases/send_notification_use_case.dart';
import 'package:test_graduation/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:uuid/uuid.dart';
import 'package:test_graduation/core/models/financial_record_model.dart';
import 'package:test_graduation/core/utils/backend_endpoint.dart';
import 'package:test_graduation/core/services/data_service.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  final AdminRepo adminRepo;
  final AdminActionRepo adminActionRepo;
  final SendNotificationUseCase sendNotificationUseCase;
  final ProfileCubit profileCubit;

  AdminCubit(
    this.adminRepo,
    this.adminActionRepo,
    this.sendNotificationUseCase,
    this.profileCubit,
  ) : super(AdminInitial());

  String currentFilter = 'week';
  DateTime selectedDate = DateTime.now();

  // Helper to log actions and send notifications to users
  void _processAction({
    required String type,
    required String targetId,
    required String description,
    String? targetUserId,
    String? notificationTitle,
  }) async {
    // 1. Log Action (Internal Admin Log)
    final admin = profileCubit.user;
    adminActionRepo.logAction(
      AdminActionModel(
        id: const Uuid().v4(),
        adminId: admin?.uId ?? 'unknown_admin',
        adminName: admin?.name ?? 'Unknown Admin',
        actionType: type,
        targetId: targetId,
        description: description,
        createdAt: DateTime.now(),
      ),
    );

    // 2. Send Notification to User (Trigger for Firebase Extension)
    if (targetUserId != null) {
      final title = notificationTitle ?? "Admin Alert";

      // Improvement: Fetch only the target user data instead of all
      final userResult = await adminRepo.getUserById(targetUserId);
      String? fcmToken;
      userResult.fold((_) => null, (user) {
        fcmToken = user.fcmToken;
      });

      final notification = AppNotification(
        id: const Uuid().v4(),
        title: title,
        body: description,
        type: NotificationType.adminAction,
        targetUserId: targetUserId,
        targetId: targetId, // 🔥 Link notification to target
        sentToAll: false,
        sentAt: DateTime.now(),
        recipientsCount: 1,
        isRead: false,
        fcmToken: fcmToken, // 🔥 Pass token directly to model
      );

      await sendNotificationUseCase(notification);
    }
  }

  // 1. Fetch Dashboard Stats
  Future<void> getStats({String? filter, DateTime? date}) async {
    if (filter != null) currentFilter = filter;
    if (date != null) selectedDate = date;

    emit(AdminLoading());

    // 🔥 Check properties about to expire before fetching stats
    await _checkExpiringPremiums();

    final result = await adminRepo.getAdminStats(
      timeFilter: currentFilter,
      targetDate: selectedDate,
    );
    result.fold(
      (failure) => emit(AdminFailure(failure.message)),
      (stats) => emit(AdminStatsSuccess(stats)),
    );
  }

  // 2. Fetch All Users
  Future<void> fetchUsers() async {
    emit(AdminLoading());
    final result = await adminRepo.getAllUsers();
    result.fold(
      (failure) => emit(AdminFailure(failure.message)),
      (users) => emit(AdminUsersSuccess(users)),
    );
  }

  // 3. Block/Unblock User
  Future<void> toggleUserBlock(String uId, bool isBlocked) async {
    final result = await adminRepo.blockUser(uId: uId, block: isBlocked);
    result.fold((failure) => emit(AdminFailure(failure.message)), (_) {
      final desc = isBlocked
          ? "Your account has been blocked by administration for violating terms"
          : "Your account has been unblocked, you can use it now";
      _processAction(
        type: 'BLOCK_USER',
        targetId: uId,
        targetUserId: uId,
        description: desc,
        notificationTitle: isBlocked ? "Account Blocked" : "Account Unblocked",
      );
      emit(const AdminActionSuccess("User status updated successfully"));
      fetchUsers();
    });
  }

  // 4. Delete User
  Future<void> deleteUser(String uId) async {
    final result = await adminRepo.deleteUser(uId: uId);
    result.fold((failure) => emit(AdminFailure(failure.message)), (_) {
      _processAction(
        type: 'DELETE_USER',
        targetId: uId,
        description: "User account deleted permanently: $uId",
      );
      emit(const AdminActionSuccess("User deleted successfully"));
      fetchUsers();
    });
  }

  // 5. Update Admin Notes
  Future<void> updateAdminNotes(String uId, String notes) async {
    final result = await adminRepo.updateAdminNotes(uId: uId, notes: notes);
    result.fold((failure) => emit(AdminFailure(failure.message)), (_) {
      emit(const AdminActionSuccess("Admin notes saved"));
      fetchUsers();
    });
  }

  // 6. Fetch All Properties
  Future<void> fetchProperties() async {
    emit(AdminLoading());
    final result = await adminRepo.getAllProperties();
    result.fold(
      (failure) => emit(AdminFailure(failure.message)),
      (properties) => emit(AdminPropertiesSuccess(properties)),
    );
  }

  // 7. Toggle Property Approval (Synced with UI)
  Future<void> togglePropertyApproval(
    String id,
    bool isApproved,
    String sellerId,
  ) async {
    final result = await adminRepo.togglePropertyApproval(
      propertyId: id,
      isApproved: isApproved,
    );
    result.fold((failure) => emit(AdminFailure(failure.message)), (_) {
      final desc = isApproved
          ? "Your property #$id has been approved for publishing"
          : "Your property #$id has been rejected, please review details";
      _processAction(
        type: 'CHANGE_STATUS',
        targetId: id,
        targetUserId: sellerId,
        description: desc,
        notificationTitle: isApproved ? "Property Approved" : "Property Rejected",
      );
      emit(
        AdminActionSuccess(
          isApproved ? "Property Approved" : "Property Approval Cancelled",
        ),
      );
      fetchProperties();
    });
  }

  // 8. Toggle Featured (Synced with UI)
  Future<void> togglePropertyFeatured(
    String id,
    bool isFeatured,
    String sellerId,
  ) async {
    final result = await adminRepo.togglePropertyFeatured(
      propertyId: id,
      isFeatured: isFeatured,
    );
    result.fold((failure) => emit(AdminFailure(failure.message)), (_) {
      _processAction(
        type: 'FEATURE_PROPERTY',
        targetId: id,
        targetUserId: sellerId,
        description: isFeatured
            ? "Congratulations! Your property #$id has been selected for the featured list, it will now be shown to more users."
            : "Featured status has been removed from property #$id by administration.",
        notificationTitle: isFeatured
            ? "Congratulations! Your property is now featured"
            : "Featured Status Update",
      );
      emit(
        AdminActionSuccess(
          isFeatured ? "Property featured successfully" : "Feature removed",
        ),
      );
      fetchProperties();
    });
  }

  // 🔥 Handle Premium Request (Approve/Reject) + Financial Record + Notification
  Future<void> handlePremiumRequest({
    required String propertyId,
    required String sellerId,
    required bool isApproved,
    int? days, // 7 for weekly, 30 for monthly
    double? amount,
    String? sellerName,
  }) async {
    emit(AdminLoading());

    if (isApproved) {
      final expiryDate = DateTime.now().add(Duration(days: days ?? 7));

      // 1. Update property status in Firestore
      await adminRepo.togglePropertyFeatured(
        propertyId: propertyId,
        isFeatured: true,
      );
      await getIt<DatabaseService>().updateData(
        path: BackendEndpoint.getProperty,
        documentId: propertyId,
        data: {
          'premiumStatus': PremiumStatus.active.name,
          'premiumExpiryDate': expiryDate.toIso8601String(),
          'premiumReminderSent': false, // 🔥 Reset reminder status on renewal
          'isFeatured': true,
        },
      );

      // 2. Financial transaction log (Mock Payment)
      final financialRecord = FinancialRecordModel(
        id: const Uuid().v4(),
        propertyId: propertyId,
        sellerId: sellerId,
        sellerName: sellerName ?? 'User',
        amount: amount ?? 0,
        currency: 'SYP',
        type: (days == 30)
            ? TransactionType.promotionMonthly
            : TransactionType.promotionWeekly,
        createdAt: DateTime.now(),
      );

      await getIt<DatabaseService>().addData(
        path: BackendEndpoint.financialTransfers,
        data: financialRecord.toJson(),
      );

      // 3. Send notification to user
      _processAction(
        type: 'PREMIUM_APPROVED',
        targetId: propertyId,
        targetUserId: sellerId,
        description:
            "Congratulations! Your premium request has been approved, it will now appear at the top of results for $days days.",
        notificationTitle: "Premium Activated 🚀",
      );
    } else {
      // Rejection case
      await getIt<DatabaseService>().updateData(
        path: BackendEndpoint.getProperty,
        documentId: propertyId,
        data: {'premiumStatus': PremiumStatus.rejected.name},
      );

      _processAction(
        type: 'PREMIUM_REJECTED',
        targetId: propertyId,
        targetUserId: sellerId,
        description:
            "Premium request for property #$propertyId has been rejected. Please contact administration.",
        notificationTitle: "Premium Request Rejected ❌",
      );
    }

    emit(const AdminActionSuccess("Request processed successfully"));
    fetchProperties();
  }

  // 9. Delete Property
  Future<void> deleteProperty(String id, String sellerId) async {
    final result = await adminRepo.deleteProperty(propertyId: id);
    result.fold((failure) => emit(AdminFailure(failure.message)), (_) {
      _processAction(
        type: 'DELETE_PROPERTY',
        targetId: id,
        targetUserId: sellerId,
        description: "Property #$id deleted for violating standards",
        notificationTitle: "Property Deleted",
      );
      emit(const AdminActionSuccess("Property deleted successfully"));
      fetchProperties();
    });
  }

  // 10. Fetch Reports
  Future<void> fetchReports() async {
    emit(AdminLoading());
    final result = await adminRepo.getAllReports();
    result.fold(
      (failure) => emit(AdminFailure(failure.message)),
      (reports) => emit(AdminReportsSuccess(reports)),
    );
  }

  // 11. Update Report Status
  Future<void> updateReportStatus(
    String id,
    String status, {
    String? adminNote,
    String? reporterId,
  }) async {
    emit(AdminLoading());
    final result = await adminRepo.updateReportStatus(
      reportId: id,
      status: status,
      adminNote: adminNote,
    );
    result.fold((failure) => emit(AdminFailure(failure.message)), (_) {
      if (reporterId != null) {
        _processAction(
          type: 'UPDATE_REPORT',
          targetId: id,
          targetUserId: reporterId,
          description:
              "Your report status (#$id) has been updated to: $status. Notes: ${adminNote ?? 'None'}",
          notificationTitle: "Report Status Update",
        );
      }
      emit(const AdminActionSuccess("Report status updated successfully"));
      fetchReports();
    });
  }

  // 12. Send Global Notification
  Future<void> sendNotification(String title, String body) async {
    emit(AdminLoading());
    final result = await adminRepo.sendGlobalNotification(
      title: title,
      body: body,
    );
    result.fold((failure) => emit(AdminFailure(failure.message)), (_) {
      // Log action in admin logs
      final admin = profileCubit.user;
      adminActionRepo.logAction(
        AdminActionModel(
          id: const Uuid().v4(),
          adminId: admin?.uId ?? 'unknown_admin',
          adminName: admin?.name ?? 'Unknown Admin',
          actionType: 'GLOBAL_NOTIFICATION',
          targetId: 'all_users',
          description: "Send global notification: $title",
          createdAt: DateTime.now(),
        ),
      );

      // Save notification in Firestore to show in history
      sendNotificationUseCase(
        AppNotification(
          id: const Uuid().v4(),
          title: title,
          body: body,
          type: NotificationType.general,
          sentToAll: true,
          sentAt: DateTime.now(),
          recipientsCount: 0, // Will be updated or left
          isRead: false,
        ),
      );

      emit(const AdminActionSuccess("Notification sent to all users"));
    });
  }

  // Send notification to a specific user manually
  Future<void> sendTargetedNotification({
    required String uId,
    required String name,
    required String title,
    required String body,
    required NotificationType type,
  }) async {
    emit(AdminLoading());

    // Fetch user data to get token
    final userResult = await adminRepo.getUserById(uId);

    await userResult.fold(
      (failure) async => emit(AdminFailure(failure.message)),
      (userEntity) async {
        final notification = AppNotification(
          id: const Uuid().v4(),
          title: title,
          body: body,
          type: type,
          targetUserId: uId,
          targetUserName: name,
          sentToAll: false,
          sentAt: DateTime.now(),
          recipientsCount: 1,
          isRead: false,
          fcmToken: userEntity.fcmToken,
        );

        final result = await sendNotificationUseCase(notification);

        result.fold((failure) => emit(AdminFailure(failure.message)), (_) {
          // Log in admin actions log
          final admin = profileCubit.user;
          adminActionRepo.logAction(
            AdminActionModel(
              id: const Uuid().v4(),
              adminId: admin?.uId ?? 'unknown_admin',
              adminName: admin?.name ?? 'Unknown Admin',
              actionType: 'TARGETED_NOTIFICATION',
              targetId: uId,
              description: "Send private notification to $name: $title",
              createdAt: DateTime.now(),
            ),
          );

          emit(AdminActionSuccess("Notification sent to $name successfully"));
        });
      },
    );
  }

  /// 🔥 Check premium properties that will expire within 24 hours
  Future<void> _checkExpiringPremiums() async {
    try {
      final propertiesResult = await adminRepo.getAllProperties();
      propertiesResult.fold(
        (_) => null,
        (properties) async {
          final now = DateTime.now();
          final reminderThreshold = now.add(const Duration(hours: 24));

          for (var property in properties) {
            if (property.premiumStatus == PremiumStatus.active &&
                property.premiumExpiryDate != null &&
                !property.premiumReminderSent) {
              // If expiry date is before the 24-hour threshold
              if (property.premiumExpiryDate!.isBefore(reminderThreshold)) {
                // 1. Send notification to owner
                _processAction(
                  type: 'PREMIUM_EXPIRING_SOON',
                  targetId: property.id,
                  targetUserId: property.sellerId,
                  description:
                      "Alert: Premium status for your property #${property.id} will expire in less than 24 hours. You can renew now to stay on top.",
                  notificationTitle: "Premium Expiring Soon ⚠️",
                );

                // 2. Update flag in Firestore to prevent repetition
                await getIt<DatabaseService>().updateData(
                  path: BackendEndpoint.getProperty,
                  documentId: property.id,
                  data: {'premiumReminderSent': true},
                );
              }
            }
          }
        },
      );
    } catch (e) {
      // Silent failure for periodic check to avoid annoying admin
    }
  }
}
