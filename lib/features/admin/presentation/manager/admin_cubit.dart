import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/models/admin_action_model.dart';
import 'package:test_graduation/core/models/notification_model.dart';
import 'package:test_graduation/features/admin/domain/repos/admin_action_repo.dart';
import 'package:test_graduation/features/admin/domain/repos/admin_repo.dart';
import 'package:test_graduation/features/notifications/domain/use_cases/send_notification_use_case.dart';
import 'package:uuid/uuid.dart';
import 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  final AdminRepo adminRepo;
  final AdminActionRepo adminActionRepo;
  final SendNotificationUseCase sendNotificationUseCase;

  AdminCubit(this.adminRepo, this.adminActionRepo, this.sendNotificationUseCase)
      : super(AdminInitial());

  String currentFilter = 'week';
  DateTime selectedDate = DateTime.now();

  // Helper to log actions and send notifications to users
  void _processAction({
    required String type,
    required String targetId,
    required String description,
    String? targetUserId,
    String? notificationTitle,
  }) {
    // 1. Log Action (Internal Admin Log)
    adminActionRepo.logAction(AdminActionModel(
      id: const Uuid().v4(),
      adminId: 'current_admin_id',
      adminName: 'المسؤول',
      actionType: type,
      targetId: targetId,
      description: description,
      createdAt: DateTime.now(),
    ));

    // 2. Send Notification to User (If targetUserId is provided)
    if (targetUserId != null) {
      sendNotificationUseCase(AppNotification(
        id: const Uuid().v4(),
        title: notificationTitle ?? "تنبيه من الإدارة",
        body: description,
        type: NotificationType.adminAction,
        targetUserId: targetUserId,
        sentToAll: false,
        sentAt: DateTime.now(),
        recipientsCount: 1,
        isRead: false,
      ));
    }
  }

  // 1. Fetch Dashboard Stats
  Future<void> getStats({String? filter, DateTime? date}) async {
    if (filter != null) currentFilter = filter;
    if (date != null) selectedDate = date;
    
    emit(AdminLoading());
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
          ? "تم حظر حسابك من قبل الإدارة لمخالفة الشروط"
          : "تم فك الحظر عن حسابك، يمكنك استخدامه الآن";
      _processAction(
        type: 'BLOCK_USER',
        targetId: uId,
        targetUserId: uId,
        description: desc,
        notificationTitle: isBlocked ? "حظر الحساب" : "فك حظر الحساب",
      );
      emit(const AdminActionSuccess("تم تحديث حالة المستخدم بنجاح"));
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
        description: "تم حذف حساب المستخدم بشكل نهائي: $uId",
      );
      emit(const AdminActionSuccess("تم حذف المستخدم بنجاح"));
      fetchUsers();
    });
  }

  // 5. Update Admin Notes
  Future<void> updateAdminNotes(String uId, String notes) async {
    final result = await adminRepo.updateAdminNotes(uId: uId, notes: notes);
    result.fold((failure) => emit(AdminFailure(failure.message)), (_) {
      emit(const AdminActionSuccess("تم حفظ الملاحظات الإدارية"));
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
      String id, bool isApproved, String sellerId) async {
    final result = await adminRepo.togglePropertyApproval(
      propertyId: id,
      isApproved: isApproved,
    );
    result.fold((failure) => emit(AdminFailure(failure.message)), (_) {
      final desc = isApproved
          ? "تمت الموافقة على نشر عقارك رقم $id"
          : "تم رفض نشر عقارك رقم $id، يرجى مراجعة التفاصيل";
      _processAction(
        type: 'CHANGE_STATUS',
        targetId: id,
        targetUserId: sellerId,
        description: desc,
        notificationTitle: isApproved ? "تم قبول العقار" : "تم رفض العقار",
      );
      emit(
        AdminActionSuccess(
          isApproved ? "تم اعتماد العقار" : "تم إلغاء اعتماد العقار",
        ),
      );
      fetchProperties();
    });
  }

  // 8. Toggle Featured (Synced with UI)
  Future<void> togglePropertyFeatured(String id, bool isFeatured) async {
    final result = await adminRepo.togglePropertyFeatured(
      propertyId: id,
      isFeatured: isFeatured,
    );
    result.fold((failure) => emit(AdminFailure(failure.message)), (_) {
      _processAction(
        type: 'FEATURE_PROPERTY',
        targetId: id,
        description: isFeatured
            ? "تم وضع العقار $id في القائمة المميزة"
            : "تم إزالة العقار $id من القائمة المميزة",
      );
      emit(
        AdminActionSuccess(
          isFeatured ? "تم تمييز العقار بنجاح" : "تم إزالة التميز",
        ),
      );
      fetchProperties();
    });
  }

  // 9. Delete Property
  Future<void> deleteProperty(String id, String sellerId) async {
    final result = await adminRepo.deleteProperty(propertyId: id);
    result.fold((failure) => emit(AdminFailure(failure.message)), (_) {
      _processAction(
        type: 'DELETE_PROPERTY',
        targetId: id,
        targetUserId: sellerId,
        description: "تم حذف العقار رقم $id لمخالفته المعايير",
        notificationTitle: "حذف عقار",
      );
      emit(const AdminActionSuccess("تم حذف العقار بنجاح"));
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
  }) async {
    emit(AdminLoading());
    final result = await adminRepo.updateReportStatus(
      reportId: id,
      status: status,
      adminNote: adminNote,
    );
    result.fold((failure) => emit(AdminFailure(failure.message)), (_) {
      _processAction(
        type: 'UPDATE_REPORT',
        targetId: id,
        description: "تم تحديث حالة البلاغ $id إلى $status",
      );
      emit(const AdminActionSuccess("تم تحديث حالة البلاغ بنجاح"));
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
    result.fold(
      (failure) => emit(AdminFailure(failure.message)),
      (_) =>
          emit(const AdminActionSuccess("تم إرسال الإشعار لجميع المستخدمين")),
    );
  }
}
