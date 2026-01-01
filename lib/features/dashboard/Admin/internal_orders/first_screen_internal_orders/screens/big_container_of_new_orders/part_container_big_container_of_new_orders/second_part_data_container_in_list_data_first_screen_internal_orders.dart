import 'package:flutter/cupertino.dart';
import '../../../../../../../../features/dashboard/Admin/internal_orders/custom_widget/Container_of_second_part_data_container_in_list_data_first_screen_internal_orders_widget.dart';
import '../../../../../../../../core/theming/assets.dart';
import '../../../../../../../../core/language/language_constant.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../core/theming/fonts.dart';
import '../../../../../../../../core/theming/text_styles.dart';

class SecondPartDataContainerInListDataFirstScreenInternalOrders extends StatelessWidget {
  final bool? isLoading;
  const SecondPartDataContainerInListDataFirstScreenInternalOrders({
    super.key,
    this.isLoading=false,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading!?
      Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        ContainerOfSecondPartDataContainerInListDataFirstScreenInternalOrdersWidget(
            imagePathPart1: AppImageKeys.service33,
            titlePart1: AppLanguageKeys.internalServices,
            subTitlePart1: AppLanguageKeys.maintenanceAndRepair,
            imagePathPart2: AppImageKeys.car501,
            textCarPart2: 'Ariya',
            titlePart2: 'Nissan',
            imagePathPart3: AppImageKeys.person22,
            titlePart3: AppLanguageKeys.jobName,
            subTitlePart3: 'أحمد محمود محمد',
            timePart5:'1/1/2025',
            pricePart6: '500'
        ),
        ContainerOfSecondPartDataContainerInListDataFirstScreenInternalOrdersWidget(
          imagePathPart1: AppImageKeys.service33,
          titlePart1: AppLanguageKeys.internalServices,
          subTitlePart1: AppLanguageKeys.maintenanceAndRepair,
          imagePathPart2: AppImageKeys.car501,
          textCarPart2: 'Ariya',
          titlePart2: 'Nissan',
          imagePathPart3: AppImageKeys.person22,
          titlePart3: AppLanguageKeys.jobName,
          subTitlePart3: 'أحمد محمود محمد',
          isNewOrderPart4: true,
          timePart5:'1/1/2025',
          pricePart6: '500'
        ),
        ContainerOfSecondPartDataContainerInListDataFirstScreenInternalOrdersWidget(
            imagePathPart1: AppImageKeys.service33,
            titlePart1: AppLanguageKeys.internalServices,
            subTitlePart1: AppLanguageKeys.maintenanceAndRepair,
            imagePathPart2: AppImageKeys.car501,
            textCarPart2: 'Ariya',
            titlePart2: 'Nissan',
            imagePathPart3: AppImageKeys.person22,
            titlePart3: AppLanguageKeys.jobName,
            subTitlePart3: 'أحمد محمود محمد',
            isRejectPart4: true,
            timePart5:'1/1/2025',
            pricePart6: '500'
        ),
        ContainerOfSecondPartDataContainerInListDataFirstScreenInternalOrdersWidget(
            imagePathPart1: AppImageKeys.service33,
            titlePart1: AppLanguageKeys.internalServices,
            subTitlePart1: AppLanguageKeys.maintenanceAndRepair,
            imagePathPart2: AppImageKeys.car501,
            textCarPart2: 'Ariya',
            titlePart2: 'Nissan',
            imagePathPart3: AppImageKeys.person22,
            titlePart3: AppLanguageKeys.jobName,
            subTitlePart3: 'أحمد محمود محمد',
            isAcceptPart4: true,
            timePart5:'1/1/2025',
            pricePart6: '500'
        ),
        ContainerOfSecondPartDataContainerInListDataFirstScreenInternalOrdersWidget(
            imagePathPart1: AppImageKeys.service33,
            titlePart1: AppLanguageKeys.internalServices,
            subTitlePart1: AppLanguageKeys.maintenanceAndRepair,
            imagePathPart2: AppImageKeys.car501,
            textCarPart2: 'Ariya',
            titlePart2: 'Nissan',
            imagePathPart3: AppImageKeys.person22,
            titlePart3: AppLanguageKeys.jobName,
            subTitlePart3: 'أحمد محمود محمد',
            timePart5:'1/1/2025',
            pricePart6: '500'
        ),
        ContainerOfSecondPartDataContainerInListDataFirstScreenInternalOrdersWidget(
            imagePathPart1: AppImageKeys.service33,
            titlePart1: AppLanguageKeys.internalServices,
            subTitlePart1: AppLanguageKeys.maintenanceAndRepair,
            imagePathPart2: AppImageKeys.car501,
            textCarPart2: 'Ariya',
            titlePart2: 'Nissan',
            imagePathPart3: AppImageKeys.person22,
            titlePart3: AppLanguageKeys.jobName,
            subTitlePart3: 'أحمد محمود محمد',
            isNewOrderPart4: true,
            timePart5:'1/1/2025',
            pricePart6: '500'
        ),
        ContainerOfSecondPartDataContainerInListDataFirstScreenInternalOrdersWidget(
            imagePathPart1: AppImageKeys.service33,
            titlePart1: AppLanguageKeys.internalServices,
            subTitlePart1: AppLanguageKeys.maintenanceAndRepair,
            imagePathPart2: AppImageKeys.car501,
            textCarPart2: 'Ariya',
            titlePart2: 'Nissan',
            imagePathPart3: AppImageKeys.person22,
            titlePart3: AppLanguageKeys.jobName,
            subTitlePart3: 'أحمد محمود محمد',
            isRejectPart4: true,
            timePart5:'1/1/2025',
            pricePart6: '500'
        ),
        ContainerOfSecondPartDataContainerInListDataFirstScreenInternalOrdersWidget(
            imagePathPart1: AppImageKeys.service33,
            titlePart1: AppLanguageKeys.internalServices,
            subTitlePart1: AppLanguageKeys.maintenanceAndRepair,
            imagePathPart2: AppImageKeys.car501,
            textCarPart2: 'Ariya',
            titlePart2: 'Nissan',
            imagePathPart3: AppImageKeys.person22,
            titlePart3: AppLanguageKeys.jobName,
            subTitlePart3: 'أحمد محمود محمد',
            isAcceptPart4: true,
            timePart5:'1/1/2025',
            pricePart6: '500'
        ),
      ],
    )
        :
      Center(
      child: TextInAppWidget(
        text:AppLanguageKeys.noRequests,
        textSize: 15,
        fontWeightIndex: FontSelectionData.regularFontFamily,
        textColor:AppColors.greyColor,
      ),
      )
    ;
  }
}
