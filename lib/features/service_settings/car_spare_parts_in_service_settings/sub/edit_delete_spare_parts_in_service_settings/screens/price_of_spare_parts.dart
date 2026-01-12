import 'package:flutter/cupertino.dart';
import '../../../../../../../../features/internal_orders/custom_widget/row_number_coin_widget.dart';
import '../../../../../../../../core/theming/assets.dart';

class PriceOfSpareParts extends StatelessWidget {
  const PriceOfSpareParts({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RowNumberCoinWidget(
            numberText: '450.00', sizeText: 16, imageSrc: AppImageKeys.coin),
      ],
    );
  }
}
