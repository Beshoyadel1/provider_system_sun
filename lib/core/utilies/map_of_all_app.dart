import 'package:sun_web_system/features/advertisements/first_screen_advertisements/first_screen_advertisements.dart';
import '../../../core/general_models/pages_model.dart';
import '../../../features/Internal_services_page/ui/Internal_and_services_statistics_page.dart';
import '../../../features/Internal_services_page/ui/internal_orders_page.dart';
import '../../../features/Petroleum_Service/All_Orders_Are_Filled_Petroleum_Filling_Requests/All_Orders_Are_Filled_Petroleum_Filling_Requests.dart';
import '../../../features/cars_haraj_page/ui/car_haraj_orders_page.dart';
import '../../../features/cars_haraj_page/ui/cars_haraj_statistics_page.dart';
import '../../../features/communication_and_policies_pages/first_screen_communication_and_policies_pages/first_screen_communication_and_policies_pages.dart';
import '../../../features/dashboard_page/dashboard_page.dart';
import '../../../features/internal_orders/first_screen_internal_orders/first_screen_internal_orders.dart';
import '../../../features/notifications/first_screen_advertisements/first_screen_notifications.dart';
import '../../../features/petroleum_service/facility_management/facility_management/facility_management.dart';
import '../../../features/petroleum_service/oil_products/oil_products.dart';
import '../../../features/petroleum_service/petroleum_filling_requests/petroleum_filling_requests.dart';
import '../../../features/rates/first_screen_rates/first_screen_rates.dart';
import '../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/added_maintenance_and_internal_services_in_service_settings.dart';
import '../../../features/service_settings/car_spare_parts_in_service_settings/car_spare_parts_in_service_settings.dart';
import '../../../features/service_settings/first_screen_service_settings/first_screen_service_settings.dart';
import '../../../features/service_settings/internal_maintenance_and_services_in_service_settings/internal_maintenance_and_services_in_service_settings.dart';
import '../../../features/service_settings/shared_packages_in_service_settings/shared_packages_in_service_settings.dart';
import '../../../features/store_page/store_widgets/car_model_widget/car_model_widget.dart';
import '../../../features/store_page/store_widgets/facility_account/facility_account.dart';
import '../../../features/logout_dashboard/first_screen_logout_dashboard/logout_dashboard.dart';
import '../../../core/language/language_constant.dart';
import '../../../core/theming/assets.dart';
import '../../../features/permissions/first_screen_permissions/first_screen_permissions.dart';

class AppStatesApi {
  static const String phoneExist = 'PhoneExist';
  static const String emailExist = 'EmailExist';
  static const String done = 'Done';
  static const String noUser = 'No User';
  static const String notActive = 'not active';
  static const String wrongPassword = 'Wrong Password';
  static const String reservedUser = 'Reserved';
  static const String haveOperationForDelete = 'HaveOperation';
  static const String notFound = 'not found';
  static const String sameUser = 'same user';
  static const String notEnoughSMAT = 'not enough SMAT';
}

class ValuesOfAllApp {
  static const int mobileWidth = 900;
  static const int tabWidth = 1250;
  static const int customTabWidth = 1050;
  static const int balanceRadioIndex = 1;
  static const int smatRadioIndex = 2;
  static const int subscriptionEliteButtonIndex = 1;
  static const String version = '2.0.0';
}

class PagesOfAllApp {
  static const String dashboardPage = 'Dashboard_Page';
  static const int dashboardPageNumber = 1;

  static const String securityPage = 'Security_Page';
  static const int securityPageNumber = 2;

  static const String permissionsGroupPage = 'Permissions_Group_Page';
  static const int permissionsGroupPageNumber = 201;

  static const String usersPermissionsPage = 'Users_Permissions_Page';
  static const int usersPermissionsPageNumber = 202;

  static const String userStatisticsPage = 'User_Statistics_Page';
  static const int userStatisticsPageNumber = 203;

  static const String settingsPage = 'Settings_Page';
  static const int settingsPageNumber = 3;

  static const String companiesPage = 'Companies_Page';
  static const int companiesPageNumber = 301;

  static const String generalSettingsPage = 'General_Settings_Page';
  static const int generalSettingsPageNumber = 302;

  static const String branchesPage = 'Branches_Page';
  static const int branchesPageNumber = 303;

  static const String inventoriesPage = 'Inventories_Page';
  static const int inventoriesPageNumber = 304;

  static const String banksPage = 'Banks_Page';
  static const int banksPageNumber = 305;

  static const String areasPage = 'Areas_Page';
  static const int areasPageNumber = 306;

  static const String taxesPage = 'Taxes_Page';
  static const int taxesPageNumber = 307;

  static const String financialPeriodPage = 'Financial_Period_Page';
  static const int financialPeriodPageNumber = 308;

  static const String costCenterPage = 'Cost_Center_Page';
  static const int costCenterPageNumber = 309;

  static const String currenciesPage = 'Currencies_Page';
  static const int currenciesPageNumber = 310;

  static const String categoriesPage = 'Categories_Page';
  static const int categoriesPageNumber = 311;

  static const String facilityManagementPage = 'Facility_Management_Page';
  static const int facilityManagementPageNumber = 312;

  static const String facilityAccountPage = 'Facility_Account_Page';
  static const int facilityAccountPageNumber = 313;

  static const String carModelsPage = 'Car_Models_Page';
  static const int carModelsPageNumber = 314;

  static const String InternalServices = 'Service_Settings_Page';
  static const int internalServicesPageNumber = 315;

  static const String sparePage = 'Spare_Page';
  static const int sparePageNumber = 316;

  static const String walletPage = 'Security_Page';
  static const int walletPageNumber = 317;

  static const String usersPage = 'Security_Page';
  static const int usersPageNumber = 318;

  static const String notificationPage = 'Security_Page';
  static const int notificationPageNumber = 319;

  static const String bannerPage = 'Security_Page';
  static const int bannerPageNumber = 320;

  static const String starPage = 'Security_Page';
  static const int starPageNumber = 321;

  static const String pagesPage = 'Security_Page';
  static const int pagesPageNumber = 322;

  static const String logoutPage = 'Security_Page';
  static const int logoutPageNumber = 323;

  static const String carPage = 'Security_Page';
  static const int carPageNumber = 324;

  static const String internalServicesStatisticsPage = 'Security_Page';
  static const int internalServicesStatisticsPageNumber = 4;

  static const String carsHarajStatisticsPage = 'Security_Page';
  static const int carsHarajStatisticsPageNumber = 6;

  static const String internalOrdersPage = 'Security_Page';
  static const int internalOrdersPageNumber = 5;

  static const String carHarajOrdersPage = 'Security_Page';
  static const int carHarajOrdersPageNumber = 7;

  //-----------------------------------------------------------------
  static const String permissionsPage = 'Permissions_Page';
  static const int permissionsPageNumber = 500;

  static const String advertisementsPage = 'Advertisements_Page';
  static const int advertisementsPageNumber = 501;

  static const String petroleumPage = 'Petroleum_Page';
  static const int petroleumPageNumber = 502;
  static const String ordersPetroleumPage = 'Orders_Petroleum_Page';
  static const int ordersPetroleumPageNumber = 503;
  static const String oilProductsPetroleumPage = 'Oil_Products_Petroleum_Page';
  static const int oilProductsPetroleumPageNumber = 504;
  static const String facilityManagementPetroleumPage =
      'Facility_Management_Petroleum_Page';
  static const int facilityManagementPetroleumPageNumber = 505;
  static const String statisticsPetroleumPage = 'Statistics_Petroleum_Page';
  static const int statisticsPetroleumPageNumber = 506;

  static const String serviceSettingsPage = 'Service_Settings_Page';
  static const int serviceSettingsPageNumber = 507;
  static const String maintenanceAndInteriorServicesPage =
      'Maintenance_And_Interior_Services_Page';
  static const int maintenanceAndInteriorServicesPageNumber = 508;
  static const String carPartsPage = 'Car_Parts_Page';
  static const int carPartsPageNumber = 509;
  static const String sharedPackagesPage = 'Shared_Packages_Page';
  static const int sharedPackagesPageNumber = 510;
  static const String mobileServicesAndTransportationPage =
      'Mobile_Services_and_Transportation_Page';
  static const int mobileServicesAndTransportationPageNumber = 511;
}

List<PageNodeModel> appPages = [];

void getPages() {
  appPages.clear();
  appPages = [
    const PageNodeModel(
      name: AppLanguageKeys.dashBoardPageKey,
      image: AppImageKeys.home,
      number: PagesOfAllApp.dashboardPageNumber,
      page: DashboardPage(),
    ),
    const PageNodeModel(
        name: AppLanguageKeys.maintenanceAndInternalServicesKey,
        image: AppImageKeys.carServices,
        number: PagesOfAllApp.internalServicesPageNumber,
        children: [
          PageNodeModel(
            name: AppLanguageKeys.permissionsGroupPageKey,
            number: PagesOfAllApp.internalServicesStatisticsPageNumber,
            page: FirstScreenInternalOrders(),
          ),
          PageNodeModel(
            name: AppLanguageKeys.ordersSectionKey,
            number: PagesOfAllApp.internalOrdersPageNumber,
            page: InternalOrdersPage(),
          ),
        ]),
    // const PageNodeModel(
    //     name: AppLanguageKeys.mobileAndTransportServicesKey,
    //     image: AppImageKeys.truckBox,
    //     number: PagesOfAllApp.carModelsPageNumber,
    //     children: [
    //       const PageNodeModel(
    //         name: AppLanguageKeys.permissionsGroupPageKey,
    //         number: PagesOfAllApp.internalServicesStatisticsPageNumber,
    //         page: InternalAndServicesStatisticsPage(),
    //       ),
    //       PageNodeModel(
    //         name: AppLanguageKeys.ordersSectionKey,
    //         number: PagesOfAllApp.internalOrdersPageNumber,
    //         page: InternalOrdersPage(),
    //       ),
    //     ]),
    const PageNodeModel(
      name: AppLanguageKeys.permissionsKey,
      image: AppImageKeys.userPermissions,
      number: PagesOfAllApp.permissionsPageNumber,
      page: FirstScreenPermissions(),
    ),
    const PageNodeModel(
      name: AppLanguageKeys.advertisements,
      image: AppImageKeys.banner,
      number: PagesOfAllApp.advertisementsPageNumber,
      page: FirstScreenAdvertisements(),
    ),
    const PageNodeModel(
        name: AppLanguageKeys.sparePartsSectionKey,
        image: AppImageKeys.spare,
        number: PagesOfAllApp.sparePageNumber,
        children: [
          PageNodeModel(
            name: AppLanguageKeys.permissionsGroupPageKey,
            number: PagesOfAllApp.internalServicesStatisticsPageNumber,
            page: InternalAndServicesStatisticsPage(),
          ),
          PageNodeModel(
            name: AppLanguageKeys.ordersSectionKey,
            number: PagesOfAllApp.internalOrdersPageNumber,
            page: InternalOrdersPage(),
          ),
        ]),
    const PageNodeModel(
        name: AppLanguageKeys.carMarketKey,
        image: AppImageKeys.sell,
        number: PagesOfAllApp.carPageNumber,
        children: [
           PageNodeModel(
            name: AppLanguageKeys.permissionsGroupPageKey,
            number: PagesOfAllApp.carsHarajStatisticsPageNumber,
            page: CarsHarajStatisticsPage(),
          ),
          PageNodeModel(
            name: AppLanguageKeys.ordersSectionKey,
            number: PagesOfAllApp.carHarajOrdersPageNumber,
            page: CarHarajOrdersPage(),
          ),
        ]),
    const PageNodeModel(
        name: AppLanguageKeys.facilityManagementKey,
        image: AppImageKeys.store,
        number: PagesOfAllApp.securityPageNumber,
        children: [
          PageNodeModel(
            name: AppLanguageKeys.facilityAccountKey,
            number: PagesOfAllApp.permissionsGroupPageNumber,
            page: FacilityAccount(),
          ),
          PageNodeModel(
            name: AppLanguageKeys.carModelsTitleKey,
            number: PagesOfAllApp.usersPermissionsPageNumber,
            page: CarModelWidget(),
          ),
          PageNodeModel(
              name: AppLanguageKeys.serviceSettingsTitleKey,
              number: PagesOfAllApp.serviceSettingsPageNumber,
              image: AppImageKeys.store,
              page: FirstScreenServiceSettings(),
              children: [
                PageNodeModel(
                  name: AppLanguageKeys.serviceSettingsTitleKey,
                  number: PagesOfAllApp.serviceSettingsPageNumber,
                  page: FirstScreenServiceSettings(),
                ),
                PageNodeModel(
                  name: AppLanguageKeys.maintenanceAndInternalServicesKey,
                  number:
                      PagesOfAllApp.maintenanceAndInteriorServicesPageNumber,
                  page: AddedMaintenanceAndInternalServicesInServiceSettings(),
                ),
                PageNodeModel(
                  name: AppLanguageKeys.carSpareParts,
                  number: PagesOfAllApp.carPartsPageNumber,
                  page: CarSparePartsInServiceSettings(),
                ),
                PageNodeModel(
                  name: AppLanguageKeys.sharedPackages,
                  number: PagesOfAllApp.sharedPackagesPageNumber,
                  page: SharedPackagesInServiceSettings(),
                ),
                PageNodeModel(
                  name: AppLanguageKeys.mobileServicesKey,
                  number:
                      PagesOfAllApp.mobileServicesAndTransportationPageNumber,
                  page: InternalMaintenanceAndServicesInServiceSettings(),
                ),
              ]),
        ]),
    const PageNodeModel(
      name: AppLanguageKeys.accountManagementKey,
      image: AppImageKeys.wallet,
      number: PagesOfAllApp.walletPageNumber,
    ),
    const PageNodeModel(
        name: AppLanguageKeys.petroleum,
        image: AppImageKeys.users,
        number: PagesOfAllApp.petroleumPageNumber,
        children: [
          PageNodeModel(
            name: AppLanguageKeys.statistics,
            image: AppImageKeys.home,
            number: PagesOfAllApp.statisticsPetroleumPageNumber,
            page: PetroleumFillingRequests(),
          ),
          PageNodeModel(
            name: AppLanguageKeys.allOrders,
            image: AppImageKeys.sell,
            number: PagesOfAllApp.ordersPetroleumPageNumber,
            page: AllOrdersAreFilledPetroleumFillingRequests(),
          ),
          PageNodeModel(
            name: AppLanguageKeys.oilProducts,
            image: AppImageKeys.wallet,
            number: PagesOfAllApp.oilProductsPetroleumPageNumber,
            page: OilProducts(),
          ),
          PageNodeModel(
            name: AppLanguageKeys.facilityManagementKey,
            image: AppImageKeys.FacilityManagement,
            number: PagesOfAllApp.facilityManagementPetroleumPageNumber,
            page: FacilityManagement(),
          ),
        ]),
    const PageNodeModel(
        name: AppLanguageKeys.notificationsKey,
        image: AppImageKeys.notificationIcon,
        number: PagesOfAllApp.notificationPageNumber,
        page: FirstScreenNotifications()),
    const PageNodeModel(
        name: AppLanguageKeys.reviewsKey,
        image: AppImageKeys.star,
        number: PagesOfAllApp.starPageNumber,
        page: FirstScreenRates()),
    const PageNodeModel(
      name: AppLanguageKeys.socialPagesAndPoliciesKey,
      image: AppImageKeys.pages,
      number: PagesOfAllApp.pagesPageNumber,
      page: FirstScreenCommunicationAndPoliciesPages(),
    ),
    const PageNodeModel(
      name: AppLanguageKeys.logoutKey,
      image: AppImageKeys.logout,
      number: PagesOfAllApp.logoutPageNumber,
      page: LogoutDashboard(),
    ),
  ];
}
