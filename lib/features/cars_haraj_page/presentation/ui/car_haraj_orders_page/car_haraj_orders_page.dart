import 'package:sun_web_system/core/setup_git_it.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/branch_cubit/branch_cubit.dart';
import 'screens/harage_server_filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import '../../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../../features/cars_haraj_page/presentation/bloc/harag_cubit/harag_cubit.dart';
import '../../../../../../../../../features/cars_haraj_page/presentation/ui/car_haraj_orders_page/screens/list_view_car_harag.dart';

class CarHarajOrdersPage extends StatelessWidget {
  const CarHarajOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HaragCubit()
        ..selectedHarageBranchId = (getIt<BranchCubit>().selectedBranchId > 0
            ? getIt<BranchCubit>().selectedBranchId
            : null)
        ..getUserHarages(
          currentPage: 1,
        ),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.scaffoldColor,
            body: SafeArea(
              child: RefreshIndicator(
                color: AppColors.orangeColor,
                onRefresh: () async {
                  await context
                      .read<HaragCubit>()
                      .getUserHarages(currentPage: 1);
                },
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    Row(children: [
                      Expanded(
                          child: Text(
                        Localizations.localeOf(context).languageCode == 'ar'
                            ? 'إعلانات الحراج'
                            : 'Harage ads',
                        style: const TextStyle(
                            fontFamily: AppFonts.readexProFontFamily,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkColor),
                      )),
                      const SizedBox(width: 12),
                      const HarageServerFilters(),
                    ]),
                    const SizedBox(height: 16),
                    const Expanded(child: ListViewCarHarag()),
                  ]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
