import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api_functions/product/create_product_model/create_product_request.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/snakbar.dart';
import 'package:sun_web_system/features/service_settings/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/car_selection_controller.dart';
import 'package:sun_web_system/features/service_settings/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/car_selection_item_widget.dart';
import 'package:sun_web_system/features/service_settings/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/image_compressor.dart';
import 'package:sun_web_system/features/service_settings/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/is_new_switch.dart';
import 'package:sun_web_system/features/service_settings/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/select_product_category.dart';
import 'package:sun_web_system/features/service_settings/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/select_tax_product.dart';
import 'package:sun_web_system/features/service_settings/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/size_controllers.dart';
import 'package:sun_web_system/features/service_settings/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/size_item_widget.dart';
import 'package:sun_web_system/features/service_settings/custom_widget/text_with_text_form_field_as_column2_widget.dart';
import 'package:sun_web_system/features/service_settings/logic/car_selection_cubit/CarSelectionCubit.dart';
import 'package:sun_web_system/features/service_settings/logic/create_product_cubit/create_product_cubit.dart';
import 'package:sun_web_system/features/service_settings/logic/create_product_cubit/create_product_state.dart';
import 'package:sun_web_system/features/service_settings/logic/get_all_product_categories_cubit/get_all_product_categories_cubit.dart';
import 'package:sun_web_system/features/service_settings/logic/get_tax_cubit/get_tax_cubit.dart';
import 'package:sun_web_system/features/service_settings/logic/select_car_model_setting_cubit/select_car_model_setting_cubit.dart';
import '../../../../../../../../features/advertisements/first_screen_advertisements/screens/last_button_in_list_data_first_screen_advertisements.dart';
import '../../../../../../../../features/permissions/custom_widget/text_with_container_as_column_widget.dart';
import '../../../../../../../../core/language/language_constant.dart';
import 'package:image_picker/image_picker.dart';

class OtherDataDataContainerInListDataAddSparePartsInServiceSettings
    extends StatefulWidget {
  const OtherDataDataContainerInListDataAddSparePartsInServiceSettings(
      {super.key});

  @override
  State<OtherDataDataContainerInListDataAddSparePartsInServiceSettings> createState() => _OtherDataDataContainerInListDataAddSparePartsInServiceSettingsState();
}

class _OtherDataDataContainerInListDataAddSparePartsInServiceSettingsState extends State<OtherDataDataContainerInListDataAddSparePartsInServiceSettings> {
  bool isNewValue = false;

  final nameController = TextEditingController();
  final latinNameController = TextEditingController();
  final descController = TextEditingController();
  final latinDescController = TextEditingController();
  final priceController = TextEditingController();
  final costController = TextEditingController();
  final instructionsController = TextEditingController();
  final inStockController = TextEditingController();
  List<CarSelectionController> cars = [CarSelectionController()];

  final formKey = GlobalKey<FormState>();
  Uint8List? imageBytes;
  String? imageName;
  int? originalSize;
  int? compressedSize;

  Future<void> pickImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (file != null) {
      final originalBytesLocal = await file.readAsBytes();

      final compressedBytesLocal = await ImageCompressor.compressImage(
        originalBytesLocal,
        minWidth: 800,
        minHeight: 800,
        quality: 70,
      );

      setState(() {
        imageBytes = compressedBytesLocal;
        imageName = file.name;

        originalSize = originalBytesLocal.length;
        compressedSize = compressedBytesLocal!.length;
      });
    }
  }
  List<SizeControllers> sizes = [SizeControllers()];

  @override
  void dispose() {
    for (var s in sizes) {
      s.nameController.dispose();
      s.latinNameController.dispose();
      s.priceController.dispose();
      s.costController.dispose();
    }
    descController.dispose();
    latinDescController.dispose();
    instructionsController.dispose();
    inStockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    int itemsPerRow;
    if (width > 1000) {
      itemsPerRow = 4;
    } else if (width > 600) {
      itemsPerRow = 2;
    } else {
      itemsPerRow = 1;
    }
    final itemWidth = (width - ((itemsPerRow - 1) * 10)) / itemsPerRow;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetTaxCubit()..getTax()),
        BlocProvider(create: (_) => GetAllProductCategoriesCubit()..getAllProductCategories()),
        BlocProvider(create: (_) => SelectCarModelSettingCubit()..fetchBrands()),
        BlocProvider(create: (_) => CarSelectionCubit()),
        BlocProvider(create: (_) => CreateProductCubit()),
      ],
      child: Builder(builder: (context) {
        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 20,
                children: [
                  _item(
                      itemWidth,
                      TextWithTextFormFieldAsColumn2Widget(
                        text: AppLanguageKeys.name,
                        textFormController: nameController,
                      )),
                  _item(
                      itemWidth,
                      TextWithTextFormFieldAsColumn2Widget(
                        text: AppLanguageKeys.latinName,
                        textFormController: latinNameController,
                      )),
                  _item(
                    itemWidth,
                    const SelectTaxProduct(),
                  ),
                  _item(
                      itemWidth,
                      TextWithTextFormFieldAsColumn2Widget(
                          text: AppLanguageKeys.description,
                          textFormController: descController,
                          maxLines: 5)),
                  _item(
                      itemWidth,
                      TextWithTextFormFieldAsColumn2Widget(
                          text: AppLanguageKeys.latinDesc,
                          textFormController: latinDescController,
                          maxLines: 5)),
                  _item(
                      itemWidth,
                      TextWithTextFormFieldAsColumn2Widget(
                        text: AppLanguageKeys.instructions,
                        textFormController: instructionsController,
                        maxLines: 5,
                      )),
                  _item(itemWidth, const SelectProductCategory()),
                  _item(
                      itemWidth,
                      TextWithTextFormFieldAsColumn2Widget(
                        text: AppLanguageKeys.price,
                        isDigit: true,
                        textFormController: priceController,
                      )),
                  _item(
                      itemWidth,
                      TextWithTextFormFieldAsColumn2Widget(
                        text: AppLanguageKeys.cost,
                        isDigit: true,
                        textFormController: costController,
                      )),
                  _item(
                      itemWidth,
                      TextWithTextFormFieldAsColumn2Widget(
                        text: AppLanguageKeys.inStock,
                        textFormController: inStockController,
                        isDigit: true,
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
                      onChanged: (value) {
                        isNewValue = value;
                      },
                    ),
                  ),

                  ...List.generate(sizes.length, (index) {
                    return _item(
                      itemWidth,
                      SizeItemWidget(
                        title: AppLanguageKeys.sizes,
                        controllers: sizes[index],
                        itemWidth: itemWidth,
                        showDelete: sizes.length > 1,

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

                        onAdd: () {
                          setState(() {
                            cars.insert(index + 1, CarSelectionController());
                          });
                        },

                        onDelete: () {
                          setState(() {
                            cars.removeAt(index);
                          });
                        },
                      ),
                    );
                  }),
                ],
              ),
              BlocListener<CreateProductCubit, CreateProductState>(
                listener: (context, state) {
                  if (state is CreateProductSuccess) {
                    AppSnackBar.showSuccess(AppLanguageKeys.success);
                    Navigator.pop(context);
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
                          text: isLoading ? " " : AppLanguageKeys.save,
                          onTap: isLoading
                              ? null
                              : () {
                            if (!formKey.currentState!.validate()) {
                              AppSnackBar.showError(AppLanguageKeys.enterYourData);
                              return;
                            }

                            if (imageBytes == null) {
                              AppSnackBar.showError(AppLanguageKeys.mustImageUpload);
                              return;
                            }

                            for (var car in cars) {
                              if (car.brandId == null ||
                                  car.selectedModelIds.isEmpty ||
                                  car.categoryId == null) {
                                AppSnackBar.showError(AppLanguageKeys.enterYourData);
                                return;
                              }
                            }

                            final taxCubit = context.read<GetTaxCubit>();
                            final selectedTax = taxCubit.selectedTax;

                            final categoryCubit =
                            context.read<GetAllProductCategoriesCubit>();
                            final selectedCategory =
                                categoryCubit.selectedCategory;

                            final brands = cars
                                .map((c) => ProductBrand(brandid: c.brandId))
                                .toList();

                            final carModels = cars.expand((c) {
                              return c.selectedModelIds.map((modelId) {
                                return ProductCarModel(
                                  carBrandId: c.brandId,
                                  carModelId: modelId,
                                  productCarBrandId: c.categoryId,
                                );
                              });
                            }).toList();

                            final sizesList = sizes
                                .map((s) => ProductSize(
                              name: s.nameController.text,
                              latinName: s.latinNameController.text,
                              price: int.tryParse(s.priceController.text),
                              cost: int.tryParse(s.costController.text),
                            ))
                                .toList();

                            final request = CreateProductRequest(
                              name: nameController.text,
                              latinName: latinNameController.text,
                              description: descController.text,
                              latinDesc: latinDescController.text,
                              instructions: instructionsController.text,
                              price: int.tryParse(priceController.text),
                              cost: int.tryParse(costController.text),
                              inStock:
                              int.tryParse(inStockController.text),
                              taxId: selectedTax?.taxId,
                              productCategoryId: selectedCategory?.id,
                              isNew: isNewValue,
                              image: imageBytes,
                              brands: brands,
                              carModels: carModels,
                              sizes: sizesList,
                            );

                            debugPrint("===== JSON =====");
                            debugPrint(const JsonEncoder.withIndent('  ')
                                .convert(request.toJson()));

                            context.read<CreateProductCubit>().createProduct(
                              request: request,
                            );
                          },
                        ),

                        /// Loader في النص
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
    );
  }
}

Widget _item(double width, Widget child) {
  return SizedBox(width: width, child: child);
}