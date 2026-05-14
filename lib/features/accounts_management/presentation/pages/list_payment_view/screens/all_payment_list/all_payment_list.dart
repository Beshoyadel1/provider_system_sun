import 'package:flutter/cupertino.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:sun_web_system/core/theming/assets.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/accounts_management/presentation/custom_widget/title_with_sub_title.dart';
import 'package:sun_web_system/features/order_status_design/presentation/custom_widget/image_with_two_text.dart';

class AllPaymentList extends StatelessWidget {
  const AllPaymentList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<int> items = List.generate(10, (index) => index);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(
          color: AppColors.greyColor.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        //physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          return CustomContainer(
            isSelected: false,
            onTap: () {},
            borderRadius: BorderRadius.circular(12),
            typeWidget: const Wrap(
              spacing: 5,
              runSpacing: 5,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.spaceBetween,
              children: [
                ImageWithTwoText(
                    imageSrc: AppImageKeys.service33,
                    title: 'الصيانة والاصلاح',
                    subTitle: ' ايراد من طلب 10054'),
                TitleWithSubTitle(
                  title: AppLanguageKeys.paymentMethod,
                  textSizeTitle: 13,
                  titleColor: AppColors.greyColor,
                  subTitle: 'المدفوعات الالكترونية',
                  textSizeSubTitle: 12,
                ),
                ImageWithTwoText(
                    imageSrc: AppImageKeys.person22,
                    title: AppLanguageKeys.employeeName,
                    subTitle: 'محمد عبد الله'),
                 TextInAppWidget(
                  text:'+200 ريال',
                  textSize: 15,
                  fontWeightIndex: FontSelectionData.semiBoldFontFamily,
                  textColor:AppColors.greenColor,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
