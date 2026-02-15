import 'package:flutter/cupertino.dart';
import '../../../../../../../../features/internal_orders/custom_widget/Column_date_order_with_time_widget.dart';
import '../../../../../../../../features/internal_orders/custom_widget/column_price_order_widget.dart';
import '../../../../../../../../features/internal_orders/custom_widget/column_request_status_widget.dart';
import '../../../../../../../../features/internal_orders/custom_widget/container_details_widget.dart';
import '../../../../../../../../features/internal_orders/custom_widget/row_image_with_title_orange_and_sub_title_black_widget.dart';
import '../../../../../../../../features/internal_orders/custom_widget/row_kind_of_car_with_text_widget.dart';

class TabSecondPartDataContainerInListDataFirstScreenInternalOrders
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

  const TabSecondPartDataContainerInListDataFirstScreenInternalOrders({
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
    return Row(
      spacing: 5,
      children: [
        Expanded(
          child: RowImageWithTitleOrangeAndSubTitleBlackWidget(
            imagePath: imagePathPart1,
            title: titlePart1,
            subTitle: subTitlePart1,
          ),
        ),
        Expanded(
          child: RowKindOfCarWithTextWidget(
            imagePath: imagePathPart2,
            textCar: textCarPart2,
            title: titlePart2,
          ),
        ),
        Expanded(
          child: RowImageWithTitleOrangeAndSubTitleBlackWidget(
            isJob: true,
            imagePath: imagePathPart3,
            title: titlePart3,
            subTitle: subTitlePart3,
          ),
        ),
        Expanded(
          child: ColumnRequestStatusWidget(
            isNewOrder: isNewOrderPart4,
            isAccept: isAcceptPart4,
            isReject: isRejectPart4,
          ),
        ),
        Expanded(child: ColumnDateOrderWithTimeWidget(time: timePart5)),
        Expanded(child: ColumnPriceOrderWidget(price: pricePart6)),
        const Expanded(child: ContainerDetailsWidget())
      ],
    );
  }
}
