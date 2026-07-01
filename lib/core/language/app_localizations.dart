import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_graduation/core/language/app_localizations_delegate.dart';
import 'package:test_graduation/core/language/lang_keys.dart';

class AppLocalizations {
  AppLocalizations(this.locale);
  final Locale locale;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      AppLocalizationsDelegate();

  late Map<String, String> _localizedStrings;

  Future<void> load() async {
    final jsonString = await rootBundle.loadString(
      'lang/${locale.languageCode}.json',
    );

    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;

    _localizedStrings = jsonMap.map<String, String>((key, value) {
      return MapEntry(key, value.toString());
    });
  }

  String translate(String key) => _localizedStrings[key] ?? key;

  bool get isEnLocale => locale.languageCode == 'en';

  // Getters for keys
  String get admin_notifications => translate(LangKeys.adminNotifications);
  String get send_new_notification => translate(LangKeys.sendNewNotification);
  String get notification_title => translate(LangKeys.notificationTitle);
  String get notification_title_hint => translate(LangKeys.notificationTitleHint);
  String get notification_message => translate(LangKeys.notificationMessage);
  String get notification_message_hint => translate(LangKeys.notificationMessageHint);
  String get notification_type => translate(LangKeys.notificationType);
  String get send_to_all_users => translate(LangKeys.sendToAllUsers);
  String get send_to_all_hint => translate(LangKeys.sendToAllHint);
  String get send_to_user_hint => translate(LangKeys.sendToUserHint);
  String get recipient => translate(LangKeys.recipient);
  String get sending => translate(LangKeys.sending);
  String get send_notification => translate(LangKeys.sendNotification);
  String get sent_notifications_history => translate(LangKeys.sentNotificationsHistory);
  String get no_notification_history => translate(LangKeys.noNotificationHistory);
  String get sent_to_all => translate(LangKeys.sentToAll);
  String get sent_to_specific_user => translate(LangKeys.sentToSpecificUser);
  String get select_user_or_all => translate(LangKeys.selectUserOrAll);
  String get notif_type_general => translate(LangKeys.notifTypeGeneral);
  String get notif_type_warning => translate(LangKeys.notifTypeWarning);
  String get notif_type_promotion => translate(LangKeys.notifTypePromotion);
  String get notif_type_update => translate(LangKeys.notifTypeUpdate);
  String get notif_type_report => translate(LangKeys.notifTypeReport);
  String get notif_type_property_featured => translate(LangKeys.notifTypePropertyFeatured);
  String get notif_type_account_status => translate(LangKeys.notifTypeAccountStatus);
  String get notif_type_admin_action => translate(LangKeys.notifTypeAdminAction);
  String get banned_dialog_title => translate(LangKeys.bannedDialogTitle);
  String get banned_dialog_content => translate(LangKeys.bannedDialogContent);
  String get contact_admin_for_help => translate(LangKeys.contactAdminForHelp);
  String get continue_as_guest => translate(LangKeys.continueAsGuest);
  String get retry => translate(LangKeys.retry);
  String get search => translate(LangKeys.search);
  String get syrian_real_estate => translate(LangKeys.syrianRealEstate);
  String get rented => translate(LangKeys.rented);
  String get congratulations_trend => translate(LangKeys.congratulationsTrend);
  String get most_viewed => translate(LangKeys.mostViewed);
  String get premium_status_active_label => translate(LangKeys.premiumStatusActiveLabel);
  String get expiry_date_label => translate(LangKeys.expiryDateLabel);
  String get plan_pro_month => translate(LangKeys.planProMonth);
  String get admin_dashboard_label => translate(LangKeys.adminDashboardLabel);
  String get admin_platform_center => translate(LangKeys.adminPlatformCenter);
  String get vital_indicators => translate(LangKeys.vitalIndicators);
  String get market_composition_analysis => translate(LangKeys.marketCompositionAnalysis);
  String get featured_label => translate(LangKeys.featuredLabel);
  String get normal_label => translate(LangKeys.normal);
  String get market_status => translate(LangKeys.marketStatus);
  String get recent_activity_summary => translate(LangKeys.recentActivitySummary);
  String get control_and_system => translate(LangKeys.controlAndSystem);
  String get audit_logs => translate(LangKeys.auditLogs);
  String get premium_requests => translate(LangKeys.premiumRequests);
  String get financial_wallet => translate(LangKeys.financialWallet);
  String get initializing_data => translate(LangKeys.initializingData);
  String get error_fetching_data => translate(LangKeys.errorFetchingData);
  String get trend_label => translate(LangKeys.trend);
  String get approved_label => translate(LangKeys.approved);
  String get high_activity => translate(LangKeys.highActivity);
  String get trend_rank_label => translate(LangKeys.trendRank);
  String get premium_end => translate(LangKeys.premiumEnd);
  String get delete_property_confirm => translate(LangKeys.deletePropertyConfirm);
  String get confirm_delete => translate(LangKeys.confirmDelete);
  String get disable_property => translate(LangKeys.disableProperty);
  String get approve_property => translate(LangKeys.approveProperty);
  String get hide_property_confirm => translate(LangKeys.hidePropertyConfirm);
  String get show_property_confirm => translate(LangKeys.showPropertyConfirm);
  String get disable_now => translate(LangKeys.disableNow);
  String get approve_and_publish => translate(LangKeys.approveAndPublish);
  String get review_premium_request => translate(LangKeys.reviewPremiumRequest);
  String get selected_plan_pro => translate(LangKeys.selectedPlanPro);
  String get mock_payment_confirmed => translate(LangKeys.mockPaymentConfirmed);
  String get premium_duration_days => translate(LangKeys.premiumDurationDays);
  String get reject_request => translate(LangKeys.rejectRequest);
  String get approve_and_activate => translate(LangKeys.approveAndActivate);
  String get start_review => translate(LangKeys.startReview);
  String get admin_strict_actions => translate(LangKeys.adminStrictActions);
  String get admins_management => translate(LangKeys.adminsManagement);
  String get search_admin_hint => translate(LangKeys.searchAdminHint);
  String get add_new_admin => translate(LangKeys.addNewAdmin);
  String get permission_label => translate(LangKeys.permission);
  String get edit_admin_details => translate(LangKeys.editAdminDetails);
  String get delete_admin => translate(LangKeys.deleteAdmin);
  String get delete_admin_confirm_label => translate(LangKeys.deleteAdminConfirm);
  String get user_not_found_error => translate(LangKeys.userNotFound);
  String get user_details => translate(LangKeys.userDetails);
  String get banned_user => translate(LangKeys.bannedUser);
  String get admin_notes_saved => translate(LangKeys.adminNotesSaved);
  String get property_approved => translate(LangKeys.propertyApproved);
  String get property_unapproved => translate(LangKeys.propertyUnapproved);
  String get property_featured_success => translate(LangKeys.propertyFeaturedSuccess);
  String get feature_removed => translate(LangKeys.featureRemoved);
  String get process_success => translate(LangKeys.processSuccess);
  String get legal_and_contact => translate(LangKeys.legalAndContact);
  String get property_data => translate(LangKeys.propertyData);
  String get geography => translate(LangKeys.geography);
  String get market => translate(LangKeys.market);
  String get platform => translate(LangKeys.platform);
  String get admin_system_engine => translate(LangKeys.adminSystemEngine);
  String get manage_users => translate(LangKeys.manageUsers);
  String get no_matching_users => translate(LangKeys.noMatchingUsers);
  String get search_user_hint => translate(LangKeys.searchUserHint);
  String get admins => translate(LangKeys.admins);
  String get frozen_label => translate(LangKeys.frozen);
  String get reports_management_center => translate(LangKeys.reportsManagementCenter);
  String get no_reports_in_section => translate(LangKeys.noReportsInSection);
  String get property_and_reporter_info => translate(LangKeys.propertyAndReporterInfo);
  String get preview => translate(LangKeys.preview);
  String get reporter => translate(LangKeys.reporter);
  String get regarding_your_report => translate(LangKeys.regardingYourReport);
  String get reported_user => translate(LangKeys.reportedUser);
  String get report_details => translate(LangKeys.reportDetails);
  String get reason_label => translate(LangKeys.reasonLabel);
  String get violation_description => translate(LangKeys.violationDescription);
  String get admin_actions_and_notes => translate(LangKeys.adminActionsAndNotes);
  String get write_admin_notes_hint => translate(LangKeys.writeAdminNotesHint);
  String get full_report_details => translate(LangKeys.fullReportDetails);
  String get confirm_final_block => translate(LangKeys.confirmFinalBlock);
  String get block_user_confirm_msg => translate(LangKeys.blockUserConfirmMsg);
  String get go_back => translate(LangKeys.goBack);
  String get confirm_block => translate(LangKeys.confirmBlock);
  String get make_resolution_decision => translate(LangKeys.makeResolutionDecision);
  String get resolution_decision_msg => translate(LangKeys.resolutionDecisionMsg);
  String get close_report_only => translate(LangKeys.closeReportOnly);
  String get property_deleted_msg => translate(LangKeys.propertyDeletedMsg);
  String get delete_property_now => translate(LangKeys.deletePropertyNow);
  String get manage_properties => translate(LangKeys.manageProperties);
  String get search_property_hint => translate(LangKeys.searchPropertyHint);
  String get currently_featured => translate(LangKeys.currentlyFeatured);
  String get trend_leaders => translate(LangKeys.trendLeaders);
  String get activity_by_city => translate(LangKeys.activityByCity);
  String get property_unit => translate(LangKeys.propertyUnit);
  String get new_users => translate(LangKeys.newUsers);
  String get joined_platform_today => translate(LangKeys.joinedPlatformToday);
  String get pending_approval => translate(LangKeys.pendingApproval);
  String get properties_need_review => translate(LangKeys.propertiesNeedReview);
  String get added_properties => translate(LangKeys.addedProperties);
  String get recently_listed_today => translate(LangKeys.recentlyListedToday);
  String get sales_transactions => translate(LangKeys.salesTransactions);
  String get rent_transactions => translate(LangKeys.rentTransactions);
  String get no_matching_properties => translate(LangKeys.noMatchingProperties);
  String get trend_leaders_30_days => translate(LangKeys.trendLeaders30Days);
  String get error_label => translate(LangKeys.errorLabel);
  String get data_intelligence_center => translate(LangKeys.dataIntelligenceCenter);
  String get today_summary => translate(LangKeys.todaySummary);
  String get users_label => translate(LangKeys.usersLabel);
  String get properties_label => translate(LangKeys.propertiesLabel);
  String get sales_label => translate(LangKeys.salesLabel);
  String get rentals_label => translate(LangKeys.rentalsLabel);
  String get platform_growth_7_days => translate(LangKeys.platformGrowth7Days);
  String get daily_activity_analysis => translate(LangKeys.dailyActivityAnalysis);
  String get real_estate_market_distribution => translate(LangKeys.realEstateMarketDistribution);
  String get smart_control_center => translate(LangKeys.smartControlCenter);
  String get welcome_leader => translate(LangKeys.welcomeLeader);
  String get online_now => translate(LangKeys.onlineNow);
  String get automatic => translate(LangKeys.automatic);
  String get total_users_label => translate(LangKeys.totalUsersLabel);
  String get total_properties_label => translate(LangKeys.totalPropertiesLabel);
  String get active_reports => translate(LangKeys.activeReports);
  String get urgent => translate(LangKeys.urgent);
  String get stable => translate(LangKeys.stable);
  String get estimated_revenue => translate(LangKeys.estimatedRevenue);
  String get total_label => translate(LangKeys.totalLabel);
  String get view_data_for => translate(LangKeys.viewDataFor);
  String get day_filter => translate(LangKeys.dayLabel);
  String get week_filter => translate(LangKeys.weekLabel);
  String get month_filter => translate(LangKeys.monthLabel);
  String get year_filter => translate(LangKeys.yearLabel);
  String get target_id_label => translate(LangKeys.targetIdLabel);
  String get no_logs_found => translate(LangKeys.noLogsFound);
  String get alert_for => translate(LangKeys.alertFor);
  String get specific_user => translate(LangKeys.specificUser);
  String get loading_users => translate(LangKeys.loadingUsers);
  String get financial_wallet_title => translate(LangKeys.financialWalletTitle);
  String get no_financial_transfers => translate(LangKeys.noFinancialTransfers);
  String get total_premium_revenue => translate(LangKeys.totalPremiumRevenue);
  String get monthly_package => translate(LangKeys.monthlyPackage);
  String get weekly_package => translate(LangKeys.weeklyPackage);
  String get growth_analysis => translate(LangKeys.growthAnalysis);
  String get performance_comparison => translate(LangKeys.performanceComparison);

  String get active => translate(LangKeys.active);
  String get sold => translate(LangKeys.sold);
  String get status_pending => translate(LangKeys.statusPending);
  String get status_under_review => translate(LangKeys.statusUnderReview);
  String get status_resolved => translate(LangKeys.statusResolved);
  String get status_rejected => translate(LangKeys.statusRejected);
  String get under_installment => translate(LangKeys.underInstallment);
  String get villas => translate(LangKeys.villas);
  String get buildings => translate(LangKeys.buildings);
  String get houses_and_apartments => translate(LangKeys.housesAndApartments);
  String get under_construction => translate(LangKeys.underConstruction);
  String get shops => translate(LangKeys.shops);
  String get mall_shops => translate(LangKeys.mallShops);
  String get lands => translate(LangKeys.lands);
  String get farms => translate(LangKeys.farms);
  String get pools => translate(LangKeys.pools);
  String get clinics => translate(LangKeys.clinics);
  String get warehouses => translate(LangKeys.warehouses);
  String get halls => translate(LangKeys.halls);
  String get offices => translate(LangKeys.offices);
  String get workshops => translate(LangKeys.workshops);
  String get user_label => translate(LangKeys.userLabel);
  String get sale => translate(LangKeys.sale);
  String get rent => translate(LangKeys.rent);

  // Remaining dashboard getters
  String get status => translate(LangKeys.status);
  String get updateStatus => translate(LangKeys.updateStatus);
  String get sold_properties => translate(LangKeys.soldProperties);
  String get rented_status_desc => translate(LangKeys.rentedStatusDesc);

  // Admin Properties Header Getters
  String get all => translate(LangKeys.all);
  String get for_sale => translate(LangKeys.forSale);
  String get for_rent => translate(LangKeys.forRent);
  String get loading => translate(LangKeys.loading);
  String get last_update => translate(LangKeys.lastUpdate);

  // Missing Admin & Common Getters
  String get property_title => translate(LangKeys.propertyTitle);
  String get delete_property => translate(LangKeys.deleteProperty);
  String get block_user => translate(LangKeys.blockUser);
  String get featured_properties => translate(LangKeys.featuredProperties);
  String get listing_type => translate(LangKeys.listingType);
  String get cancel => translate(LangKeys.cancel);
  String get whatsapp => translate(LangKeys.whatsapp);
  String get view_all => translate(LangKeys.viewAll);
  String get edit => translate(LangKeys.edit);
  String get delete => translate(LangKeys.delete);
  String get name => translate(LangKeys.fullName);
  String get email => translate(LangKeys.email);
  String get register => translate(LangKeys.register);
  String get save => translate(LangKeys.save);
  String get home => translate(LangKeys.home);
  String get notifications => translate(LangKeys.notifications);
  String get mark_all_as_read => translate(LangKeys.markAllAsRead);
  String get no_notifications_currently => translate(LangKeys.noNotificationsCurrently);
  String get please_login_to_view_notifications => translate(LangKeys.pleaseLoginToViewNotifications);
  String get property_featured_title => translate(LangKeys.propertyFeaturedTitle);
  String get promotion_received => translate(LangKeys.promotionReceived);
  String get update_available => translate(LangKeys.updateAvailable);
  String get promotion_rejected => translate(LangKeys.promotionRejected);
  String get log_out => translate(LangKeys.logOut);

  // User Details & Admin Actions
  String get admin_notes => translate(LangKeys.adminNotes);
  String get account_actions => translate(LangKeys.accountActions);
  String get admin_role => translate(LangKeys.adminRole);
  String get user_role => translate(LangKeys.userRole);
  String get no_phone_number => translate(LangKeys.noPhoneNumber);
  String get member_since => translate(LangKeys.memberSince);
  String get member_since_label => translate(LangKeys.memberSince);
  String get phone => translate(LangKeys.phone);
  String get write_notes_hint => translate(LangKeys.writeNotesHint);
  String get save_note => translate(LangKeys.saveNote);
  String get send_email => translate(LangKeys.sendEmail);
  String get unblock_user => translate(LangKeys.unblockUser);
  String get block_account => translate(LangKeys.blockAccount);
  String get send_notification_to_user => translate(LangKeys.sendNotificationToUser);
  String get danger_zone => translate(LangKeys.dangerZone);
  String get delete_user_forever => translate(LangKeys.deleteUserForever);
  String get delete_user_confirm => translate(LangKeys.deleteUserConfirm);

  // Property Actions Tooltips & Msgs
  String get review_premium_request_tooltip => translate(LangKeys.reviewPremiumRequestTooltip);
  String get contact_owner_tooltip => translate(LangKeys.contactOwnerTooltip);
  String get unfeature_property_tooltip => translate(LangKeys.unfeaturePropertyTooltip);
  String get feature_property_tooltip => translate(LangKeys.featurePropertyTooltip);
  String get manage_approval_tooltip => translate(LangKeys.manageApprovalTooltip);
  String get review_request_tooltip => translate(LangKeys.reviewRequestTooltip);
  String get permanent_delete_tooltip => translate(LangKeys.permanentDeleteTooltip);
  String get disable_property_title => translate(LangKeys.disablePropertyTitle);
  String get approve_property_title => translate(LangKeys.approvePropertyTitle);
  String get hide_property_msg => translate(LangKeys.hidePropertyMsg);
  String get show_property_msg => translate(LangKeys.showPropertyMsg);
  String get add_note_to_seller_hint => translate(LangKeys.addNoteToSellerHint);
  String get delete_property_confirm_msg => translate(LangKeys.deletePropertyConfirmMsg);
  String get permanent_delete => translate(LangKeys.permanentDelete);
  String get remaining_time => translate(LangKeys.remainingTime);
  String get settings => translate(LangKeys.settings);
  String get currency_lira => translate(LangKeys.currencyLira);

  // Promotion
  String get promotion_success_title => translate(LangKeys.promotionSuccessTitle);
  String get promotion_processing_msg => translate(LangKeys.promotionProcessingMsg);
  String get link_coming_soon => translate(LangKeys.linkComingSoon);
  String get legal_policies => translate(LangKeys.legalPolicies);
  String get legal_policies_desc => translate(LangKeys.legalPoliciesDesc);
}
