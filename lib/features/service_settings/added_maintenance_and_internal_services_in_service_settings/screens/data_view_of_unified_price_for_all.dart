import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import '../../../../../../features/service_settings/logic/create_prov_service_cubit/create_prov_service_cubit.dart';
import '../../../../../../core/pages_widgets/text_form_field_widget.dart';

class DataViewOfUnifiedPriceForAll extends StatefulWidget {
  final int brandId;

  const DataViewOfUnifiedPriceForAll({
    super.key,
    required this.brandId,
  });

  @override
  State<DataViewOfUnifiedPriceForAll> createState() =>
      _DataViewOfUnifiedPriceForAllState();
}

class _DataViewOfUnifiedPriceForAllState
    extends State<DataViewOfUnifiedPriceForAll> {

  late TextEditingController priceController;
  late TextEditingController costController;

  @override
  void initState() {
    super.initState();

    final cubit = context.read<CreateProvServiceCubit>();
    final existing = cubit.brandsData[widget.brandId];

    priceController = TextEditingController(
      text: existing?.uniformprice?.toString() ?? '',
    );

    costController = TextEditingController(
      text: existing?.cost?.toString() ?? '',
    );
  }

  void _updateCubit() {
    final cubit = context.read<CreateProvServiceCubit>();

    final priceText = priceController.text.trim();
    final costText = costController.text.trim();

    final price = double.tryParse(priceText);
    final cost = double.tryParse(costText);

    cubit.setUnifiedPrice(
      brandId: widget.brandId,
      price: price,
      cost: cost,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextFormFieldWidget(
              textFormController: priceController,
              hintText: AppLanguageKeys.price,
              fillColor: AppColors.transparent,
              borderColor: AppColors.darkColor.withOpacity(0.2),
              hintTextSize: 12,
              hintTextColor: AppColors.orangeColor,
              textSize: 15,
              isDigit: true,

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLanguageKeys.enterYourData;
                }
                return null;
              },

              onChanged: (_) => _updateCubit(),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: TextFormFieldWidget(
              textFormController: costController,
              hintText: AppLanguageKeys.cost,
              fillColor: AppColors.transparent,
              borderColor: AppColors.darkColor.withOpacity(0.2),
              hintTextSize: 12,
              hintTextColor: AppColors.orangeColor,
              textSize: 15,
              isDigit: true,

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLanguageKeys.enterYourData;
                }
                return null;
              },

              onChanged: (_) => _updateCubit(),
            ),
          ),
        ],
      ),
    );
  }
}