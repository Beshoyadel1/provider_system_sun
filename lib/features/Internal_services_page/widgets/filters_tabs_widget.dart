import 'package:flutter/material.dart';
import 'package:sun_web_system/core/cubit/new_orders_cubit/new_orders_cubit.dart';
import '../../../../../features/cars_haraj_page/model/filter_orders_model/filter_orders_model.dart';
import '../../../../../core/language/language_constant.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/text_styles.dart';
import 'list_new_order_widget.dart';

class FiltersTabsWidget extends StatefulWidget {
  const FiltersTabsWidget({
    super.key,
    required this.filterOptions,
  });

  final List<filterOrdersModel> filterOptions;

  @override
  State<FiltersTabsWidget> createState() => _FiltersTabsWidgetState();
}

class _FiltersTabsWidgetState extends State<FiltersTabsWidget>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: widget.filterOptions.length, vsync: this);

    _tabController.addListener(() {
      setState(() {}); // علشان يعمل rebuild ويغير اللون
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(

          controller: _tabController,
          isScrollable: true,
          indicator: const BoxDecoration(),
          dividerColor: Colors.transparent,
          tabAlignment: TabAlignment.start,
          tabs: List.generate(widget.filterOptions.length, (index) {
            final isSelected = _tabController.index == index;

            return Tab(
              child: Container(
                width: 150,
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.orangeColor
                      : AppColors.greyColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: TextInAppWidget(
                    text: widget.filterOptions[index].text,
                    textSize: 16,
                    textColor: AppColors.whiteColor,
                  ),
                ),
              ),
            );
          }),
        ),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: List.generate(
              widget.filterOptions.length,
                  (index) => const ListNewOrderWidget(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}