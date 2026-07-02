import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/models/admin_action_model.dart';
import 'package:test_graduation/core/models/notification_model.dart';
import 'package:test_graduation/core/services/data_service.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/features/admin/domain/repos/admin_action_repo.dart';
import 'package:test_graduation/features/admin/domain/repos/admin_repo.dart';
import 'package:test_graduation/features/auth/domain/entites/user_entity.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/notifications/domain/use_cases/send_notification_use_case.dart';
import 'package:test_graduation/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:test_graduation/features/reports/domain/entities/report_entity.dart';
import 'package:uuid/uuid.dart';
import 'package:test_graduation/core/models/financial_record_model.dart';
import 'package:test_graduation/core/utils/backend_endpoint.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/routing/router_generation_config.dart';
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
    String? titleKey, // 🔥 جديد
    String? bodyKey, // 🔥 جديد
    Map<String, dynamic>? bodyArgs, // 🔥 جديد
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
        titleKey: titleKey,
        bodyKey: bodyKey,
        bodyArgs: bodyArgs,
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
    if (isClosed) return;

    final result = await adminRepo.getAdminStats(
      timeFilter: currentFilter,
      targetDate: selectedDate,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(AdminFailure(failure.message)),
      (stats) => emit(AdminStatsSuccess(stats)),
    );
  }

  // 2. Fetch Users (Paginated)
  Future<void> fetchUsers({bool isRefresh = false}) async {
    final currentState = state;
    List<UserEntity> oldUsers = [];

    if (currentState is AdminUsersSuccess && !isRefresh) {
      if (currentState.hasReachedMax) return;
      oldUsers = currentState.users;
    } else {
      emit(AdminLoading());
    }

    final lastDoc = isRefresh || oldUsers.isEmpty
        ? null
        : oldUsers.last.lastDocSnapshot;

    final result = await adminRepo.getPaginatedUsers(
      limit: 20,
      lastDoc: lastDoc,
    );

    if (isClosed) return;

    result.fold((failure) => emit(AdminFailure(failure.message)), (newUsers) {
      final List<UserEntity> users = isRefresh
          ? newUsers
          : [...oldUsers, ...newUsers];
      emit(AdminUsersSuccess(users, hasReachedMax: newUsers.length < 20));
    });
  }

  // Search Users
  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      fetchUsers(isRefresh: true);
      return;
    }

    emit(AdminLoading());
    final result = await adminRepo.searchUsers(query);

    if (isClosed) return;

    result.fold(
      (failure) => emit(AdminFailure(failure.message)),
      (users) => emit(AdminUsersSuccess(users, hasReachedMax: true)),
    );
  }

  // 3. Block/Unblock User (Optimistic UI)
  Future<void> toggleUserBlock(String uId, bool isBlocked) async {
    final currentState = state;
    List<UserEntity>? originalUsers;

    // 🔥 تحديث الواجهة فوراً (Optimistic)
    if (currentState is AdminUsersSuccess) {
      originalUsers = List.from(currentState.users);
      final updatedUsers = currentState.users.map((u) {
        if (u.uId == uId)
          return u.copyWith(status: isBlocked ? 'banned' : 'active');
        return u;
      }).toList();
      emit(
        AdminUsersSuccess(
          updatedUsers,
          hasReachedMax: currentState.hasReachedMax,
        ),
      );
    }

    final result = await adminRepo.blockUser(uId: uId, block: isBlocked);

    if (isClosed) return;

    result.fold(
      (failure) {
        // 🔙 تراجع عن التعديل في حال الفشل
        if (originalUsers != null && currentState is AdminUsersSuccess) {
          emit(
            AdminUsersSuccess(
              originalUsers,
              hasReachedMax: currentState.hasReachedMax,
            ),
          );
        }
        emit(AdminFailure(failure.message));
      },
      (_) {
        final desc = isBlocked
            ? "عذراً، لقد تم حظر حسابك من قبل الإدارة لمخالفة معايير الاستخدام. يرجى التواصل مع الإدارة للاستفسار."
            : "تم إلغاء حظر حسابك بنجاح، يمكنك الآن تسجيل الدخول واستخدام التطبيق كالمعتاد.";
        _processAction(
          type: isBlocked ? 'BLOCK_USER' : 'UNBLOCK_USER',
          targetId: uId,
          targetUserId: uId,
          description: desc,
          notificationTitle: isBlocked
              ? "تنبيه: حظر الحساب"
              : "تم فك الحظر عن حسابك",
        );

        // 🔥 تحديث الحالة محلياً للمشرف ليرى التغيير فوراً في الواجهة
        if (state is AdminUsersSuccess) {
          final users = (state as AdminUsersSuccess).users.map((u) {
            if (u.uId == uId)
              return u.copyWith(status: isBlocked ? 'banned' : 'active');
            return u;
          }).toList();
          emit(
            AdminUsersSuccess(
              users,
              hasReachedMax: (state as AdminUsersSuccess).hasReachedMax,
              message: isBlocked
                  ? "تم حظر المستخدم بنجاح"
                  : "تم إلغاء الحظر بنجاح",
            ),
          );
        } else {
          emit(
            AdminActionSuccess(
              isBlocked ? "تم الحظر بنجاح" : "تم إلغاء الحظر بنجاح",
            ),
          );
        }
      },
    );
  }

  // 4. Delete User (Optimistic UI)
  Future<void> deleteUser(String uId) async {
    final currentState = state;
    List<UserEntity>? originalUsers;

    // 🔥 حذف من الواجهة فوراً
    if (currentState is AdminUsersSuccess) {
      originalUsers = List.from(currentState.users);
      final updatedUsers = currentState.users
          .where((u) => u.uId != uId)
          .toList();
      emit(
        AdminUsersSuccess(
          updatedUsers,
          hasReachedMax: currentState.hasReachedMax,
        ),
      );
    }

    final result = await adminRepo.deleteUser(uId: uId);

    if (isClosed) return;

    result.fold(
      (failure) {
        if (originalUsers != null && currentState is AdminUsersSuccess) {
          emit(
            AdminUsersSuccess(
              originalUsers,
              hasReachedMax: currentState.hasReachedMax,
            ),
          );
        }
        emit(AdminFailure(failure.message));
      },
      (_) {
        final desc = "User account marked as deleted: $uId";
        _processAction(
          type: 'DELETE_USER',
          targetId: uId,
          targetUserId: uId,
          description: desc,
          notificationTitle: "تنبيه: حذف الحساب",
        );

        // 🔥 تحديث الحالة محلياً للمشرف ليختفي المستخدم فوراً
        if (state is AdminUsersSuccess) {
          final users = (state as AdminUsersSuccess).users
              .where((u) => u.uId != uId)
              .toList();
          emit(
            AdminUsersSuccess(
              users,
              hasReachedMax: (state as AdminUsersSuccess).hasReachedMax,
              message: "تم حذف المستخدم بنجاح",
            ),
          );
        } else {
          emit(const AdminActionSuccess("تم حذف المستخدم بنجاح"));
        }
      },
    );
  }

  // 5. Update Admin Notes
  Future<void> updateAdminNotes(String uId, String notes) async {
    final result = await adminRepo.updateAdminNotes(uId: uId, notes: notes);
    if (isClosed) return;
    result.fold((failure) => emit(AdminFailure(failure.message)), (_) {
      emit(
        AdminUsersSuccess(
          (state as AdminUsersSuccess).users,
          hasReachedMax: (state as AdminUsersSuccess).hasReachedMax,
          message: "Admin notes saved",
        ),
      );
    });
  }

  // 6. Fetch Properties (Paginated)
  Future<void> fetchProperties({bool isRefresh = false}) async {
    final currentState = state;
    List<PropertyEntity> oldProps = [];

    if (currentState is AdminPropertiesSuccess && !isRefresh) {
      if (currentState.hasReachedMax) return;
      oldProps = currentState.properties;
    } else {
      emit(AdminLoading());
    }

    final lastDoc = isRefresh || oldProps.isEmpty
        ? null
        : oldProps.last.lastDocSnapshot;

    final result = await adminRepo.getPaginatedProperties(
      limit: 20,
      lastDoc: lastDoc,
    );

    if (isClosed) return;

    result.fold((failure) => emit(AdminFailure(failure.message)), (newProps) {
      final List<PropertyEntity> props = isRefresh
          ? newProps
          : [...oldProps, ...newProps];
      emit(AdminPropertiesSuccess(props, hasReachedMax: newProps.length < 20));
    });
  }

  // 7. Toggle Property Approval (Optimistic UI)
  Future<void> togglePropertyApproval(
    String id,
    bool isApproved,
    String sellerId,
  ) async {
    final currentState = state;
    List<PropertyEntity>? originalProps;

    if (currentState is AdminPropertiesSuccess) {
      originalProps = List.from(currentState.properties);
      final updatedProps = currentState.properties.map((p) {
        if (p.id == id) return p.copyWith(isApproved: isApproved);
        return p;
      }).toList();
      emit(
        AdminPropertiesSuccess(
          updatedProps,
          hasReachedMax: currentState.hasReachedMax,
        ),
      );
    }

    final result = await adminRepo.togglePropertyApproval(
      propertyId: id,
      isApproved: isApproved,
    );
    if (isClosed) return;
    result.fold(
      (failure) {
        if (originalProps != null && currentState is AdminPropertiesSuccess) {
          emit(
            AdminPropertiesSuccess(
              originalProps,
              hasReachedMax: currentState.hasReachedMax,
            ),
          );
        }
        emit(AdminFailure(failure.message));
      },
      (_) {
        final context = RouterGenerationConfig.navigatorKey.currentContext;
        final local = context != null ? AppLocalizations.of(context) : null;

        final String title;
        final String body;
        final String? titleKey;
        final String? bodyKey;

        if (isApproved) {
          title =
              local?.property_activated_notification_title ??
              "تم تفعيل العقار ✅";
          body =
              (local?.property_activated_notification_body ??
                      "تم تفعيل عرض عقارك #{id} من قبل الإدارة...")
                  .replaceFirst("#{id}", id);
          titleKey = LangKeys.propertyActivatedNotificationTitle;
          bodyKey = LangKeys.propertyActivatedNotificationBody;
        } else {
          title =
              local?.property_disabled_notification_title ??
              "تم تعطيل العقار ⚠️";
          body =
              (local?.property_disabled_notification_body ??
                      "تم تعطيل عرض عقارك #{id} من قبل الإدارة...")
                  .replaceFirst("#{id}", id);
          titleKey = LangKeys.propertyDisabledNotificationTitle;
          bodyKey = LangKeys.propertyDisabledNotificationBody;
        }

        _processAction(
          type: 'CHANGE_STATUS',
          targetId: id,
          targetUserId: sellerId,
          description: body,
          notificationTitle: title,
          titleKey: titleKey,
          bodyKey: bodyKey,
          bodyArgs: {'id': id},
        );
        if (state is AdminPropertiesSuccess) {
          emit(
            AdminPropertiesSuccess(
              (state as AdminPropertiesSuccess).properties,
              hasReachedMax: (state as AdminPropertiesSuccess).hasReachedMax,
              message: isApproved
                  ? "Property Approved"
                  : "Property Approval Cancelled",
            ),
          );
        }
      },
    );
  }

  // 8. Toggle Featured (Optimistic UI)
  Future<void> togglePropertyFeatured(
    String id,
    bool isFeatured,
    String sellerId,
  ) async {
    final currentState = state;
    List<PropertyEntity>? originalProps;

    if (currentState is AdminPropertiesSuccess) {
      originalProps = List.from(currentState.properties);
      final updatedProps = currentState.properties.map((p) {
        if (p.id == id) return p.copyWith(isFeatured: isFeatured);
        return p;
      }).toList();
      emit(
        AdminPropertiesSuccess(
          updatedProps,
          hasReachedMax: currentState.hasReachedMax,
        ),
      );
    }

    final result = await adminRepo.togglePropertyFeatured(
      propertyId: id,
      isFeatured: isFeatured,
    );
    if (isClosed) return;
    result.fold(
      (failure) {
        if (originalProps != null && currentState is AdminPropertiesSuccess) {
          emit(
            AdminPropertiesSuccess(
              originalProps,
              hasReachedMax: currentState.hasReachedMax,
            ),
          );
        }
        emit(AdminFailure(failure.message));
      },
      (_) {
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
        if (state is AdminPropertiesSuccess) {
          emit(
            AdminPropertiesSuccess(
              (state as AdminPropertiesSuccess).properties,
              hasReachedMax: (state as AdminPropertiesSuccess).hasReachedMax,
              message: isFeatured
                  ? "Property featured successfully"
                  : "Feature removed",
            ),
          );
        }
      },
    );
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
      // Logic for detection: Use default if not found in property
      int finalDays = days ?? 7;
      double finalAmount = amount ?? 0;

      // 0. Fetch property details
      String propTitle = 'Property';
      final propData = await getIt<DatabaseService>().getData(
        path: BackendEndpoint.getProperty,
        documentId: propertyId,
      );

      if (propData != null) {
        propTitle = propData['title'] as String? ?? 'Property';

        // 🔥 Smart detection:
        if (propData['requestedPremiumDays'] != null) {
          finalDays = propData['requestedPremiumDays'] as int;
        }
        if (propData['requestedPremiumAmount'] != null) {
          finalAmount = (propData['requestedPremiumAmount'] as num).toDouble();
        }
      }

      final expiryDate = DateTime.now().add(Duration(days: finalDays));

      // 1. Update property status in Firestore
      await adminRepo.togglePropertyFeatured(
        propertyId: propertyId,
        isFeatured: true,
      );
      if (isClosed) return;
      await getIt<DatabaseService>().updateData(
        path: BackendEndpoint.getProperty,
        documentId: propertyId,
        data: {
          'premiumStatus': PremiumStatus.active.name,
          'premiumExpiryDate': expiryDate.toIso8601String(),
          'premiumReminderSent': false,
          'isFeatured': true,
          'requestedPremiumAmount': FieldValue.delete(),
          'requestedPremiumDays': FieldValue.delete(),
        },
      );
      if (isClosed) return;

      // 2. Financial transaction log
      final financialRecord = FinancialRecordModel(
        id: const Uuid().v4(),
        propertyId: propertyId,
        propertyTitle: propTitle,
        sellerId: sellerId,
        sellerName: sellerName ?? 'User',
        amount: finalAmount,
        currency: propData?['currency'] ?? 'SYP', // 🔥 جلب العملة من العقار أو الافتراضي
        type: (finalDays >= 30)
            ? TransactionType.promotionMonthly
            : TransactionType.promotionWeekly,
        createdAt: DateTime.now(),
      );

      await getIt<DatabaseService>().addData(
        path: BackendEndpoint.financialTransfers,
        data: financialRecord.toJson(),
      );
      if (isClosed) return;

      // 3. Send notification to user
      final context = RouterGenerationConfig.navigatorKey.currentContext;
      final local = context != null ? AppLocalizations.of(context) : null;

      final title =
          local?.premium_activated_notification_title ?? "تم تفعيل التميز 🚀";
      final body =
          (local?.premium_activated_notification_body ??
                  "تهانينا! تمت الموافقة على طلب التميز لعقارك ({title})...")
              .replaceFirst("{title}", propTitle)
              .replaceFirst("{days}", finalDays.toString());

      _processAction(
        type: 'PREMIUM_APPROVED',
        targetId: propertyId,
        targetUserId: sellerId,
        description: body,
        notificationTitle: title,
        titleKey: LangKeys.premiumActivatedNotificationTitle,
        bodyKey: LangKeys.premiumActivatedNotificationBody,
        bodyArgs: {'title': propTitle, 'days': finalDays.toString()},
      );
    } else {
      // Rejection case
      await getIt<DatabaseService>().updateData(
        path: BackendEndpoint.getProperty,
        documentId: propertyId,
        data: {
          'premiumStatus': PremiumStatus.rejected.name,
          'requestedPremiumAmount': FieldValue.delete(),
          'requestedPremiumDays': FieldValue.delete(),
        },
      );
      if (isClosed) return;

      final context = RouterGenerationConfig.navigatorKey.currentContext;
      final local = context != null ? AppLocalizations.of(context) : null;

      final title =
          local?.premium_rejected_notification_title ?? "رفض طلب التميز ❌";
      final body =
          (local?.premium_rejected_notification_body ??
                  "نعتذر، تم رفض طلب التميز لعقارك (#{id})...")
              .replaceFirst("#{id}", propertyId);

      _processAction(
        type: 'PREMIUM_REJECTED',
        targetId: propertyId,
        targetUserId: sellerId,
        description: body,
        notificationTitle: title,
        titleKey: LangKeys.premiumRejectedNotificationTitle,
        bodyKey: LangKeys.premiumRejectedNotificationBody,
        bodyArgs: {'id': propertyId},
      );
    }

    emit(const AdminActionSuccess("Request processed successfully"));
    fetchProperties();
  }

  // 9. Delete Property (Optimistic UI)
  Future<void> deleteProperty(String id, String sellerId) async {
    final currentState = state;
    List<PropertyEntity>? originalProps;

    if (currentState is AdminPropertiesSuccess) {
      originalProps = List.from(currentState.properties);
      final updatedProps = currentState.properties
          .where((p) => p.id != id)
          .toList();
      emit(
        AdminPropertiesSuccess(
          updatedProps,
          hasReachedMax: currentState.hasReachedMax,
        ),
      );
    }

    final result = await adminRepo.deleteProperty(propertyId: id);
    if (isClosed) return;
    result.fold(
      (failure) {
        if (originalProps != null && currentState is AdminPropertiesSuccess) {
          emit(
            AdminPropertiesSuccess(
              originalProps,
              hasReachedMax: currentState.hasReachedMax,
            ),
          );
        }
        emit(AdminFailure(failure.message));
      },
      (_) {
        final context = RouterGenerationConfig.navigatorKey.currentContext;
        final local = context != null ? AppLocalizations.of(context) : null;

        final title =
            local?.property_deleted_notification_title ?? "تنبيه: حذف عقار ❌";
        final body =
            (local?.property_deleted_notification_body ??
                    "تم حذف عقارك #{id} نهائياً...")
                .replaceFirst("#{id}", id);

        _processAction(
          type: 'DELETE_PROPERTY',
          targetId: id,
          targetUserId: sellerId,
          description: body,
          notificationTitle: title,
          titleKey: LangKeys.propertyDeletedNotificationTitle,
          bodyKey: LangKeys.propertyDeletedNotificationBody,
          bodyArgs: {'id': id},
        );
        if (state is AdminPropertiesSuccess) {
          emit(
            AdminPropertiesSuccess(
              (state as AdminPropertiesSuccess).properties,
              hasReachedMax: (state as AdminPropertiesSuccess).hasReachedMax,
              message: "Property deleted successfully",
            ),
          );
        }
      },
    );
  }

  // 10. Fetch Reports (Paginated)
  Future<void> fetchReports({bool isRefresh = false}) async {
    final currentState = state;
    List<ReportEntity> oldReports = [];

    if (currentState is AdminReportsSuccess && !isRefresh) {
      if (currentState.hasReachedMax) return;
      oldReports = currentState.reports;
    } else {
      emit(AdminLoading());
    }

    final lastDoc = isRefresh || oldReports.isEmpty
        ? null
        : oldReports.last.lastDocSnapshot;

    final result = await adminRepo.getPaginatedReports(
      limit: 20,
      lastDoc: lastDoc,
    );

    if (isClosed) return;

    result.fold((failure) => emit(AdminFailure(failure.message)), (newReports) {
      final List<ReportEntity> reports = isRefresh
          ? newReports
          : [...oldReports, ...newReports];
      emit(AdminReportsSuccess(reports, hasReachedMax: newReports.length < 20));
    });
  }

  // 11. Update Report Status (Optimistic UI)
  Future<void> updateReportStatus(
    String id,
    String status, {
    String? adminNote,
    String? reporterId,
  }) async {
    final currentState = state;
    List<ReportEntity>? originalReports;

    if (currentState is AdminReportsSuccess) {
      originalReports = List.from(currentState.reports);
      final updatedReports = currentState.reports.map((r) {
        if (r.id == id) {
          return r.copyWith(
            status: ReportStatus.values.firstWhere((e) => e.name == status),
            adminNote: adminNote,
          );
        }
        return r;
      }).toList();
      emit(
        AdminReportsSuccess(
          updatedReports,
          hasReachedMax: currentState.hasReachedMax,
        ),
      );
    }

    final result = await adminRepo.updateReportStatus(
      reportId: id,
      status: status,
      adminNote: adminNote,
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        if (originalReports != null && currentState is AdminReportsSuccess) {
          emit(
            AdminReportsSuccess(
              originalReports,
              hasReachedMax: currentState.hasReachedMax,
            ),
          );
        }
        emit(AdminFailure(failure.message));
      },
      (_) {
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
        if (state is AdminReportsSuccess) {
          emit(
            AdminReportsSuccess(
              (state as AdminReportsSuccess).reports,
              hasReachedMax: (state as AdminReportsSuccess).hasReachedMax,
              message: "Report status updated successfully",
            ),
          );
        }
      },
    );
  }

  // 12. Send Global Notification
  Future<void> sendNotification(String title, String body) async {
    emit(AdminLoading());
    final result = await adminRepo.sendGlobalNotification(
      title: title,
      body: body,
    );
    if (isClosed) return;
    result.fold((failure) => emit(AdminFailure(failure.message)), (_) async {
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
      await sendNotificationUseCase(
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
    if (isClosed) return;

    await userResult.fold(
      (failure) async {
        if (!isClosed) emit(AdminFailure(failure.message));
      },
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
        if (isClosed) return;

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
      propertiesResult.fold((_) => null, (properties) async {
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
      });
    } catch (e) {
      // Silent failure for periodic check to avoid annoying admin
    }
  }
}
