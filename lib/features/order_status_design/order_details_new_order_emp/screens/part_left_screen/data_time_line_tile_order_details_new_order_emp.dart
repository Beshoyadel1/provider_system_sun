import 'package:flutter/cupertino.dart';
import 'package:sun_web_system/features/order_status_design/custom_widget/time_line_tile_widget.dart';
import '../../../../../../../../core/language/language_constant.dart';
import '../../../../../../../core/theming/colors.dart';

class DataTimeLineTileOrderDetailsNewOrderEmp extends StatelessWidget{
  const DataTimeLineTileOrderDetailsNewOrderEmp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsGeometry.all(10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(
            color: AppColors.greyColor.withOpacity(0.3)
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Column(
        children: [
          TimeLineTileWidget(
            isFirst: true,
            isIcon: true,
          ),
          TimeLineTileWidget(
            text: '2',
            title: 'جاري تنفيذ الطلب',
            subTitle: '1/1/2025 -16:00',
            colorAfterLine: AppColors.greyColor,
          ),
          TimeLineTileWidget(
            text: '3',
            title: 'انتظار دفع الفاتورة',
            subTitle: '',
            colorAfterLine: AppColors.greyColor,
            colorBeforeLine: AppColors.greyColor,
            colorBorder: AppColors.greyColor,
            textColor: AppColors.greyColor,
            textColorTitle: AppColors.greyColor,
          ),
          TimeLineTileWidget(
            isLast: true,
            text: '4',
            textColor: AppColors.greyColor,
            title: AppLanguageKeys.orderArrived,
            textColorTitle: AppColors.greyColor,
            subTitle: '',
            colorBeforeLine: AppColors.greyColor,
            colorBorder: AppColors.greyColor,
          ),
        ],
      ),
    );
  }
}
