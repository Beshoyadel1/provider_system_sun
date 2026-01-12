import 'package:flutter/cupertino.dart';
import '../../../../../../core/theming/assets.dart';
import '../../../../../../features/service_settings/custom_widget/container_car_spare_parts_details_widget.dart';

class TabListViewDataContainerCarSparePartsDetails extends StatelessWidget {
  const TabListViewDataContainerCarSparePartsDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        Row(
          spacing: 5,
          children: [
            Expanded(
                child: ContainerCarSparePartsDetailsWidget(
              countProductRemain: 'باقي 5 قطع',
              imagePathLogoCar: AppImageKeys.logo12,
              imageProduct: AppImageKeys.spare_parts,
              priceProduct: '500',
              textKindProduct: 'اكسسوارات',
              textNameCar: 'صني',
              textNameProduct: 'أسم قطع الغيار',
            )),
            Expanded(
                child: ContainerCarSparePartsDetailsWidget(
              countProductRemain: 'باقي 5 قطع',
              imagePathLogoCar: AppImageKeys.logo12,
              imageProduct: AppImageKeys.spare_parts,
              priceProduct: '500',
              textKindProduct: 'اكسسوارات',
              textNameCar: 'صني',
              textNameProduct: 'أسم قطع الغيار',
            )),
            Expanded(
                child: ContainerCarSparePartsDetailsWidget(
              countProductRemain: 'باقي 5 قطع',
              imagePathLogoCar: AppImageKeys.logo12,
              imageProduct: AppImageKeys.spare_parts,
              priceProduct: '500',
              textKindProduct: 'اكسسوارات',
              textNameCar: 'صني',
              textNameProduct: 'أسم قطع الغيار',
            )),
          ],
        ),
        Row(
          spacing: 5,
          children: [
            Expanded(
                child: ContainerCarSparePartsDetailsWidget(
              countProductRemain: 'باقي 5 قطع',
              imagePathLogoCar: AppImageKeys.logo12,
              imageProduct: AppImageKeys.spare_parts,
              priceProduct: '500',
              textKindProduct: 'اكسسوارات',
              textNameCar: 'صني',
              textNameProduct: 'أسم قطع الغيار',
            )),
            Expanded(
                child: ContainerCarSparePartsDetailsWidget(
              countProductRemain: 'باقي 5 قطع',
              imagePathLogoCar: AppImageKeys.logo12,
              imageProduct: AppImageKeys.spare_parts,
              priceProduct: '500',
              textKindProduct: 'اكسسوارات',
              textNameCar: 'صني',
              textNameProduct: 'أسم قطع الغيار',
            )),
            Expanded(
                child: ContainerCarSparePartsDetailsWidget(
              countProductRemain: 'باقي 5 قطع',
              imagePathLogoCar: AppImageKeys.logo12,
              imageProduct: AppImageKeys.spare_parts,
              priceProduct: '500',
              textKindProduct: 'اكسسوارات',
              textNameCar: 'صني',
              textNameProduct: 'أسم قطع الغيار',
            )),
          ],
        ),
        Row(
          spacing: 5,
          children: [
            Expanded(
                child: ContainerCarSparePartsDetailsWidget(
              countProductRemain: 'باقي 5 قطع',
              imagePathLogoCar: AppImageKeys.logo12,
              imageProduct: AppImageKeys.spare_parts,
              priceProduct: '500',
              textKindProduct: 'اكسسوارات',
              textNameCar: 'صني',
              textNameProduct: 'أسم قطع الغيار',
            )),
            Expanded(
                child: ContainerCarSparePartsDetailsWidget(
              countProductRemain: 'باقي 5 قطع',
              imagePathLogoCar: AppImageKeys.logo12,
              imageProduct: AppImageKeys.spare_parts,
              priceProduct: '500',
              textKindProduct: 'اكسسوارات',
              textNameCar: 'صني',
              textNameProduct: 'أسم قطع الغيار',
            )),
            Expanded(
                child: ContainerCarSparePartsDetailsWidget(
              countProductRemain: 'باقي 5 قطع',
              imagePathLogoCar: AppImageKeys.logo12,
              imageProduct: AppImageKeys.spare_parts,
              priceProduct: '500',
              textKindProduct: 'اكسسوارات',
              textNameCar: 'صني',
              textNameProduct: 'أسم قطع الغيار',
            )),
          ],
        ),
      ],
    );
  }
}
