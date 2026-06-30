import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';

enum PropertyType {
  buildings,
  housesAndApartments,
  underConstruction,
  villas,
  shops,
  mallShops,
  lands,
  farms,
  pools,
  clinics,
  warehouses,
  halls,
  offices,
  workshops,
}

enum Currency { usd, tryCurrency }

class CurrencyHelper {
  static String localize(BuildContext context, String currency) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) return currency;

    final trimmedCurrency = currency.trim().toUpperCase();

    // Map common currency strings to translation keys
    if (trimmedCurrency == 'SYP' || trimmedCurrency == 'ل.س') {
      return localizations.translate(LangKeys.currencyLira);
    } else if (trimmedCurrency == 'USD' || trimmedCurrency == 'دولار أمريكي') {
      return localizations.translate(LangKeys.usd);
    } else if (trimmedCurrency == 'TRY' || trimmedCurrency == 'ليرة تركية') {
      return localizations.translate(LangKeys.tryCurrency);
    }

    return currency;
  }
}

enum ListingType { sale, rent }

enum PropertyStatus { active, sold, rented, underInstallment }

enum PremiumStatus { none, pending, active, rejected } // 🔥 حالات التميز الجديدة

extension PropertyStatusExtension on PropertyStatus {
  String localizedName(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) return name; // fallback to enum name string

    switch (this) {
      case PropertyStatus.active:
        return localizations.translate(LangKeys.active);
      case PropertyStatus.sold:
        return localizations.translate(LangKeys.sold);
      case PropertyStatus.rented:
        return localizations.translate(LangKeys.rented);
      case PropertyStatus.underInstallment:
        return localizations.translate(LangKeys.underInstallment);
    }
  }
}

extension PropertyTypeExtension on PropertyType {
  String localizedName(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) return name;

    switch (this) {
      case PropertyType.buildings:
        return localizations.translate(LangKeys.buildings);
      case PropertyType.housesAndApartments:
        return localizations.translate(LangKeys.housesAndApartments);
      case PropertyType.underConstruction:
        return localizations.translate(LangKeys.underConstruction);
      case PropertyType.villas:
        return localizations.translate(LangKeys.villas);
      case PropertyType.shops:
        return localizations.translate(LangKeys.shops);
      case PropertyType.mallShops:
        return localizations.translate(LangKeys.mallShops);
      case PropertyType.lands:
        return localizations.translate(LangKeys.lands);
      case PropertyType.farms:
        return localizations.translate(LangKeys.farms);
      case PropertyType.pools:
        return localizations.translate(LangKeys.pools);
      case PropertyType.clinics:
        return localizations.translate(LangKeys.clinics);
      case PropertyType.warehouses:
        return localizations.translate(LangKeys.warehouses);
      case PropertyType.halls:
        return localizations.translate(LangKeys.halls);
      case PropertyType.offices:
        return localizations.translate(LangKeys.offices);
      case PropertyType.workshops:
        return localizations.translate(LangKeys.workshops);
    }
  }
}

extension ListingTypeExtension on ListingType {
  String localizedName(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) return name;

    switch (this) {
      case ListingType.sale:
        return localizations.translate(LangKeys.sale);
      case ListingType.rent:
        return localizations.translate(LangKeys.rent);
    }
  }
}
