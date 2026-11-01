import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sun_web_system/core/utilies/map_of_all_app.dart';
import '../../../../core/general_models/general_model.dart';
import '../../../../core/general_models/pages_model.dart';
import 'app_states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  bool isLogin = true;

  void changeSecure() {
    emit(ChangeSecureState());
  }

  bool isRememberMe = false;

  void changeRememberMe() {
    emit(ChangeRememberMeState());
  }

  bool isMenuOpen = true;

  /// Toggle menu on Desktop
  void toggleMenu() {
    isMenuOpen = !isMenuOpen;
    emit(HideMenuState());
  }

  /// Force show menu
  void showMenu() {
    if (isMenuOpen) return;

    isMenuOpen = true;
    emit(HideMenuState());
  }

  /// Force hide menu
  void hideMenu() {
    if (!isMenuOpen) return;

    isMenuOpen = false;
    emit(HideMenuState());
  }

  void dropDown() {
    emit(DropDownState());
  }

  int selectedPageIndex = PagesOfAllApp.dashboardPageNumber;
  int selectedPageFromOpenedPagesIndex = -1;
  final List<(int, int)> _pageHistory = [];
  (int, int) _lastSelection = (PagesOfAllApp.dashboardPageNumber, -1);
  bool get canGoBack =>
      _pageHistory.isNotEmpty ||
      selectedPageIndex != PagesOfAllApp.dashboardPageNumber;

  bool goBack() {
    if (!canGoBack) return false;
    var previous = _pageHistory.isNotEmpty
        ? _pageHistory.removeLast()
        : (PagesOfAllApp.dashboardPageNumber, -1);
    if (previous.$2 >= 0 &&
        !openedPages.any(
            (page) => page.number == previous.$1 && page.id == previous.$2)) {
      previous = (previous.$1, -1);
    }
    selectedPageIndex = previous.$1;
    selectedPageFromOpenedPagesIndex = previous.$2;
    _lastSelection = previous;
    data.clear();
    emit(ChangeSelectedPageIndexState());
    return true;
  }

  int? _pendingFacilityAccountTabIndex;

  void changeSelectedPageIndex() {
    final selection = (selectedPageIndex, selectedPageFromOpenedPagesIndex);
    if (selection != _lastSelection) {
      _pageHistory.add(_lastSelection);
      _lastSelection = selection;
    }
    emit(ChangeSelectedPageIndexState());
  }

  List<String> data = [];

  bool isAllAppLanguageArabic = true;

  Locale? selectedLanguage;

  Future<void> changeAllAppLanguage(int language) async {
    if (language == 1) {
      isAllAppLanguageArabic = true;
      selectedLanguage = supportedLocales[0];
    } else {
      isAllAppLanguageArabic = false;
      selectedLanguage = supportedLocales[1];
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('language', language);
    emit(ChangeAllAppLanguageState());
  }

  List<Locale> supportedLocales = [
    const Locale('ar', 'EG'),
    const Locale('en', 'US'),
  ];

  List<String> languageItems = ['English', 'عربي'];

  GeneralModel? languageDropDownValue;
  List<GeneralModel> languageItemsDropDown = [
    GeneralModel(arName: 'عربي', enName: 'عربي', number: 1),
    GeneralModel(arName: 'English', enName: 'English', number: 2)
  ];

  Future<void> getLanguageFromSharedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? languageFromSharedPreference = prefs.getInt('language');
    if (languageFromSharedPreference != null) {
      languageDropDownValue = languageItemsDropDown
          .where((element) => element.number == languageFromSharedPreference)
          .first;
      changeAllAppLanguage(languageFromSharedPreference);
    } else {
      languageDropDownValue =
          languageItemsDropDown.where((element) => element.number == 1).first;
      changeAllAppLanguage(languageDropDownValue!.number!);
    }
  }

  List<PageNodeWithIDModel> openedPages = [];

  Future<void> resetSession() async {
    _pageHistory.clear();
    _lastSelection = (PagesOfAllApp.dashboardPageNumber, -1);
    selectedPageIndex = PagesOfAllApp.dashboardPageNumber;
    selectedPageFromOpenedPagesIndex = -1;
    _pendingFacilityAccountTabIndex = null;
    openedPages.clear();
    data.clear();
    isMenuOpen = true;
    emit(ChangeSelectedPageIndexState());

    final prefs = await SharedPreferences.getInstance();
    // Saved page drafts use concatenated numeric page/id keys. Language is
    // an application preference and is retained when changing accounts.
    final draftKeys = prefs.getKeys().where(RegExp(r'^\d+-?\d+$').hasMatch);
    for (final key in draftKeys.toList()) {
      await prefs.remove(key);
    }
  }

  void navigateToPage(int pageNumber) {
    selectedPageIndex = pageNumber;
    selectedPageFromOpenedPagesIndex = -1;
    changeSelectedPageIndex();
  }

  void navigateToFacilityAccount({required int tabIndex}) {
    _pendingFacilityAccountTabIndex = tabIndex;
    navigateToPage(PagesOfAllApp.permissionsGroupPageNumber);
  }

  int takeFacilityAccountTabIndex() {
    final tabIndex = _pendingFacilityAccountTabIndex ?? 0;
    _pendingFacilityAccountTabIndex = null;
    return tabIndex;
  }

  void changeOpenedPages() {
    emit(ChangeOpenedPagesState());
  }
}
