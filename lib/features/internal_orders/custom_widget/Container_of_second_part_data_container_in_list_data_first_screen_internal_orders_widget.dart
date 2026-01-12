import 'package:flutter/cupertino.dart';
import '../../../../../../features/internal_orders/first_screen_internal_orders/screens/big_container_of_new_orders/part_container_big_container_of_new_orders/custom_tab_second_part_data_container_in_list_data_first_screen_internal_orders.dart';
import '../../../../../../features/internal_orders/first_screen_internal_orders/screens/big_container_of_new_orders/part_container_big_container_of_new_orders/mobile_second_part_data_container_in_list_data_first_screen_internal_orders.dart';
import '../../../../../../../../features/internal_orders/first_screen_internal_orders/screens/big_container_of_new_orders/part_container_big_container_of_new_orders/tab_second_part_data_container_in_list_data_first_screen_internal_orders.dart';
import '../../../../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../../../../core/theming/colors.dart';

class ContainerOfSecondPartDataContainerInListDataFirstScreenInternalOrdersWidget
    extends StatelessWidget {
  final String imagePathPart1,
      titlePart1,
      subTitlePart1,
      imagePathPart2,
      textCarPart2,
      titlePart2,
      imagePathPart3,
      titlePart3,
      subTitlePart3,
      timePart5,
      pricePart6;
  final bool? isNewOrderPart4, isAcceptPart4, isRejectPart4;

  const ContainerOfSecondPartDataContainerInListDataFirstScreenInternalOrdersWidget({
    super.key,
    required this.imagePathPart1,
    required this.titlePart1,
    required this.subTitlePart1,
    required this.imagePathPart2,
    required this.textCarPart2,
    required this.titlePart2,
    required this.imagePathPart3,
    required this.titlePart3,
    required this.subTitlePart3,
    this.isAcceptPart4 = false,
    this.isNewOrderPart4 = false,
    this.isRejectPart4 = false,
    required this.timePart5,
    required this.pricePart6,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= ValuesOfAllApp.mobileWidth;
    bool isTabletCustom =
        size.width > ValuesOfAllApp.mobileWidth && size.width <= 1330;
    return Container(
      padding: EdgeInsetsGeometry.all(10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: isMobile
          ? MobileSecondPartDataContainerInListDataFirstScreenInternalOrders(
              imagePathPart1: imagePathPart1,
              titlePart1: titlePart1,
              subTitlePart1: subTitlePart1,
              imagePathPart2: imagePathPart2,
              textCarPart2: textCarPart2,
              titlePart2: titlePart2,
              imagePathPart3: imagePathPart3,
              titlePart3: titlePart3,
              subTitlePart3: subTitlePart3,
              isAcceptPart4: isAcceptPart4,
              isNewOrderPart4: isNewOrderPart4,
              isRejectPart4: isRejectPart4,
              timePart5: timePart5,
              pricePart6: pricePart6,
            )
          : isTabletCustom
              ? CustomTabSecondPartDataContainerInListDataFirstScreenInternalOrders(
                  imagePathPart1: imagePathPart1,
                  titlePart1: titlePart1,
                  subTitlePart1: subTitlePart1,
                  imagePathPart2: imagePathPart2,
                  textCarPart2: textCarPart2,
                  titlePart2: titlePart2,
                  imagePathPart3: imagePathPart3,
                  titlePart3: titlePart3,
                  subTitlePart3: subTitlePart3,
                  isAcceptPart4: isAcceptPart4,
                  isNewOrderPart4: isNewOrderPart4,
                  isRejectPart4: isRejectPart4,
                  timePart5: timePart5,
                  pricePart6: pricePart6,
                )
              : TabSecondPartDataContainerInListDataFirstScreenInternalOrders(
                  imagePathPart1: imagePathPart1,
                  titlePart1: titlePart1,
                  subTitlePart1: subTitlePart1,
                  imagePathPart2: imagePathPart2,
                  textCarPart2: textCarPart2,
                  titlePart2: titlePart2,
                  imagePathPart3: imagePathPart3,
                  titlePart3: titlePart3,
                  subTitlePart3: subTitlePart3,
                  isAcceptPart4: isAcceptPart4,
                  isNewOrderPart4: isNewOrderPart4,
                  isRejectPart4: isRejectPart4,
                  timePart5: timePart5,
                  pricePart6: pricePart6,
                ),
    );
  }
}
