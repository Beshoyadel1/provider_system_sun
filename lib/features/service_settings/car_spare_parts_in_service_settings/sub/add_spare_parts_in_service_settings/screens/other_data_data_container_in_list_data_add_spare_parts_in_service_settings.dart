import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import '../../../../../../../../core/api_functions/general/car/car_model/get_car_brand_models/car_model_data_model.dart';
import '../../../../../../../../core/api_functions/product/create_product_model/create_product_request.dart';
import '../../../../../../../../core/api_functions/product/get_products_by_category_model/product_model_get_products_by_category.dart';
import '../../../../../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/car_selection_controller.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/car_selection_item_widget.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/image_compressor.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/is_new_switch.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/select_product_category.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/select_tax_product.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/size_controllers.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/size_item_widget.dart';
import '../../../../../../../../features/service_settings/custom_widget/text_with_text_form_field_as_column2_widget.dart';
import '../../../../../../../../features/service_settings/logic/car_selection_cubit/CarSelectionCubit.dart';
import '../../../../../../../../features/service_settings/logic/create_product_cubit/create_product_cubit.dart';
import '../../../../../../../../features/service_settings/logic/create_product_cubit/create_product_state.dart';
import '../../../../../../../../features/service_settings/logic/get_all_product_categories_cubit/get_all_product_categories_cubit.dart';
import '../../../../../../../../features/service_settings/logic/get_all_product_categories_cubit/get_all_product_categories_state.dart';
import '../../../../../../../../features/service_settings/logic/get_tax_cubit/get_tax_cubit.dart';
import '../../../../../../../../features/service_settings/logic/get_tax_cubit/get_tax_state.dart';
import '../../../../../../../../features/service_settings/logic/select_car_model_setting_cubit/select_car_model_setting_cubit.dart';
import '../../../../../../../../features/advertisements/first_screen_advertisements/screens/last_button_in_list_data_first_screen_advertisements.dart';
import '../../../../../../../../features/permissions/custom_widget/text_with_container_as_column_widget.dart';
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
  final inStockController = TextEditingController();

  List<CarSelectionController> cars = [CarSelectionController()];
  List<SizeControllers> sizes = [];
  final formKey = GlobalKey<FormState>();

  Uint8List? imageBytes;
  String? imageName;

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

      setState(() {
        imageBytes = compressed;
        imageName = file.name;
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
      inStockController.text = p.inStock?.toString() ?? "";

      isNewValue = p.isNew ?? false;
      imageBytes = p.image;

      sizes = p.sizes.map((s) {
        return SizeControllers(
          nameController: TextEditingController(text: s.name),
          latinNameController: TextEditingController(text: s.latinName),
          priceController: TextEditingController(text: s.price?.toString()),
          costController: TextEditingController(text: s.cost?.toString()),
        );
      }).toList();

      if (sizes.isEmpty) sizes = [SizeControllers()];

      cars = p.brands.map((b) {
        return CarSelectionController()
          ..brandId = b.brandId
          ..selectedModelIds =
          b.models.map((m) => m.modelId!).toList()
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
    final width = MediaQuery.of(context).size.width;

    int itemsPerRow = width > 1000
        ? 4
        : width > 600
        ? 2
        : 1;

    final itemWidth =
        (width - ((itemsPerRow - 1) * 10)) / itemsPerRow;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetTaxCubit()..getTax()),
        BlocProvider(create: (_) => GetAllProductCategoriesCubit()..getAllProductCategories()),
        BlocProvider(create: (_) => SelectCarModelSettingCubit()..fetchBrands()),
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
              if (state is GetTaxSuccess &&
                  isUpdate &&
                  !_taxInitialized) {

                final p = widget.product!;
                final cubit = context.read<GetTaxCubit>();

                final tax = cubit.taxes.firstWhere(
                      (t) => t.taxId == p.taxId,
                  orElse: () => cubit.taxes.first,
                );

                cubit.selectTax(tax);

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
                final cubit =
                context.read<GetAllProductCategoriesCubit>();

                final category = cubit.categories.firstWhere(
                      (c) => c.id == p.productCategoryId,
                  orElse: () => cubit.categories.first,
                );

                cubit.selectCategory(category);

                _categoryInitialized = true;
              }
            },
          ),
        ],

        child: SingleChildScrollView(
          child: Builder(builder: (context) {
            return Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Wrap(
                    spacing: 10,
                    runSpacing: 20,
                    children: [

                      _item(itemWidth, TextWithTextFormFieldAsColumn2Widget(
                        text: AppLanguageKeys.name,
                        textFormController: nameController,
                      )),

                      _item(itemWidth, TextWithTextFormFieldAsColumn2Widget(
                        text: AppLanguageKeys.latinName,
                        textFormController: latinNameController,
                      )),

                      _item(itemWidth, const SelectTaxProduct()),

                      _item(itemWidth, TextWithTextFormFieldAsColumn2Widget(
                        text: AppLanguageKeys.description,
                        textFormController: descController,
                        maxLines: 5,
                      )),

                      _item(itemWidth, TextWithTextFormFieldAsColumn2Widget(
                        text: AppLanguageKeys.latinDesc,
                        textFormController: latinDescController,
                        maxLines: 5,
                      )),

                      _item(itemWidth, TextWithTextFormFieldAsColumn2Widget(
                        text: AppLanguageKeys.instructions,
                        textFormController: instructionsController,
                        maxLines: 5,
                      )),

                      _item(itemWidth, const SelectProductCategory()),

                      _item(itemWidth, TextWithTextFormFieldAsColumn2Widget(
                        text: AppLanguageKeys.price,
                        isDigit: true,
                        textFormController: priceController,
                      )),

                      _item(itemWidth, TextWithTextFormFieldAsColumn2Widget(
                        text: AppLanguageKeys.cost,
                        isDigit: true,
                        textFormController: costController,
                      )),

                      _item(itemWidth, TextWithTextFormFieldAsColumn2Widget(
                        text: AppLanguageKeys.inStock,
                        isDigit: true,
                        textFormController: inStockController,
                      )),

                      _item(
                        itemWidth,
                        TextWithContainerAsColumnWidget(
                          title: AppLanguageKeys.sparePartImage,
                          textContainer: AppLanguageKeys.attachImages,
                          fileName: imageName,
                          imageBytes: imageBytes,
                          onTap: pickImage,
                        ),
                      ),

                      _item(
                        itemWidth,
                        IsNewSwitch(
                          initialValue: isNewValue,
                          onChanged: (v) => isNewValue = v,
                        ),
                      ),


                      if (sizes.isEmpty)
                        _item(
                          itemWidth,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextInAppWidget(
                                text: AppLanguageKeys.sizes,
                                textSize: 13,
                                fontWeightIndex: FontSelectionData.regularFontFamily,
                                textColor: AppColors.blackColor,
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      sizes.add(SizeControllers());
                                    });
                                  },
                                  child: Icon(Icons.add, color: Colors.green, size: 30),
                                ),
                              ),
                            ],
                          ),
                        ),

                      ...List.generate(sizes.length, (index) {
                        return _item(
                          itemWidth,
                          SizeItemWidget(
                            title: AppLanguageKeys.sizes,
                            controllers: sizes[index],
                            itemWidth: itemWidth,
                            showDelete: true,
                            onDelete: () {
                              setState(() {
                                sizes.removeAt(index);
                              });
                            },
                            onAdd: () {
                              setState(() {
                                sizes.insert(index + 1, SizeControllers());
                              });
                            },
                          ),
                        );
                      }),

                      ...List.generate(cars.length, (index) {
                        return _item(
                          itemWidth,
                          CarSelectionItemWidget(
                            controller: cars[index],
                            showDelete: cars.length > 1,
                            onAdd: () => setState(() => cars.insert(index + 1, CarSelectionController())),
                            onDelete: () => setState(() => cars.removeAt(index)),
                          ),
                        );
                      }),
                    ],
                  ),

              BlocListener<CreateProductCubit, CreateProductState>(
                listener: (context, state) {
                  if (state is CreateProductSuccess) {
                    AppSnackBar.showSuccess(AppLanguageKeys.success);

                    if (isUpdate) {
                      Navigator.pop(context, true);
                      Navigator.pop(context, true);
                    } else {
                      Navigator.pop(context, true);
                    }
                  }

                  if (state is CreateProductError) {
                    AppSnackBar.showError(state.error);
                  }
                },
                    child: BlocBuilder<CreateProductCubit, CreateProductState>(
                      builder: (context, state) {

                        final isLoading = state is CreateProductLoading;

                        return Stack(
                          alignment: Alignment.center,
                          children: [

                            LastButtonInListDataFirstScreenAdvertisements(
                              text: isLoading
                                  ? " "
                                  : isUpdate
                                  ? AppLanguageKeys.edit
                                  : AppLanguageKeys.save,

                                onTap: isLoading ? null : () async {

                                  if (!formKey.currentState!.validate()) {
                                    AppSnackBar.showError(AppLanguageKeys.enterYourData);
                                    return;
                                  }

                                  final taxCubit = context.read<GetTaxCubit>();
                                  final categoryCubit = context.read<GetAllProductCategoriesCubit>();

                                  if (taxCubit.selectedTax == null) {
                                    AppSnackBar.showError(AppLanguageKeys.enterYourData);
                                    return;
                                  }

                                  if (categoryCubit.selectedCategory == null) {
                                    AppSnackBar.showError(AppLanguageKeys.enterYourData);
                                    return;
                                  }
                                  if (imageBytes == null) {
                                    AppSnackBar.showError(AppLanguageKeys.uploadImage);
                                    return;
                                  }

                                  bool hasValidCar = cars.any((c) {
                                    if (c.isAllBrandsSelected) return true;

                                    if (c.brandId == null) return false;

                                    bool isAllModelsSelected =
                                        c.models.isNotEmpty &&
                                            c.selectedModelIds.length == c.models.length;

                                    if (isAllModelsSelected) return true;

                                    return c.selectedModelIds.isNotEmpty;
                                  });

                                  if (!hasValidCar) {
                                    AppSnackBar.showError(AppLanguageKeys.selectCarModelByServices);
                                    return;
                                  }

                                  List<ProductBrand> brands = [];
                                  List<ProductCarModel> carModels = [];

                                  final allBrandsSelected =
                                  cars.any((c) => c.isAllBrandsSelected);

                                  if (allBrandsSelected) {
                                    final carCubit = context.read<CarSelectionCubit>();
                                    final allBrands =
                                        context.read<SelectCarModelSettingCubit>().state.brands;

                                    for (var brand in allBrands) {
                                      brands.add(ProductBrand(brandid: brand.id));

                                      final models = await carCubit.getModels(brand.id!);

                                      for (var model in models) {
                                        carModels.add(
                                          ProductCarModel(
                                            carBrandId: brand.id!,
                                            carModelId: model.id!,
                                            productCarBrandId:
                                            categoryCubit.selectedCategory!.id,
                                          ),
                                        );
                                      }
                                    }
                                  }

                                  else {
                                    brands = cars
                                        .where((c) => c.brandId != null)
                                        .map((c) => ProductBrand(brandid: c.brandId!))
                                        .toList();

                                    carModels = cars.expand((c) {
                                      return c.selectedModelIds.map((modelId) {
                                        return ProductCarModel(
                                          carBrandId: c.brandId!,
                                          carModelId: modelId,
                                          productCarBrandId:
                                          categoryCubit.selectedCategory!.id,
                                        );
                                      });
                                    }).toList();
                                  }
                                  final sizesList = sizes
                                      .where((s) =>
                                  s.nameController.text.trim().isNotEmpty ||
                                      s.latinNameController.text.trim().isNotEmpty ||
                                      s.priceController.text.trim().isNotEmpty ||
                                      s.costController.text.trim().isNotEmpty)
                                      .map((s) {
                                    return ProductSize(
                                      name: s.nameController.text.trim(),
                                      latinName: s.latinNameController.text.trim(),
                                      price: int.tryParse(s.priceController.text),
                                      cost: int.tryParse(s.costController.text),
                                    );
                                  }).toList();

                                  final request = CreateProductRequest(
                                    name: nameController.text.trim(),
                                    latinName: latinNameController.text.trim(),
                                    description: descController.text.trim(),
                                    latinDesc: latinDescController.text.trim(),
                                    instructions: instructionsController.text.trim(),

                                    price: int.tryParse(priceController.text),
                                    cost: int.tryParse(costController.text),
                                    inStock: int.tryParse(inStockController.text),

                                    isNew: isNewValue,
                                    image: imageBytes,

                                    taxId: taxCubit.selectedTax!.taxId,
                                    productCategoryId: categoryCubit.selectedCategory!.id,

                                    brands: brands,
                                    carModels: carModels,
                                    sizes: sizesList,
                                  );

                                  final json = request.toJson();
                                  debugPrint("===== CREATE JSON =====");
                                  debugPrint(const JsonEncoder.withIndent('  ').convert(json));

                                  if (json.values.any((e) => e == null)) {
                                    debugPrint("⚠️ WARNING: يوجد null في request");
                                  }

                                  final cubit = context.read<CreateProductCubit>();

                                  if (isUpdate) {
                                    cubit.updateProduct(request: request);
                                  } else {
                                    cubit.createProduct(request: request);
                                  }
                                }
                            ),

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
            );
          }),
        ),
      ),
    );
  }
}

Widget _item(double width, Widget child) {
  return SizedBox(width: width, child: child);
}