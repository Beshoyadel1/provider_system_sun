import 'package:flutter/material.dart';
import '../../../../../features/internal_orders/first_screen_internal_orders/logic/loading_dashboard_cubit.dart';
import '../../../../../core/utilies/map_of_all_app.dart';
import '../../../custom_widget/container_with_image_container_and_two_text_widget.dart';
import '../../../../../../../core/theming/assets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/loading_dashboard_state.dart';
import '../../../../../../core/model/statistics/get_provider_main_service_statistics_model/sub_service_summaries_request.dart';

class FirstRowWithTwoContainerImageAndTwoText extends StatelessWidget {
  const FirstRowWithTwoContainerImageAndTwoText({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternalOrdersCubit, InternalOrdersState>(
      builder: (context, state) {
        final services = state.services;

        final size = MediaQuery.of(context).size;
        final isTab = size.width > ValuesOfAllApp.tabWidth;

        final itemsPerRow = isTab ? 3 : 2;
        final rowCount = (services.length / itemsPerRow).ceil();

        final isArabic =
            Localizations.localeOf(context).languageCode == 'ar';

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rowCount,
          separatorBuilder: (_, __) => const SizedBox(height: 10),

          itemBuilder: (context, rowIndex) {
            final start = rowIndex * itemsPerRow;
            final end = (start + itemsPerRow).clamp(0, services.length);

            return Row(
              children: List.generate(
                end - start,
                    (i) {
                  final index = start + i;
                  final SubServiceSummariesRequest service =
                  services[index];

                  final title = isArabic
                      ? (service.serviceName ?? '')
                      : (service.serviceLatinName ?? '');

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ContainerWithImageContainerAndTwoTextWidget(
                        imagePath: images[index % images.length],
                        title: title,
                        subTitle: '${service.orderCount ?? 0} طلب',
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

final List<String> images = [
  AppImageKeys.washingAndCleaning,
  AppImageKeys.maintenanceAndRepair,
  AppImageKeys.batteries,
  AppImageKeys.tires,
  AppImageKeys.routineMaintenance,
  AppImageKeys.oils,
];
