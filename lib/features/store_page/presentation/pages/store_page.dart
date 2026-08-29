import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/notifications/presentation/pages/signalR_status_bar/signalR_status_bar.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/cubit/service_settings_cubit/service_settings_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/cubit/service_settings_cubit/service_settings_state.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/branch_cubit/branch_cubit.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/branch_cubit/branch_state.dart';
import 'package:sun_web_system/features/store_page/presentation/pages/store_widgets/app_bar_for_page.dart';
import 'package:sun_web_system/features/store_page/presentation/pages/store_widgets/dialog_for_back.dart';
import 'package:sun_web_system/features/store_page/presentation/pages/store_widgets/pages_selection_bar.dart';
import 'package:sun_web_system/features/store_page/presentation/pages/store_widgets/selected_screen_widget.dart';
import '../../../../../../core/setup_git_it.dart';
import '../../../../../../core/cubit/app_cubit/app_cubit.dart';
import '../../../../../../core/cubit/app_cubit/app_states.dart';
import '../../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../main.dart';
import '../../../../../../../core/general_models/pages_model.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final GlobalKey<ScaffoldState> _scaffoldKeyDrawer =
  GlobalKey<ScaffoldState>();

  final BranchCubit _branchCubit = getIt<BranchCubit>();
  final AppCubit _appCubit = getIt<AppCubit>();

  @override
  void initState() {
    super.initState();

    getPages(
      context,
      _branchCubit.selectedBranchId,
    );

    _branchCubit.getProviderBranches();

    getIt<ServiceSettingsCubit>().getMainServices();

    final dashboardPage = appPages.firstWhere(
          (e) => e.number == PagesOfAllApp.dashboardPageNumber,
    );

    final dashboardPageWithID = PageNodeWithIDModel(
      id: dashboardPage.number,
      name: dashboardPage.name,
      number: dashboardPage.number,
      page: dashboardPage.page,
    );

    _appCubit.selectedPageFromOpenedPagesIndex =
        dashboardPageWithID.id;

    _appCubit.selectedPageIndex =
        dashboardPageWithID.id;
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile =
        size.width <= ValuesOfAllApp.mobileWidth;

    return MultiBlocListener(
      listeners: [
        BlocListener<ServiceSettingsCubit, ServiceSettingsState>(
          bloc: getIt<ServiceSettingsCubit>(),
          listener: (context, state) {
            if (state is ServiceSettingsSuccess) {
              getPages(
                context,
                _branchCubit.selectedBranchId,
              );
            }
          },
        ),

        BlocListener<BranchCubit, BranchState>(
          bloc: _branchCubit,
          listener: (context, state) {
            if (state is BranchSelected) {
              getPages(
                context,
                state.branchId,
              );

              _appCubit.changeSelectedPageIndex();
            }
          },
        ),
      ],
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (
            bool didPop,
            Object? result,
            ) async {
          if (didPop) return;

          final shouldPop =
              await showBackDialog(context: context) ?? false;

          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          key: _scaffoldKeyDrawer,
          backgroundColor: AppColors.whiteGreyColor,

          drawer: isMobile
              ? const Drawer(
            width: 256,
            child: PagesSelectionBar(),
          )
              : null,

          body: Row(
            children: [
              if (!isMobile)
                BlocBuilder<AppCubit, AppStates>(
                  bloc: _appCubit,
                  buildWhen: (previous, current) {
                    return current is HideMenuState;
                  },
                  builder: (context, state) {
                    if (!_appCubit.isMenuOpen) {
                      return const SizedBox.shrink();
                    }

                    return const PagesSelectionBar();
                  },
                ),

              Expanded(
                child: Column(
                  children: [
                    AppBarForPage(
                      scaffoldKey: _scaffoldKeyDrawer,
                    ),

                    BlocBuilder<BranchCubit, BranchState>(
                      bloc: _branchCubit,
                      builder: (context, state) {
                        return KeyedSubtree(
                          key: ValueKey(
                            'selected_screen_${_branchCubit.selectedBranchId}',
                          ),
                          child: const SelectedScreenWidget(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
