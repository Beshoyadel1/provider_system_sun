import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utilies/map_of_all_app.dart';
import '../../../core/cubit/app_cubit/app_cubit.dart';
import '../../../model/general_models/pages_model.dart';
import '../../../view/store_page/store_widgets/expansion_tile_widget.dart';
import '../../../view/store_page/store_widgets/general_widgets_in_store/function_add_to_opened_pages.dart';
import '../../../core/cubit/facility_cubit/facility_tab_cubit/facility_tab_cubit.dart';
import '../../../core/cubit/facility_cubit/facility_tab_cubit/facility_tab_state.dart';
import '../../../core/pages_widgets/general_widgets/custom_container.dart';
import '../../../view/store_page/store_widgets/custom_add_button.dart';
import '../../../core/theming/assets.dart';
import '../../../core/theming/colors.dart';
import '../../../core/theming/fonts.dart';
import '../../../../../core/theming/text_styles.dart';
import '../../../../../core/language/language_constant.dart';

Future<bool?> showBackDialog({required BuildContext context}) {
  Size size = MediaQuery.of(context).size;
  bool isMobile = size.width < ValuesOfAllApp.mobileWidth ? true : false ;
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 10),
        title: SizedBox(
          width:  isMobile ? size.width : 300 ,
          child: const Center(
            child: TextInAppWidget(
              text: 'Confirm_Exit',
              textAlign: TextAlign.center,
              fontWeightIndex: FontSelectionData.semiBoldFontFamily,
              textSize: 20
            )
          ),
        ),
        content: SizedBox(
          height: 50,
          width:  isMobile ? size.width : 300 ,
          child: const Center(
            child: TextInAppWidget(
              text: 'Are_You_Sure_To_Leave',
              textAlign: TextAlign.center,
              fontWeightIndex: FontSelectionData.semiBoldFontFamily,
              textSize: 20
            )
          ),
        ),
        actions: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const TextInAppWidget(
                    text: 'OK',
                    textAlign: TextAlign.center,
                    fontWeightIndex: FontSelectionData.semiBoldFontFamily,
                    textSize: 15
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const TextInAppWidget(
                    text: 'Cancel',
                    textAlign: TextAlign.center,
                    fontWeightIndex: FontSelectionData.semiBoldFontFamily,
                    textSize: 15
                  ),
                ),
              ]
          ),
        ],
      );
    },
  );
}