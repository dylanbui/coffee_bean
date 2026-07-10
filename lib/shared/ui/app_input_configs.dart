import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';

/// Coffee Bean specific input configurations using TMLabs design system.
class CoffeeInputStyles {
  
  /// Standard outline style for forms.
  static AppInputStyleConfig get outline => AppInputStyleConfig(
    borderStyle: AppInputBorderStyle.outline,
    labelStyle: TMLabsTextStyle.body.copyWith(
      fontWeight: FontWeight.bold, 
      color: TMLabsColor.primary,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    enabledBorderColor: TMLabsColor.accent.withValues(alpha: 0.1),
    focusedBorderColor: TMLabsColor.primary,
    borderRadius: 8.0,
  );

  /// Elegant underline style.
  static AppInputStyleConfig get underline => AppInputStyleConfig(
    borderStyle: AppInputBorderStyle.underline,
    labelStyle: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
    labelSpacing: 4.0,
    enabledBorderColor: TMLabsColor.grey.withValues(alpha: 0.3),
    focusedBorderColor: TMLabsColor.primary,
  );

  /// Modern filled style for search or comments.
  static AppInputStyleConfig get filled => AppInputStyleConfig(
    borderStyle: AppInputBorderStyle.filled,
    backgroundColor: TMLabsColor.accent.withValues(alpha: 0.1),
    borderRadius: 12.0,
    enabledBorderColor: TMLabsColor.accent.withValues(alpha: 0.5),
    focusedBorderColor: TMLabsColor.accent.withValues(alpha: 0.8),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    labelStyle: TMLabsTextStyle.body.copyWith(
      fontWeight: FontWeight.bold,
      color: TMLabsColor.primary,
    ),
  );
}
