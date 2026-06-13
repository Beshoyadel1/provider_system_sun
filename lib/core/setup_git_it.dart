import 'package:get_it/get_it.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/cubit/service_settings_cubit/service_settings_cubit.dart';
import '../../../../core/cubit/app_cubit/app_cubit.dart';
import 'language/language_cubit/language_cubit.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<LanguageCubit>(() => LanguageCubit());
  getIt.registerLazySingleton<AppCubit>(() => AppCubit());
  getIt.registerLazySingleton<ServiceSettingsCubit>(() => ServiceSettingsCubit());
}
