import 'package:sun_web_system/core/language/language_cubit/language_cubit.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/branch_cubit/branch_cubit.dart';
import 'product_money_field.dart';
import 'product_stock_controller.dart';
import 'product_stocks_editor.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/advertisements/presentation/pages/first_screen_advertisements/screens/last_button_in_list_data_first_screen_advertisements.dart';

import '../../../../../../data/model/get_car_brand_models/car_model_data_model.dart';
import '../../../../../../data/request/create_product_request/create_product_request.dart';
import 'package:sun_web_system/features/service_settings/data/model/get_products_by_category_model/product_model_get_products_by_category.dart';
import '../../../../../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../../../../../features/service_settings/presentation/pages/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/car_selection_controller.dart';
import '../../../../../../../../features/service_settings/presentation/pages/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/car_selection_item_widget.dart';
import '../../../../../../../../features/service_settings/presentation/pages/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/image_compressor.dart';
import '../../../../../../../../features/service_settings/presentation/pages/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/is_new_switch.dart';
import '../../../../../../../../features/service_settings/presentation/pages/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/select_product_category.dart';
import '../../../../../../../../features/service_settings/presentation/pages/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/select_tax_product.dart';
import '../../../../../../../../features/service_settings/presentation/pages/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/size_controllers.dart';
import '../../../../../../../../features/service_settings/presentation/pages/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/size_item_widget.dart';
import 'product_form_widgets.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import '../../../../../../../../features/service_settings/presentation/bloc/car_selection_cubit/CarSelectionCubit.dart';
import '../../../../../../../../features/service_settings/presentation/bloc/create_product_cubit/create_product_cubit.dart';
import '../../../../../../../../features/service_settings/presentation/bloc/create_product_cubit/create_product_state.dart';
import '../../../../../../../../features/service_settings/presentation/bloc/get_all_product_categories_cubit/get_all_product_categories_cubit.dart';
import '../../../../../../../../features/service_settings/presentation/bloc/get_all_product_categories_cubit/get_all_product_categories_state.dart';
import '../../../../../../../../features/service_settings/presentation/bloc/get_tax_cubit/get_tax_cubit.dart';
import '../../../../../../../../features/service_settings/presentation/bloc/get_tax_cubit/get_tax_state.dart';
import '../../../../../../../../features/service_settings/presentation/bloc/select_car_model_setting_cubit/select_car_model_setting_cubit.dart';
import '../../../../../../../../core/language/language_constant.dart';
import 'package:image_picker/image_picker.dart';

class OtherDataDataContainerInListDataAddSparePartsInServiceSettings
    extends StatefulWidget {
  final ProductModelGetProductsByCategory? product;

  const OtherDataDataContainerInListDataAddSparePartsInServiceSettings({
    super.key,
    this.product,
  });

  @override
  State<OtherDataDataContainerInListDataAddSparePartsInServiceSettings>
      createState() =>
          _OtherDataDataContainerInListDataAddSparePartsInServiceSettingsState();
}

class _OtherDataDataContainerInListDataAddSparePartsInServiceSettingsState
    extends State<
        OtherDataDataContainerInListDataAddSparePartsInServiceSettings> {
  bool isNewValue = false;
  bool get isUpdate => widget.product != null;

  bool _taxInitialized = false;
  bool _categoryInitialized = false;

  final nameController = TextEditingController();
  final latinNameController = TextEditingController();
  final descController = TextEditingController();
  final latinDescController = TextEditingController();
  final priceController = TextEditingController();
  final costController = TextEditingController();
  final instructionsController = TextEditingController();
  bool hasSizes = false;
  bool _preparing = false;
  final List<ProductStockController> generalStocks = [];

  List<CarSelectionController> cars = [CarSelectionController()];
  List<SizeControllers> sizes = [];
  final formKey = GlobalKey<FormState>();

  Uint8List? imageBytes;

  Future<void> pickImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (file != null) {
      final original = await file.readAsBytes();

      final compressed = await ImageCompressor.compressImage(
        original,
        minWidth: 800,
        minHeight: 800,
        quality: 70,
      );

      if (!mounted) return;
      setState(() {
        imageBytes = compressed;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    if (isUpdate) {
      final p = widget.product!;

      nameController.text = p.name ?? "";
      latinNameController.text = p.latinName ?? "";
      descController.text = p.description ?? "";
      latinDescController.text = p.latinDesc ?? "";
      instructionsController.text = p.instructions ?? "";
      priceController.text = p.price?.toString() ?? "";
      costController.text = p.cost?.toString() ?? "";
      hasSizes = p.sizes.isNotEmpty;
      generalStocks
          .addAll(p.generalBranchStocks.map(ProductStockController.fromStock));

      isNewValue = p.isNew ?? false;
      imageBytes = p.image;

      sizes = p.sizes.map((s) {
        return SizeControllers(
          id: s.id,
          stocks: s.branchStocks.map(ProductStockController.fromStock).toList(),
          nameController: TextEditingController(text: s.name),
          latinNameController: TextEditingController(text: s.latinName),
          priceController: TextEditingController(text: s.price?.toString()),
          costController: TextEditingController(text: s.cost?.toString()),
        );
      }).toList();

      cars = p.brands.map((b) {
        return CarSelectionController()
          ..brandId = b.brandId
          ..selectedModelIds =
              b.models.map((m) => m.modelId).whereType<int>().toList()
          ..models = b.models.map((m) {
            return CarModelDataModel(
              id: m.modelId,
              name: m.modelName,
            );
          }).toList();
      }).toList();

      if (cars.isEmpty) cars = [CarSelectionController()];
    }
  }

  @override
  Widget build(BuildContext context) {
    final ar = LanguageCubit.get(context).isAllAppLanguageArabic;
    return LayoutBuilder(builder: (context, constraints) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => BranchCubit()..getProviderBranches()),
          BlocProvider(create: (_) => GetTaxCubit()..getTax()),
          BlocProvider(
              create: (_) =>
                  GetAllProductCategoriesCubit()..getAllProductCategories()),
          BlocProvider(
              create: (_) => SelectCarModelSettingCubit()..fetchBrands()),
          BlocProvider(create: (_) => CarSelectionCubit()),
          BlocProvider(
            create: (_) => CreateProductCubit(
              productId: widget.product?.id,
            ),
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<GetTaxCubit, GetTaxState>(
              listener: (context, state) {
                if (state is GetTaxSuccess && isUpdate && !_taxInitialized) {
                  final p = widget.product!;
                  final cubit = context.read<GetTaxCubit>();

                  final tax =
                      cubit.taxes.where((t) => t.taxId == p.taxId).firstOrNull;
                  if (tax != null) cubit.selectTax(tax);

                  _taxInitialized = true;
                }
              },
            ),
            BlocListener<GetAllProductCategoriesCubit,
                GetAllProductCategoriesState>(
              listener: (context, state) {
                if (state is GetAllProductCategoriesSuccess &&
                    isUpdate &&
                    !_categoryInitialized) {
                  final p = widget.product!;
                  final cubit = context.read<GetAllProductCategoriesCubit>();

                  final category = cubit.categories
                      .where((c) => c.id == p.productCategoryId)
                      .firstOrNull;
                  if (category != null) cubit.selectCategory(category);

                  _categoryInitialized = true;
                }
              },
            ),
          ],
          child: Builder(builder: (context) {
            return AbsorbPointer(
                absorbing: _preparing,
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductFormSection(
                        title: ar ? 'بيانات المنتج' : 'Product information',
                        icon: Icons.inventory_2_outlined,
                        child: ProductBasicsLayout(
                          image: ProductImagePicker(
                              bytes: imageBytes, onTap: pickImage),
                          primaryColumn: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ProductTextField(
                                  label: AppLanguageKeys.name,
                                  controller: nameController),
                              const SizedBox(height: 12),
                              const SelectProductCategory(),
                            ],
                          ),
                          secondaryColumn: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ProductTextField(
                                  label: AppLanguageKeys.latinName,
                                  controller: latinNameController,
                                  latin: true),
                              const SizedBox(height: 12),
                              IsNewSwitch(
                                  initialValue: isNewValue,
                                  onChanged: (value) =>
                                      setState(() => isNewValue = value)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ProductFormSection(
                        title: ar
                            ? 'الوصف والتعليمات'
                            : 'Description and instructions',
                        icon: Icons.description_outlined,
                        child: ProductCardsWrap(
                          children: [
                            ProductTextField(
                                label: AppLanguageKeys.description,
                                controller: descController,
                                lines: 5),
                            ProductTextField(
                                label: AppLanguageKeys.latinDesc,
                                controller: latinDescController,
                                lines: 5,
                                latin: true),
                            ProductTextField(
                                label: AppLanguageKeys.instructions,
                                controller: instructionsController,
                                lines: 5),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ProductFormSection(
                        title: ar ? 'السيارات المتوافقة' : 'Compatible cars',
                        icon: Icons.directions_car_outlined,
                        child: ProductCardsWrap(
                          children: List.generate(cars.length, (index) {
                            final unavailableBrandIds = cars.indexed
                                .where((entry) => entry.$1 != index)
                                .map((entry) => entry.$2.brandId)
                                .whereType<int>()
                                .toSet();
                            final allBrandsElsewhere = cars.indexed.any(
                                (entry) =>
                                    entry.$1 != index &&
                                    entry.$2.isAllBrandsSelected);
                            return CarSelectionItemWidget(
                              key: ObjectKey(cars[index]),
                              controller: cars[index],
                              unavailableBrandIds: unavailableBrandIds,
                              isAllBrandsSelectedElsewhere: allBrandsElsewhere,
                              onSelectionChanged: () => setState(() {}),
                              showDelete: cars.length > 1,
                              onAdd: () => setState(() => cars.insert(
                                  index + 1, CarSelectionController())),
                              onDelete: () =>
                                  setState(() => cars.removeAt(index)),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ProductFormSection(
                        title: ar ? 'التسعير والمخزون' : 'Pricing and stock',
                        icon: Icons.payments_outlined,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ProductCardsWrap(
                              minCardWidth: 280,
                              maxCardWidth: 380,
                              children: [
                                const SelectTaxProduct(),
                                ProductToggleField(
                                  label: ar
                                      ? 'المنتج له مقاسات'
                                      : 'Product has sizes',
                                  value: hasSizes,
                                  trueText: ar ? 'بمقاسات' : 'With sizes',
                                  falseText:
                                      ar ? 'بدون مقاسات' : 'Without sizes',
                                  onChanged: (value) => setState(() {
                                    hasSizes = value;
                                    if (value && sizes.isEmpty) {
                                      sizes.add(SizeControllers());
                                    }
                                  }),
                                ),
                                if (!hasSizes)
                                  ProductCardsWrap(
                                    minCardWidth: 120,
                                    maxCardWidth: 190,
                                    children: [
                                      ProductMoneyField(
                                          controller: priceController),
                                      ProductMoneyField(
                                          controller: costController,
                                          cost: true),
                                    ],
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (!hasSizes)
                              Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 380),
                                  child: ProductStocksEditor(
                                      stocks: generalStocks),
                                ),
                              ),
                            if (hasSizes) ...[
                              if (sizes.isEmpty)
                                FormField<void>(
                                  validator: (_) => ar
                                      ? 'أضف مقاسًا واحدًا على الأقل'
                                      : 'Add at least one size',
                                  builder: (field) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      OutlinedButton.icon(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor:
                                              AppColors.orangeColor,
                                          side: const BorderSide(
                                              color: AppColors.orangeColor),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                        ),
                                        icon: const Icon(Icons.add),
                                        label: TextInAppWidget(
                                            text:
                                                ar ? 'إضافة مقاس' : 'Add size',
                                            textSize: 13,
                                            textColor: AppColors.orangeColor),
                                        onPressed: () => setState(
                                            () => sizes.add(SizeControllers())),
                                      ),
                                      if (field.hasError)
                                        TextInAppWidget(
                                            text: field.errorText!,
                                            textSize: 11,
                                            textColor: AppColors.redColor),
                                    ],
                                  ),
                                ),
                              ProductCardsWrap(
                                children: [
                                  for (final (index, size) in sizes.indexed)
                                    SizeItemWidget(
                                      key: ObjectKey(size),
                                      title:
                                          '${ar ? 'المقاس' : 'Size'} ${index + 1}',
                                      controllers: size,
                                      itemWidth: 380,
                                      onDelete: () {
                                        setState(() => sizes.remove(size));
                                        size.dispose();
                                      },
                                      onAdd: () => setState(() => sizes.insert(
                                          index + 1, SizeControllers())),
                                    ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      BlocListener<CreateProductCubit, CreateProductState>(
                        listener: (context, state) {
                          if (state is CreateProductSuccess) {
                            AppSnackBar.showSuccess(AppLanguageKeys.success);

                            Navigator.pop(context, true);
                          }

                          if (state is CreateProductError) {
                            AppSnackBar.showError(state.error);
                          }
                        },
                        child:
                            BlocBuilder<CreateProductCubit, CreateProductState>(
                          builder: (context, state) {
                            final isLoading =
                                state is CreateProductLoading || _preparing;

                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                LastButtonInListDataFirstScreenAdvertisements(
                                    text: isLoading
                                        ? " "
                                        : isUpdate
                                            ? AppLanguageKeys.edit
                                            : AppLanguageKeys.save,
                                    onTap: isLoading
                                        ? null
                                        : () async {
                                            if (!formKey.currentState!
                                                .validate()) {
                                              AppSnackBar.showError(
                                                  AppLanguageKeys
                                                      .enterYourData);
                                              return;
                                            }

                                            final taxCubit =
                                                context.read<GetTaxCubit>();
                                            final categoryCubit = context.read<
                                                GetAllProductCategoriesCubit>();

                                            if (taxCubit.selectedTax == null) {
                                              AppSnackBar.showError(
                                                  AppLanguageKeys
                                                      .enterYourData);
                                              return;
                                            }

                                            if (categoryCubit
                                                    .selectedCategory ==
                                                null) {
                                              AppSnackBar.showError(
                                                  AppLanguageKeys
                                                      .enterYourData);
                                              return;
                                            }

                                            bool hasValidCar = cars.any((c) {
                                              if (c.isAllBrandsSelected) {
                                                return true;
                                              }

                                              if (c.brandId == null) {
                                                return false;
                                              }

                                              bool isAllModelsSelected = c
                                                      .models.isNotEmpty &&
                                                  c.selectedModelIds.length ==
                                                      c.models.length;

                                              if (isAllModelsSelected) {
                                                return true;
                                              }

                                              return c
                                                  .selectedModelIds.isNotEmpty;
                                            });

                                            if (!hasValidCar) {
                                              AppSnackBar.showError(
                                                  AppLanguageKeys
                                                      .selectCarModelByServices);
                                              return;
                                            }

                                            setState(() => _preparing = true);
                                            try {
                                              List<ProductBrand> brands = [];
                                              List<ProductCarModel> carModels =
                                                  [];

                                              final allBrandsSelected =
                                                  cars.any((c) =>
                                                      c.isAllBrandsSelected);

                                              if (allBrandsSelected) {
                                                final carCubit = context
                                                    .read<CarSelectionCubit>();
                                                final allBrands = context
                                                    .read<
                                                        SelectCarModelSettingCubit>()
                                                    .state
                                                    .brands;
                                                if (allBrands.isEmpty) {
                                                  throw StateError(ar
                                                      ? 'تعذر تحميل ماركات السيارات'
                                                      : 'Unable to load car brands');
                                                }

                                                for (var brand in allBrands) {
                                                  brands.add(ProductBrand(
                                                      brandid: brand.id));

                                                  final models = await carCubit
                                                      .getModels(brand.id!);

                                                  for (var model in models) {
                                                    carModels.add(
                                                      ProductCarModel(
                                                        carBrandId: brand.id!,
                                                        carModelId: model.id!,
                                                        productCarBrandId: 0,
                                                      ),
                                                    );
                                                  }
                                                }
                                              } else {
                                                brands = cars
                                                    .where((c) =>
                                                        c.brandId != null)
                                                    .map((c) => ProductBrand(
                                                        brandid: c.brandId!))
                                                    .toList();

                                                carModels = cars.expand((c) {
                                                  return c.selectedModelIds
                                                      .map((modelId) {
                                                    return ProductCarModel(
                                                      carBrandId: c.brandId!,
                                                      carModelId: modelId,
                                                      productCarBrandId: 0,
                                                    );
                                                  });
                                                }).toList();
                                              }
                                              if (!context.mounted) return;
                                              final sizesList = hasSizes
                                                  ? sizes
                                                      .map((s) => ProductSize(
                                                            id: s.id,
                                                            name: s
                                                                .nameController
                                                                .text
                                                                .trim(),
                                                            latinName: s
                                                                .latinNameController
                                                                .text
                                                                .trim(),
                                                            price: num.parse(s
                                                                .priceController
                                                                .text
                                                                .trim()),
                                                            cost: num.parse(s
                                                                .costController
                                                                .text
                                                                .trim()),
                                                            branchStocks: s
                                                                .stocks
                                                                .map((stock) =>
                                                                    stock
                                                                        .toRequest())
                                                                .toList(),
                                                          ))
                                                      .toList()
                                                  : <ProductSize>[];

                                              final request =
                                                  CreateProductRequest(
                                                name:
                                                    nameController.text.trim(),
                                                latinName: latinNameController
                                                    .text
                                                    .trim(),
                                                description:
                                                    descController.text.trim(),
                                                latinDesc: latinDescController
                                                    .text
                                                    .trim(),
                                                instructions:
                                                    instructionsController.text
                                                        .trim(),
                                                price: hasSizes
                                                    ? widget.product?.price
                                                    : num.parse(priceController
                                                        .text
                                                        .trim()),
                                                cost: hasSizes
                                                    ? widget.product?.cost
                                                    : num.parse(costController
                                                        .text
                                                        .trim()),
                                                branchStocks: hasSizes
                                                    ? []
                                                    : generalStocks
                                                        .map((stock) =>
                                                            stock.toRequest())
                                                        .toList(),
                                                isNew: isNewValue,
                                                image: imageBytes,
                                                taxId:
                                                    taxCubit.selectedTax!.taxId,
                                                productCategoryId: categoryCubit
                                                    .selectedCategory!.id,
                                                brands: brands,
                                                carModels: carModels,
                                                sizes: sizesList,
                                              );

                                              final cubit = context
                                                  .read<CreateProductCubit>();

                                              if (isUpdate) {
                                                await cubit.updateProduct(
                                                    request: request);
                                              } else {
                                                await cubit.createProduct(
                                                    request: request);
                                              }
                                            } catch (error) {
                                              if (mounted) {
                                                AppSnackBar.showError(
                                                    error.toString());
                                              }
                                            } finally {
                                              if (mounted) {
                                                setState(
                                                    () => _preparing = false);
                                              }
                                            }
                                          }),
                                if (isLoading)
                                  const Positioned.fill(
                                    child: Center(
                                      child: SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ));
          }),
        ),
      );
    });
  }

  @override
  void dispose() {
    for (final controller in [
      nameController,
      latinNameController,
      descController,
      latinDescController,
      priceController,
      costController,
      instructionsController
    ]) {
      controller.dispose();
    }
    for (final stock in generalStocks) {
      stock.dispose();
    }
    for (final size in sizes) {
      size.dispose();
    }
    super.dispose();
  }
}
