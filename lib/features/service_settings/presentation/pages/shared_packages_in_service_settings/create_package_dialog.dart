import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/pages_widgets/text_form_field_widget.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/get_tax_cubit/get_tax_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/provider_packages_cubit/provider_packages_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/provider_packages_cubit/provider_packages_state.dart';
import 'package:sun_web_system/features/service_settings/presentation/pages/shared_packages_in_service_settings/select_tax_packages.dart';

class CreatePackageDialog extends StatefulWidget {
  final dynamic package;

  const CreatePackageDialog({super.key, this.package});

  @override
  State<CreatePackageDialog> createState() => _CreatePackageDialogState();
}

class _CreatePackageDialogState extends State<CreatePackageDialog> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final latinNameController = TextEditingController();
  final priceController = TextEditingController();

  List<TextEditingController> itemsControllers = [];

  bool get isEdit => widget.package != null;

  @override
  void initState() {
    super.initState();

    itemsControllers.add(TextEditingController());

    if (isEdit) {
      final p = widget.package;

      nameController.text = p.name ?? "";
      latinNameController.text = p.latinName ?? "";
      priceController.text = p.price.toString();

      itemsControllers = p.items
          .split(',')
          .map<TextEditingController>(
            (e) => TextEditingController(text: e.trim()),
      )
          .toList();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    latinNameController.dispose();
    priceController.dispose();

    for (var c in itemsControllers) {
      c.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),

        title: Column(
          children: [
            TextInAppWidget(
              text:
              isEdit ? AppLanguageKeys.edit : AppLanguageKeys.create,
              textSize: 20,
              fontWeightIndex: FontSelectionData.boldFontFamily,
              textColor: AppColors.orangeColor,
              isTextCenter: true,
            ),
            const SizedBox(height: 8),
            Divider(color: AppColors.darkColor.withOpacity(0.1)),
          ],
        ),

        content: SizedBox(
          width: 480,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(AppLanguageKeys.name),
                  const SizedBox(height: 6),
                  TextFormFieldWidget(
                   // text: AppLanguageKeys.name,
                    textFormController: nameController,
                    hintText: AppLanguageKeys.name,
                    fillColor: AppColors.transparent,
                    borderColor: AppColors.darkColor.withOpacity(0.2),
                    hintTextSize: 12,
                    hintTextColor: AppColors.orangeColor,
                    textSize: 15,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLanguageKeys.enterYourData;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  _sectionTitle(AppLanguageKeys.latinName),
                  const SizedBox(height: 6),
                  TextFormFieldWidget(
                   // text: AppLanguageKeys.latinName,
                    textFormController: latinNameController,
                    hintText: AppLanguageKeys.latinName,
                    fillColor: AppColors.transparent,
                    borderColor: AppColors.darkColor.withOpacity(0.2),
                    hintTextSize: 12,
                    hintTextColor: AppColors.orangeColor,
                    textSize: 15,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLanguageKeys.enterYourData;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),
                  _sectionTitle(AppLanguageKeys.items),
                  const SizedBox(height: 10),

                  Column(
                    children:
                    List.generate(itemsControllers.length, (index) {
                      return Padding(
                        padding:
                        const EdgeInsets.only(bottom: 10),
                        child: Row(
                          spacing: 10,
                          children: [
                            Expanded(
                              child: TextFormFieldWidget(
                               // text: "Item ${index + 1}",
                                textFormController:
                                itemsControllers[index],
                                hintText: AppLanguageKeys.items,
                                fillColor: AppColors.transparent,
                                borderColor: AppColors.darkColor.withOpacity(0.2),
                                hintTextSize: 12,
                                hintTextColor: AppColors.orangeColor,
                                textSize: 15,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLanguageKeys.enterYourData;
                                  }
                                  return null;
                                },
                              ),
                            ),

                            if (itemsControllers.length > 1)
                              Container(
                                margin:
                                const EdgeInsets.only(left: 6),
                                decoration: BoxDecoration(
                                  color:
                                  Colors.red.withOpacity(0.08),
                                  borderRadius:
                                  BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.close,
                                      size: 18,
                                      color: AppColors.redColor),
                                  onPressed: () {
                                    setState(() {
                                      itemsControllers[index]
                                          .dispose();
                                      itemsControllers
                                          .removeAt(index);
                                    });
                                  },
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        setState(() {
                          itemsControllers
                              .add(TextEditingController());
                        });
                      },
                      child:const Padding(
                        padding:
                         EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add,
                                size: 18,
                                color: AppColors.orangeColor),
                             SizedBox(width: 5),
                            TextInAppWidget(
                              text: AppLanguageKeys.add,
                              textSize: 13,
                              textColor:
                              AppColors.orangeColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            _sectionTitle(
                                AppLanguageKeys.price),
                            const SizedBox(height: 6),
                            TextFormFieldWidget(
                             // text: AppLanguageKeys.price,
                              textFormController:
                              priceController,
                              isDigitDot: true,
                              hintText: AppLanguageKeys.price,
                              fillColor: AppColors.transparent,
                              borderColor: AppColors.darkColor.withOpacity(0.2),
                              hintTextSize: 12,
                              hintTextColor: AppColors.orangeColor,
                              textSize: 15,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLanguageKeys.enterYourData;
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            _sectionTitle(
                                AppLanguageKeys.taxes),
                            const SizedBox(height: 6),
                            const SelectTaxPackages(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        actionsPadding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const TextInAppWidget(
              text: AppLanguageKeys.cancel,
              textSize: 14,
              textColor: AppColors.darkColor,
            ),
          ),

          BlocBuilder<ProviderPackagesCubit,
              ProviderPackagesState>(
            builder: (context, state) {
              final isLoading =
              state is ProviderPackagesLoading;

              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orangeColor,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                ),
                onPressed: isLoading ? null : _submit,
                child: isLoading
                    ? const SizedBox(
                  height: 18,
                  width: 18,
                  child:
                  CircularProgressIndicator(
                      strokeWidth: 2),
                )
                    : TextInAppWidget(
                  text: isEdit
                      ? AppLanguageKeys.edit
                      : AppLanguageKeys.create,
                  textSize: 14,
                  textColor: AppColors.whiteColor,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return TextInAppWidget(
      text: text,
      textSize: 13,
      textColor: AppColors.darkColor.withOpacity(0.6),
      fontWeightIndex: FontSelectionData.regularFontFamily,
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final taxCubit = context.read<GetTaxCubit>();

    if (taxCubit.selectedTax == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select tax")),
      );
      return;
    }

    final items = itemsControllers
        .map((e) => e.text.trim())
        .where((e) => e.isNotEmpty)
        .join(",");

    if (isEdit) {
      context.read<ProviderPackagesCubit>().updatePackage(
        id: widget.package.id,
        name: nameController.text,
        latinName: latinNameController.text,
        items: items,
        price: double.parse(priceController.text),
        tax: taxCubit.selectedTax!.taxId,
      );
    } else {
      context.read<ProviderPackagesCubit>().createPackage(
        name: nameController.text,
        latinName: latinNameController.text,
        items: items,
        price: double.parse(priceController.text),
        tax: taxCubit.selectedTax!.taxId,
      );
    }
  }
}