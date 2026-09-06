import 'package:flutter/material.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/store_page/domain/provider_profile_completion_status.dart';

Future<bool> showProviderProfileCompletionDialog({
  required BuildContext context,
  required ProviderProfileCompletionStatus status,
}) async {
  final messageKey = switch (status.destination) {
    ProviderProfileCompletionDestination.myAccount =>
      AppLanguageKeys.missingBranchAndWorkingHoursForBooking,
    ProviderProfileCompletionDestination.branches =>
      AppLanguageKeys.missingBranchForBooking,
    ProviderProfileCompletionDestination.workingHours =>
      AppLanguageKeys.missingWorkingHoursForBooking,
  };

  final actionKey = switch (status.destination) {
    ProviderProfileCompletionDestination.myAccount =>
      AppLanguageKeys.goToMyAccount,
    ProviderProfileCompletionDestination.branches =>
      AppLanguageKeys.goToBranches,
    ProviderProfileCompletionDestination.workingHours =>
      AppLanguageKeys.goToWorkingHours,
  };

  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            icon: const Icon(
              Icons.info_outline_rounded,
              color: AppColors.orangeColor,
              size: 40,
            ),
            title: const TextInAppWidget(
              text: AppLanguageKeys.bookingSetupRequired,
              textAlign: TextAlign.center,
              textSize: 20,
              fontWeightIndex: FontSelectionData.semiBoldFontFamily,
            ),
            content: TextInAppWidget(
              text: messageKey,
              textAlign: TextAlign.center,
              textSize: 16,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const TextInAppWidget(
                  text: AppLanguageKeys.cancel,
                  textSize: 14,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orangeColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: TextInAppWidget(
                  text: actionKey,
                  textSize: 14,
                  textColor: Colors.white,
                ),
              ),
            ],
          );
        },
      ) ??
      false;
}
