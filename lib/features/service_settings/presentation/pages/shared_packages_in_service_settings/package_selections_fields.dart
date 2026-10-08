import 'package:flutter/material.dart';
import 'package:sun_web_system/core/language/language_cubit/language_cubit.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/cars_haraj_page/data/datasource/get_car_brand_models_datasource/get_car_brand_repository.dart';
import 'package:sun_web_system/features/cars_haraj_page/data/model/get_car_brand_models_model/car_brand_data_model.dart';
import 'package:sun_web_system/features/service_settings/data/datasource/get_car_brand_datasource/get_car_brand_models_repository.dart';
import 'package:sun_web_system/features/service_settings/data/datasource/get_services_datasource/get_services_repository.dart';
import 'package:sun_web_system/features/service_settings/data/model/create_service_package_model/create_service_package_request.dart';
import 'package:sun_web_system/features/service_settings/data/model/get_car_brand_models/car_model_data_model.dart';
import 'package:sun_web_system/features/service_settings/data/model/get_services_model/service_setting_model.dart';
import 'package:sun_web_system/features/service_settings/data/request/get_car_brand_request/get_car_brand_models_request.dart';
import '../car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/product_form_widgets.dart';

class PackageServicesField extends StatefulWidget {
  const PackageServicesField({
    super.key,
    required this.selectedIds,
    required this.onChanged,
    this.existingServices = const [],
    this.loader,
  });
  final List<int> selectedIds;
  final ValueChanged<List<int>> onChanged;
  final List<ServiceSettingModel> existingServices;
  final Future<List<ServiceSettingModel>> Function()? loader;

  @override
  State<PackageServicesField> createState() => _PackageServicesFieldState();
}

class _PackageServicesFieldState extends State<PackageServicesField> {
  late Future<List<ServiceSettingModel>> _services;
  @override
  void initState() {
    super.initState();
    _services = (widget.loader ?? getServicesFunction)();
  }

  @override
  Widget build(BuildContext context) {
    final ar = LanguageCubit.get(context).isAllAppLanguageArabic;
    return FutureBuilder<List<ServiceSettingModel>>(
      future: _services,
      builder: (context, snapshot) {
        final services = {
          for (final service in widget.existingServices)
            if ((service.id ?? 0) > 0) service.id!: service,
          for (final service in snapshot.data ?? <ServiceSettingModel>[])
            if ((service.id ?? 0) > 0 && (service.parentId ?? 0) > 0)
              service.id!: service,
        };
        return FormField<List<int>>(
          validator: (_) => snapshot.connectionState != ConnectionState.done
              ? (ar ? 'انتظر تحميل الخدمات' : 'Wait for services to load')
              : snapshot.hasError
                  ? (ar ? 'أعد تحميل الخدمات' : 'Retry loading services')
                  : widget.selectedIds.isEmpty
                      ? (ar
                          ? 'اختر خدمة واحدة على الأقل'
                          : 'Select at least one service')
                      : null,
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (snapshot.connectionState != ConnectionState.done)
                const LinearProgressIndicator(color: AppColors.orangeColor)
              else if (snapshot.hasError)
                _retry(
                    ar ? 'تعذر تحميل الخدمات' : 'Unable to load services',
                    () => setState(() =>
                        _services = (widget.loader ?? getServicesFunction)()))
              else if (services.isEmpty)
                _text(ar ? 'لا توجد خدمات متاحة' : 'No available services')
              else
                _selectionList([
                  for (final entry in services.entries)
                    _check(
                      key: ValueKey('package-service-${entry.key}'),
                      text: entry.value.getName(context),
                      selected: widget.selectedIds.contains(entry.key),
                      onChanged: (selected) {
                        final ids = widget.selectedIds.toSet();
                        selected ? ids.add(entry.key) : ids.remove(entry.key);
                        final updated = ids.toList();
                        field.didChange(updated);
                        widget.onChanged(updated);
                      },
                    ),
                ]),
              if (field.hasError) _error(field.errorText!),
            ],
          ),
        );
      },
    );
  }
}

class PackageCarSelection {
  int? brandId;
  final Set<int> modelIds;
  PackageCarSelection({this.brandId, Iterable<int> modelIds = const []})
      : modelIds = modelIds.toSet();

  SupportedCarRequest toRequest() =>
      SupportedCarRequest(carBrandId: brandId, carModelIds: modelIds.toList());
}

class PackageCarsField extends StatefulWidget {
  const PackageCarsField({
    super.key,
    required this.cars,
    required this.onChanged,
    this.brandsLoader,
    this.modelsLoader,
  });
  final List<PackageCarSelection> cars;
  final VoidCallback onChanged;
  final Future<List<CarBrandDataModel>> Function()? brandsLoader;
  final Future<List<CarModelDataModel>> Function(int)? modelsLoader;

  @override
  State<PackageCarsField> createState() => _PackageCarsFieldState();
}

class _PackageCarsFieldState extends State<PackageCarsField> {
  late Future<List<CarBrandDataModel>> _brands;
  final _models = <int, Future<List<CarModelDataModel>>>{};
  @override
  void initState() {
    super.initState();
    _brands = (widget.brandsLoader ?? getCarBrandFunction)();
  }

  Future<List<CarModelDataModel>> _loadModels(int brandId) =>
      _models.putIfAbsent(
        brandId,
        () =>
            widget.modelsLoader?.call(brandId) ??
            getCarBrandModelsFunction(
                request: GetCarBrandModelsRequest(carBrandId: brandId)),
      );

  @override
  Widget build(BuildContext context) {
    final ar = LanguageCubit.get(context).isAllAppLanguageArabic;
    return FormField<List<PackageCarSelection>>(
      validator: (_) => widget.cars.any(
                  (car) => (car.brandId ?? 0) <= 0 || car.modelIds.isEmpty) ||
              widget.cars.map((car) => car.brandId).toSet().length !=
                  widget.cars.length
          ? (ar
              ? 'حدد الماركة والموديلات لكل سيارة'
              : 'Select a brand and models for each car')
          : null,
      builder: (field) => FutureBuilder<List<CarBrandDataModel>>(
        future: _brands,
        builder: (context, snapshot) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (snapshot.connectionState != ConnectionState.done)
              const LinearProgressIndicator(color: AppColors.orangeColor)
            else if (snapshot.hasError)
              _retry(
                  ar ? 'تعذر تحميل الماركات' : 'Unable to load brands',
                  () => setState(() =>
                      _brands = (widget.brandsLoader ?? getCarBrandFunction)()))
            else ...[
              ProductCardsWrap(
                minCardWidth: 240,
                maxCardWidth: 320,
                children: [
                  for (final car in widget.cars)
                    Container(
                      key: ObjectKey(car),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.cardStroke),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ProductDropdownField<int>(
                            key: ValueKey(
                                'package-car-brand-${widget.cars.indexOf(car)}'),
                            label: ar ? 'ماركة السيارة' : 'Car brand',
                            value: car.brandId,
                            items: [
                              if (car.brandId != null &&
                                  !snapshot.data!
                                      .any((brand) => brand.id == car.brandId))
                                DropdownMenuItem(
                                    value: car.brandId,
                                    child: _text(
                                        '${ar ? 'ماركة' : 'Brand'} #${car.brandId}')),
                              for (final brand in snapshot.data!)
                                if ((brand.id ?? 0) > 0 &&
                                    (brand.id == car.brandId ||
                                        !widget.cars.any((other) =>
                                            other.brandId == brand.id)))
                                  DropdownMenuItem(
                                      value: brand.id,
                                      child: _text(brand.getName(context))),
                            ],
                            onChanged: (id) {
                              car.brandId = id;
                              car.modelIds.clear();
                              field.didChange(widget.cars);
                              widget.onChanged();
                            },
                          ),
                          if (car.brandId != null) ...[
                            const SizedBox(height: 10),
                            FutureBuilder<List<CarModelDataModel>>(
                              future: _loadModels(car.brandId!),
                              builder: (context, models) {
                                if (models.connectionState !=
                                    ConnectionState.done) {
                                  return const LinearProgressIndicator(
                                      color: AppColors.orangeColor);
                                }
                                if (models.hasError) {
                                  return _retry(
                                      ar
                                          ? 'تعذر تحميل الموديلات'
                                          : 'Unable to load models', () {
                                    setState(() => _models.remove(car.brandId));
                                  });
                                }
                                final available = {
                                  for (final model in models.data!)
                                    model.id: model
                                };
                                return _selectionList([
                                  for (final id in {
                                    ...available.keys,
                                    ...car.modelIds
                                  })
                                    if (id != null && id > 0)
                                      _check(
                                        key: ValueKey(
                                            'package-model-${car.brandId}-$id'),
                                        text: available[id]?.name ??
                                            '${ar ? 'موديل' : 'Model'} #$id',
                                        selected: car.modelIds.contains(id),
                                        onChanged: (selected) {
                                          selected
                                              ? car.modelIds.add(id)
                                              : car.modelIds.remove(id);
                                          field.didChange(widget.cars);
                                          widget.onChanged();
                                        },
                                      ),
                                ]);
                              },
                            ),
                          ],
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: IconButton(
                              tooltip: ar ? 'حذف السيارة' : 'Remove car',
                              icon: const Icon(Icons.delete_outline,
                                  color: AppColors.redColor, size: 20),
                              onPressed: () {
                                widget.cars.remove(car);
                                field.didChange(widget.cars);
                                widget.onChanged();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  onPressed: snapshot.data!.isEmpty
                      ? null
                      : () {
                          widget.cars.add(PackageCarSelection());
                          field.didChange(widget.cars);
                          widget.onChanged();
                        },
                  icon: const Icon(Icons.add,
                      color: AppColors.orangeColor, size: 20),
                  label: _text(ar ? 'إضافة سيارة' : 'Add car',
                      color: AppColors.orangeColor),
                ),
              ),
            ],
            if (field.hasError) _error(field.errorText!),
          ],
        ),
      ),
    );
  }
}

Widget _text(String text, {Color color = AppColors.darkColor}) =>
    TextInAppWidget(text: text, textSize: 13, textColor: color);

Widget _error(String text) => Padding(
    padding: const EdgeInsets.only(top: 6),
    child: _text(text, color: AppColors.redColor));

Widget _retry(String message, VoidCallback onPressed) => TextButton.icon(
    onPressed: onPressed,
    icon: const Icon(Icons.refresh, color: AppColors.orangeColor, size: 18),
    label: _text(message, color: AppColors.orangeColor));

Widget _selectionList(List<Widget> children) => Material(
    color: AppColors.scaffoldColor,
    borderRadius: BorderRadius.circular(10),
    clipBehavior: Clip.antiAlias,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 180),
      child: SingleChildScrollView(
          primary: false, child: Column(children: children)),
    ));

Widget _check(
        {Key? key,
        required String text,
        required bool selected,
        required ValueChanged<bool> onChanged}) =>
    CheckboxListTile(
      key: key,
      value: selected,
      onChanged: (value) => onChanged(value == true),
      activeColor: AppColors.orangeColor,
      dense: true,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: const EdgeInsets.symmetric(horizontal: 6),
      title: _text(text),
    );
