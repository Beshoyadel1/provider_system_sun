import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/internal_services/internal_orders/first_screen_internal_orders/logic/tabs_cubit/tabs_cubit.dart';
import 'package:sun_web_system/features/spare_parts/custom_widget/app_pagination.dart';
import '../../../../../../features/cars_haraj_page/logic/get_all_harage_cubit/get_all_harage_cubit.dart';
import '../../../../../../features/cars_haraj_page/logic/get_all_harage_cubit/get_all_harage_state.dart';
import '../../../../../../features/cars_haraj_page/widgets/available_cars.dart';

class FilterDesignCarList extends StatelessWidget {
  const FilterDesignCarList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAllHarageCubit, GetAllHarageState>(
      builder: (context, state) {

        if (state is GetAllHarageLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GetAllHarageSuccess) {

          final selectedTab = context.watch<TabsCubit>().state;

          final allCars = state.response.data ?? [];

          List cars;
          switch (selectedTab) {
            case 1:
              cars = allCars.where((c) => c.isNew == true).toList();
              break;

            case 2:
              cars = allCars.where((c) => c.isNew == false).toList();
              break;

            case 3:
              cars = allCars.where((c) => c.isSold == true).toList();
              break;

            default:
              cars = allCars;
          }

          return  Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: cars.length,
                  itemBuilder: (context, index) {

                    final car = cars[index];

                    final isEnglish =
                        Localizations.localeOf(context).languageCode == 'en';

                    final brandNameTitle = isEnglish
                        ? (car.car?.brandLatinName ?? "")
                        : (car.car?.brandName ?? "");
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: AvailableCars(
                        id: car.id.toString(),
                        releaseDate: car.releaseDate,
                        description: car.description,
                        isSold: car.isSold ?? false,
                        isNew: car.isNew ?? false,
                        brandName: brandNameTitle,
                        price: car.price?.toString() ?? "",
                        onTap: () {},
                      ),
                    );
                  },
                ),
              ),
              AppPagination(
                currentPage: state.currentPage,
                totalPages: 50,
                onPageChanged: (page) {
                  context.read<GetAllHarageCubit>().getAllHarage(page: page);
                },
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}