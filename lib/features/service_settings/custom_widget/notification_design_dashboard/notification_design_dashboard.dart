import 'package:flutter/cupertino.dart';
import '../../../../../../features/service_settings/custom_widget/row_list_notification_design_dashboard_widget.dart';
import '../../../../../../core/theming/assets.dart';
import '../../../../../../features/service_settings/custom_widget/notification_design_dashboard/screens/first_row_in_notification_design_dashboard.dart';
import '../../../../../../../core/language/language_constant.dart';

class NotificationDesignDashboard extends StatelessWidget {
  const NotificationDesignDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 500,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FirstRowInNotificationDesignDashboard(),
            RowListNotificationDesignDashboardWidget(
              imagePath: AppImageKeys.service33,
              textBlack: AppLanguageKeys.maintenanceAndRepair,
              textOrange: AppLanguageKeys.internalServices,
              numberRequest: '#545212',
            ),
            RowListNotificationDesignDashboardWidget(
              imagePath: AppImageKeys.service33,
              textBlack: AppLanguageKeys.maintenanceAndRepair,
              textOrange: AppLanguageKeys.internalServices,
              numberRequest: '#545212',
              isReject: true,
            ),
            RowListNotificationDesignDashboardWidget(
              imagePath: AppImageKeys.service33,
              textBlack: AppLanguageKeys.maintenanceAndRepair,
              textOrange: AppLanguageKeys.internalServices,
              numberRequest: '#545212',
              isAccept: true,
            ),
            RowListNotificationDesignDashboardWidget(
              imagePath: AppImageKeys.service33,
              textBlack: AppLanguageKeys.maintenanceAndRepair,
              textOrange: AppLanguageKeys.internalServices,
              numberRequest: '#545212',
              isNewOrder: true,
            ),
          ],
        ),
      ),
    );
  }
}
