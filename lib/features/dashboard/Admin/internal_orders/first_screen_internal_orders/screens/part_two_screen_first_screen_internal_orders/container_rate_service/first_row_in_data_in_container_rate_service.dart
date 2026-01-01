import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../../core/language/language_constant.dart';
import '../../../../../../../../core/theming/assets.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../core/theming/fonts.dart';
import '../../../../../../../../core/theming/text_styles.dart';
import '../../../../../../../../features/dashboard/Admin/internal_orders/first_screen_internal_orders/logic/loading_dashboard_cubit.dart';
import '../../../../../../../../features/dashboard/Admin/internal_orders/first_screen_internal_orders/logic/loading_dashboard_state.dart';

class FirstRowInDataInContainerRateService extends StatelessWidget {
  const FirstRowInDataInContainerRateService({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 30,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextInAppWidget(
            text:AppLanguageKeys.internalServicesRating,
            textSize: 15,
            fontWeightIndex: FontSelectionData.regularFontFamily,
            textColor:AppColors.blackColor,
          ),
          Row(
            spacing: 10,
            children: [
              Flexible(child: Image.asset(AppImageKeys.star11)),
              BlocBuilder<InternalOrdersCubit, InternalOrdersState>(
                  buildWhen: (previous, current) => previous.isLoading != current.isLoading,
                  builder: (context, state) {
                  return TextInAppWidget(
                    text:state.isLoaded?'5.0': '0.0',
                    textSize: 15,
                    fontWeightIndex: FontSelectionData.regularFontFamily,
                    textColor:AppColors.blackColor,
                  );
                }
              ),
            ],
          )
        ],
      ),
    );
  }
}
