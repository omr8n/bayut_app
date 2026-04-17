import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/models/admin_action_model.dart';
import 'package:test_graduation/features/admin/domain/repos/admin_action_repo.dart';
import 'package:test_graduation/features/admin/domain/repos/admin_repo.dart';
import 'package:uuid/uuid.dart';
import 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  final AdminRepo adminRepo;
  final AdminActionRepo adminActionRepo;

  AdminCubit(this.adminRepo, this.adminActionRepo) : super(AdminInitial());

  String currentFilter = 'week';
  DateTime selectedDate = DateTime.now();

  // Helper to log actions
  void _log(String type, String targetId, String description) {
    adminActionRepo.logAction(AdminActionModel(
      id: const Uuid().v4(),
      adminId: 'current_admin_id', // TODO: Get from AuthCubit/UserEntity
      adminName: 'المسؤول', 
      actionType: type,
      targetId: targetId,
      description: description,
      createdAt: DateTime.now(),
    ));
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
      _log(
        'BLOCK_USER',
        uId,
        isBlocked ? "تم حظر المستخدم صاحب المعرف $uId" : "تم فك حظر المستخدم صاحب المعرف $uId",
      );
      emit(const AdminActionSuccess("تم تحديث حالة المستخدم بنجاح"));
      fetchUsers();
    });
  }

  // 4. Delete User
  Future<void> deleteUser(String uId) async {
    final result = await adminRepo.deleteUser(uId: uId);
    result.fold((failure) => emit(AdminFailure(failure.message)), (_) {
      _log('DELETE_USER', uId, "تم حذف حساب المستخدم بشكل نهائي: $uId");
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
  Future<void> togglePropertyApproval(String id, bool isApproved) async {
    final result = await adminRepo.togglePropertyApproval(
      propertyId: id,
      isApproved: isApproved,
    );
    result.fold((failure) => emit(AdminFailure(failure.message)), (_) {
      _log(
        'CHANGE_STATUS',
        id,
        isApproved ? "تمت الموافقة على نشر العقار $id" : "تم إلغاء الموافقة على العقار $id",
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
      _log(
        'FEATURE_PROPERTY',
        id,
        isFeatured ? "تم وضع العقار $id في القائمة المميزة" : "تم إزالة العقار $id من القائمة المميزة",
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
  Future<void> deleteProperty(String id) async {
    final result = await adminRepo.deleteProperty(propertyId: id);
    result.fold((failure) => emit(AdminFailure(failure.message)), (_) {
      _log('DELETE_PROPERTY', id, "تم حذف العقار رقم $id لمخالفته المعايير");
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
      _log('UPDATE_REPORT', id, "تم تحديث حالة البلاغ $id إلى $status");
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
