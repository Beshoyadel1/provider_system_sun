import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/notifications/presentation/pages/signalR_status_bar/signalR_status_bar.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/cubit/service_settings_cubit/service_settings_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/cubit/service_settings_cubit/service_settings_state.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKeyDrawer = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getPages(context);
    getIt<ServiceSettingsCubit>().getMainServices();

    final facilityAccountPage = appPages.firstWhere(
          (e) => e.number == PagesOfAllApp.dashboardPageNumber,
    );

    final facilityAccountWithID = PageNodeWithIDModel(
      id: facilityAccountPage.number,
      name: facilityAccountPage.name,
      number: facilityAccountPage.number,
      page: facilityAccountPage.page,
    );

    _appCubit.selectedPageFromOpenedPagesIndex =
        facilityAccountWithID.id;
    _appCubit.selectedPageIndex =
        facilityAccountWithID.id;
  }

  final AppCubit _appCubit = getIt<AppCubit>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= ValuesOfAllApp.mobileWidth;
    return BlocListener<ServiceSettingsCubit, ServiceSettingsState>(
      bloc: getIt<ServiceSettingsCubit>(),
      listener: (context, state) {
        if (state is ServiceSettingsSuccess) {
          getPages(context);
          print("AFTER SUCCESS => ${appPages.length}");
          print("SERVICES => ${getIt<ServiceSettingsCubit>().allMainServices.length}");
          setState(() {});
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          if (didPop) {
            return;
          }
          final bool shouldPop = await showBackDialog(context: context) ?? false;
          if (shouldPop) {
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.whiteGreyColor,
          key: _scaffoldKeyDrawer,
          drawer: const Drawer(width: 256, child: PagesSelectionBar()),
          body: Row(
            children: [
              if (!isMobile)
                BlocBuilder<AppCubit, AppStates>(
                  buildWhen: (previous, current) {
                    return current is HideMenuState;
                  },
                  builder: (BuildContext context, AppStates state) {
                    return !_appCubit.isMenuOpen
                        ? const SizedBox()
                        : const PagesSelectionBar();
                  },
                ),
              Expanded(
                child: Column(
                  children: [
                    AppBarForPage(
                      scaffoldKey: _scaffoldKeyDrawer,
                    ),
                    const SelectedScreenWidget(),
                  ],
                ),
              )
            ],
          ),
         // bottomNavigationBar: const SignalRStatusBar(),
        ),
      ),
    );

  }
}
