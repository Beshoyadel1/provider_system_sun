import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api_functions/general/car/car_brand/get_car_brand_models_model/get_car_brand_repository.dart';
import 'package:sun_web_system/core/api_functions/general/car/car_model/get_car_brand_models/car_model_data_model.dart';
import 'package:sun_web_system/core/api_functions/general/car/car_model/get_car_brand_models/get_car_brand_models_repository.dart';
import 'package:sun_web_system/core/api_functions/general/car/car_model/get_car_brand_models/get_car_brand_models_request.dart';
import 'package:sun_web_system/features/service_settings/logic/brand_input_data/brand_input_data.dart';
import 'select_car_model_setting_state.dart';

class SelectCarModelSettingCubit
    extends Cubit<SelectCarModelSettingState> {
  SelectCarModelSettingCubit()
      : super(SelectCarModelSettingState());

  final Map<int, List<CarModelDataModel>> _modelsCache = {};
  final Map<int, BrandInputData> brandInputs = {};


  void setSelectedOption(int brandIndex, int option) {
    final existing = brandInputs[brandIndex] ?? BrandInputData();

    existing.selectedOption = option;

    brandInputs[brandIndex] = existing;

    emit(state.copyWith());
  }
  void setUnifiedPrice(int brandIndex, String value) {
    final existing = brandInputs[brandIndex] ?? BrandInputData();

    existing.unifiedPrice = value;

    brandInputs[brandIndex] = existing;

    emit(state.copyWith());
  }
  String? validateBrand(int index) {
    final brands = state.brands;

    if (index >= brands.length) return "Invalid brand";

    final brand = brands[index];
    final input = brandInputs[index];

    if (input == null) {
      return "Please select option for ${brand.name}";
    }

    if (input.selectedOption == null) {
      return "Choose option for ${brand.name}";
    }

    /// 🔹 unified
    if (input.selectedOption == 0) {
      if (input.unifiedPrice == null ||
          input.unifiedPrice!.trim().isEmpty) {
        return "Enter price for ${brand.name}";
      }
    }

    /// 🔹 per model
    if (input.selectedOption == 1) {
      final models = getModelsForBrand(brand.id);

      if (models.isEmpty) {
        return "Models not loaded";
      }

      for (final model in models) {
        final price = input.modelPrices[model.id];

        if (price == null || price.trim().isEmpty) {
          return "Enter price for ${model.name}";
        }
      }
    }

    return null; // ✅ OK
  }


  void setModelPrice(int brandIndex, int modelId, String value) {
    final existing = brandInputs[brandIndex] ?? BrandInputData();

    existing.modelPrices[modelId] = value;

    brandInputs[brandIndex] = existing;

    emit(state.copyWith());
  }
  List<CarModelDataModel> getModelsForBrand(int? brandId) {
    if (brandId == null) return [];
    return _modelsCache[brandId] ?? [];
  }

  String? validateAllWithMessage() {
    final brands = state.brands;

    if (brands.isEmpty) return "No brands";

    bool hasAny = false;

    for (int i = 0; i < brands.length; i++) {
      final brand = brands[i];
      final input = brandInputs[i];

      /// ❗ لو المستخدم ما لمسش البراند ده → تجاهله
      if (input == null) continue;

      hasAny = true;

      /// لازم يكون مختار radio
      if (input.selectedOption == null) {
        return "Choose option for ${brand.name}";
      }

      /// unified
      if (input.selectedOption == 0) {
        if (input.unifiedPrice == null ||
            input.unifiedPrice!.trim().isEmpty) {
          return "Enter price for ${brand.name}";
        }
      }

      /// per model
      if (input.selectedOption == 1) {
        final models = getModelsForBrand(brand.id);

        if (models.isEmpty) {
          return "Models not loaded for ${brand.name}";
        }

        for (final model in models) {
          final price = input.modelPrices[model.id];

          if (price == null || price.trim().isEmpty) {
            return "Enter price for ${model.name}";
          }
        }
      }
    }

    /// ❗ لو المستخدم ما دخلش أي حاجة خالص
    if (!hasAny) return "Select at least one brand";

    return null;
  }  Future<void> fetchBrands() async {
    emit(state.copyWith(
      isLoadingBrands: true,
      error: null,
    ));

    try {
      final data = await getCarBrandFunction();

      if (data.isEmpty) {
        emit(state.copyWith(
          isLoadingBrands: false,
          brands: [],
        ));
        return;
      }

      emit(state.copyWith(
        isLoadingBrands: false,
        brands: data,
        selectedBrandIndex: 0,
        isLoadingModels: true,
        models: [],
      ));

      await selectBrand(0);

    } catch (e) {
      emit(state.copyWith(
        isLoadingBrands: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> selectBrand(int index) async {
    if (index == state.selectedBrandIndex &&
        state.models.isNotEmpty) return;

    final brand = state.brands[index];
    final brandId = brand.id;

    if (brandId == null) return;

    /// show loading
    emit(state.copyWith(
      selectedBrandIndex: index,
      selectedModelIndex: -1,
      isLoadingModels: true,
      models: [],
      error: null,
    ));

    try {
      if (_modelsCache.containsKey(brandId)) {
        emit(state.copyWith(
          isLoadingModels: false,
          models: _modelsCache[brandId],
        ));
        return;
      }

      final data = await getCarBrandModelsFunction(
        request: GetCarBrandModelsRequest(
          carBrandId: brandId,
        ),
      );

      _modelsCache[brandId] = data;

      emit(state.copyWith(
        isLoadingModels: false,
        models: data,
      ));

    } catch (e) {
      emit(state.copyWith(
        isLoadingModels: false,
        error: e.toString(),
      ));
    }
  }

  void selectModel(int index) {
    emit(state.copyWith(
      selectedModelIndex: index,
    ));
  }
}