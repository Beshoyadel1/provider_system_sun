import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/dio_function/dio_controller.dart';
import '../language_model.dart';
import 'language_states.dart';

class LanguageCubit extends Cubit<LanguageStates> {
  LanguageCubit() : super(InitialState());

  static LanguageCubit get(context) => BlocProvider.of(context);

  // Reading the locale subscribes the calling widget to language changes,
  // including widgets on existing routes and in open dialogs.
  static bool isArabic(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar';

  static String localizedValue(
      BuildContext context, String? arabic, String? english) {
    final selected = isArabic(context) ? arabic : english;
    if (selected != null && selected.trim().isNotEmpty) return selected;
    return isArabic(context) ? english ?? '' : arabic ?? '';
  }

  bool isAllAppLanguageArabic = true;

  Locale selectedLanguage = const Locale('ar', 'SA');
  int _languageChangeRevision = 0;
  Future<void> _pendingSave = Future<void>.value();

  void _applyLanguage(int language) {
    if (language == 1) {
      isAllAppLanguageArabic = true;
      selectedLanguage = supportedLocales[0];
    } else {
      isAllAppLanguageArabic = false;
      selectedLanguage = supportedLocales[1];
    }

    Network.setLanguageCode(selectedLanguage.languageCode);

    languageDropDownValue = languageItemsDropDown.firstWhere(
      (element) => element.number == language,
    );
    emit(ChangeAllAppLanguageState());
  }

  Future<void> changeAllAppLanguage(int language) {
    final normalizedLanguage = language == 2 ? 2 : 1;
    _languageChangeRevision++;
    _applyLanguage(normalizedLanguage);

    // Keep rapid taps in order so the saved preference matches the visible UI.
    _pendingSave = _pendingSave.then((_) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('language', normalizedLanguage);
    }).catchError((Object error) {
      debugPrint('Unable to save language preference: $error');
    });
    return _pendingSave;
  }

  List<Locale> supportedLocales = [
    const Locale('ar', 'SA'),
    const Locale('en', 'US'),
  ];

  List<String> languageItems = ['English', 'عربي'];

  LanguageModel? languageDropDownValue;
  List<LanguageModel> languageItemsDropDown = [
    LanguageModel(arName: 'عربي', enName: 'عربي', number: 1),
    LanguageModel(arName: 'English', enName: 'English', number: 2)
  ];

  Future<void> getLanguageFromSharedPreference() async {
    final revision = _languageChangeRevision;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isClosed || revision != _languageChangeRevision) return;
    _applyLanguage(prefs.getInt('language') == 2 ? 2 : 1);
  }
}
