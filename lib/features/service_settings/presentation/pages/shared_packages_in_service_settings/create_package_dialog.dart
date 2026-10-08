import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/language/language_cubit/language_cubit.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/cars_haraj_page/data/model/get_car_brand_models_model/car_brand_data_model.dart';
import 'package:sun_web_system/features/service_settings/data/model/create_service_package_model/create_service_package_request.dart';
import 'package:sun_web_system/features/service_settings/data/model/get_car_brand_models/car_model_data_model.dart';
import 'package:sun_web_system/features/service_settings/data/model/get_provider_service_packages_model/provider_service_packages_model.dart';
import 'package:sun_web_system/features/service_settings/data/model/get_services_model/service_setting_model.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/get_tax_cubit/get_tax_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/get_tax_cubit/get_tax_state.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/provider_packages_cubit/provider_packages_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/provider_packages_cubit/provider_packages_state.dart';
import 'package:sun_web_system/features/service_settings/presentation/custom_widget/provider_service_branches.dart';
import '../car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/product_form_widgets.dart';
import '../car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/product_money_field.dart';
import 'package_selections_fields.dart';
import 'select_tax_packages.dart';

class CreatePackageDialog extends StatefulWidget {
  final ProviderServicePackagesModel? package;
  final Future<List<ServiceSettingModel>> Function()? servicesLoader;
  final Future<List<CarBrandDataModel>> Function()? brandsLoader;
  final Future<List<CarModelDataModel>> Function(int)? modelsLoader;
  const CreatePackageDialog(
      {super.key,
      this.package,
      this.servicesLoader,
      this.brandsLoader,
      this.modelsLoader});

  @override
  State<CreatePackageDialog> createState() => _CreatePackageDialogState();
}

class _PackageItemControllers {
  final TextEditingController item;
  final TextEditingController latinItem;
  _PackageItemControllers({String text = '', String latinText = ''})
      : item = TextEditingController(text: text),
        latinItem = TextEditingController(text: latinText);
  void dispose() {
    item.dispose();
    latinItem.dispose();
  }
}

class _CreatePackageDialogState extends State<CreatePackageDialog> {
  final _formKey = GlobalKey<FormState>();
  List<int> selectedBranchIds = [];
  List<int> selectedServiceIds = [];
  final nameController = TextEditingController();
  final latinNameController = TextEditingController();
  final priceController = TextEditingController();
  final costController = TextEditingController();
  final items = <_PackageItemControllers>[];
  final cars = <PackageCarSelection>[];
  bool _carsChanged = false;
  bool get isEdit => widget.package != null;

  @override
  void initState() {
    super.initState();
    final package = widget.package;
    if (package != null) {
      selectedBranchIds = List.of(package.effectiveBranchIds);
      selectedServiceIds = package.services
          .map((service) => service.id)
          .whereType<int>()
          .where((id) => id > 0)
          .toSet()
          .toList();
      nameController.text = package.package.name;
      latinNameController.text = package.package.latinName;
      priceController.text = package.package.price.toString();
      costController.text = package.package.cost.toString();
      for (final row in package.items) {
        items.add(
            _PackageItemControllers(text: row.item, latinText: row.latinItem));
      }
      for (final car in package.supportedCars ?? <SupportedCarRequest>[]) {
        cars.add(PackageCarSelection(
            brandId: car.carBrandId, modelIds: car.carModelIds ?? []));
      }
    }
    if (items.isEmpty) items.add(_PackageItemControllers());
  }

  @override
  void dispose() {
    nameController.dispose();
    latinNameController.dispose();
    priceController.dispose();
    costController.dispose();
    for (final row in items) {
      row.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ar = LanguageCubit.get(context).isAllAppLanguageArabic;
    return BlocListener<ProviderPackagesCubit, ProviderPackagesState>(
      listener: (context, state) {
        if (state is ProviderPackagesError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is ProviderPackagesCreateSuccess ||
            state is ProviderPackagesUpdateSuccess) {
          Navigator.pop(context, true);
        }
      },
      child: Theme(
        data: ProductFormStyle.theme(context),
        child: AlertDialog(
          backgroundColor: AppColors.whiteColor,
          surfaceTintColor: AppColors.transparent,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          title: TextInAppWidget(
            text: isEdit
                ? (ar ? 'تعديل باقة خدمة' : 'Edit service package')
                : (ar ? 'إضافة باقة خدمة' : 'Add service package'),
            textSize: 18,
            fontWeightIndex: FontSelectionData.semiBoldFontFamily,
            textColor: AppColors.orangeColor,
          ),
          content: SizedBox(
            width: 680,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ProductCardsWrap(
                          minCardWidth: 220,
                          maxCardWidth: 320,
                          children: [
                            ProductTextField(
                                key: const ValueKey('package-name'),
                                label: AppLanguageKeys.name,
                                controller: nameController),
                            ProductTextField(
                                key: const ValueKey('package-latinname'),
                                label: AppLanguageKeys.latinName,
                                controller: latinNameController,
                                latin: true),
                          ]),
                      const SizedBox(height: 16),
                      ProviderServiceBranchesField(
                        branchIds: selectedBranchIds,
                        availableBranches:
                            widget.package?.availableBranches ?? const [],
                        onChanged: (ids) =>
                            setState(() => selectedBranchIds = ids),
                      ),
                      const SizedBox(height: 16),
                      ProductFormSection(
                        title: ar ? 'بنود الباقة' : 'Package items',
                        icon: Icons.list_alt,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (var index = 0; index < items.length; index++)
                                _itemCard(index, ar),
                              Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: TextButton.icon(
                                  key: const ValueKey('add-package-item'),
                                  onPressed: () => setState(() =>
                                      items.add(_PackageItemControllers())),
                                  icon: const Icon(Icons.add,
                                      color: AppColors.orangeColor, size: 20),
                                  label: TextInAppWidget(
                                      text: ar ? 'إضافة بند' : 'Add item',
                                      textSize: 13,
                                      textColor: AppColors.orangeColor),
                                ),
                              ),
                            ]),
                      ),
                      const SizedBox(height: 16),
                      ProductFormSection(
                        title: ar ? 'التسعير' : 'Pricing',
                        icon: Icons.payments_outlined,
                        child: ProductCardsWrap(
                            minCardWidth: 160,
                            maxCardWidth: 210,
                            children: [
                              ProductMoneyField(
                                  key: const ValueKey('package-price'),
                                  controller: priceController),
                              ProductMoneyField(
                                  key: const ValueKey('package-cost'),
                                  controller: costController,
                                  cost: true),
                              const SelectTaxPackages(),
                            ]),
                      ),
                      const SizedBox(height: 16),
                      ProductFormSection(
                        title: ar ? 'الخدمات المشمولة' : 'Included services',
                        icon: Icons.build_outlined,
                        child: PackageServicesField(
                          selectedIds: selectedServiceIds,
                          onChanged: (ids) =>
                              setState(() => selectedServiceIds = ids),
                          loader: widget.servicesLoader,
                          existingServices: [
                            for (final service
                                in widget.package?.services ?? [])
                              ServiceSettingModel(
                                  id: service.id,
                                  parentId: service.parentId,
                                  name: service.name,
                                  latinName: service.latinName),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ProductFormSection(
                        title: ar ? 'السيارات المتوافقة' : 'Compatible cars',
                        icon: Icons.directions_car_outlined,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (isEdit &&
                                  widget.package!.supportedCars == null &&
                                  !_carsChanged) ...[
                                TextInAppWidget(
                                  text: ar
                                      ? 'تحديد سيارات جديدة هيستبدل السيارات الحالية.'
                                      : 'Choosing new cars will replace the current compatible cars.',
                                  textSize: 12,
                                  textColor: AppColors.darkGreyColor,
                                ),
                                const SizedBox(height: 10),
                              ],
                              PackageCarsField(
                                cars: cars,
                                onChanged: () =>
                                    setState(() => _carsChanged = true),
                                brandsLoader: widget.brandsLoader,
                                modelsLoader: widget.modelsLoader,
                              ),
                            ]),
                      ),
                    ]),
              ),
            ),
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const TextInAppWidget(
                    text: AppLanguageKeys.cancel,
                    textSize: 14,
                    textColor: AppColors.darkColor)),
            BlocBuilder<ProviderPackagesCubit, ProviderPackagesState>(
                builder: (context, state) {
              final loading = state is ProviderPackagesLoading;
              return FilledButton(
                key: const ValueKey('save-package'),
                style: FilledButton.styleFrom(
                    backgroundColor: AppColors.orangeColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed: loading ? null : _submit,
                child: loading
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.whiteColor))
                    : TextInAppWidget(
                        text: isEdit
                            ? AppLanguageKeys.edit
                            : AppLanguageKeys.create,
                        textSize: 14,
                        textColor: AppColors.whiteColor),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _itemCard(int index, bool ar) {
    final row = items[index];
    return Container(
      key: ObjectKey(row),
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Expanded(
              child: TextInAppWidget(
                  text: '${ar ? 'البند' : 'Item'} ${index + 1}',
                  textSize: 12,
                  textColor: AppColors.darkGreyColor)),
          if (items.length > 1)
            IconButton(
                icon: const Icon(Icons.close,
                    color: AppColors.redColor, size: 18),
                tooltip: ar ? 'حذف البند' : 'Remove item',
                onPressed: () => setState(() {
                      items.remove(row);
                      row.dispose();
                    })),
        ]),
        ProductCardsWrap(minCardWidth: 240, maxCardWidth: 320, children: [
          ProductTextField(
              key: ValueKey('package-item-$index-arabic'),
              label: ar ? 'البند بالعربي' : 'Arabic item',
              controller: row.item),
          ProductTextField(
              key: ValueKey('package-item-$index-latin'),
              label: ar ? 'البند باللاتيني' : 'Latin item',
              controller: row.latinItem,
              latin: true),
        ]),
      ]),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final taxCubit = context.read<GetTaxCubit>();
    final tax = taxCubit.selectedTax;
    if (taxCubit.state is! GetTaxSuccess || tax == null) {
      final ar = LanguageCubit.get(context).isAllAppLanguageArabic;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextInAppWidget(
          text: ar ? 'اختر الضريبة بعد تحميلها' : 'Select a tax after loading',
          textSize: 14,
          textColor: AppColors.whiteColor,
        ),
      ));
      return;
    }
    final packageItems = [
      for (final row in items)
        PackageItemRequest(
          packageId: widget.package?.package.id ?? 0,
          item: row.item.text.trim(),
          latinItem: row.latinItem.text.trim(),
        )
    ];
    final supportedCars =
        isEdit && widget.package!.supportedCars == null && !_carsChanged
            ? null
            : cars.map((car) => car.toRequest()).toList();
    final cubit = context.read<ProviderPackagesCubit>();
    if (isEdit) {
      cubit.updatePackage(
        id: widget.package!.package.id,
        name: nameController.text.trim(),
        latinName: latinNameController.text.trim(),
        items: packageItems,
        price: num.parse(priceController.text.trim()),
        cost: num.parse(costController.text.trim()),
        tax: tax.taxId,
        branchIds: selectedBranchIds,
        serviceIds: selectedServiceIds,
        supportedCars: supportedCars,
      );
    } else {
      cubit.createPackage(
        name: nameController.text.trim(),
        latinName: latinNameController.text.trim(),
        items: packageItems,
        price: num.parse(priceController.text.trim()),
        cost: num.parse(costController.text.trim()),
        tax: tax.taxId,
        branchIds: selectedBranchIds,
        serviceIds: selectedServiceIds,
        supportedCars: supportedCars!,
      );
    }
  }
}
