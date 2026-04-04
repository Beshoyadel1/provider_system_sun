import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api/dio_function/api_constants.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/pages_widgets/text_form_field_widget.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/service_settings/logic/provider_packages_cubit/provider_packages_cubit.dart';
import 'package:sun_web_system/features/service_settings/logic/provider_packages_cubit/provider_packages_state.dart';

class CreatePackageDialog extends StatefulWidget {
  const CreatePackageDialog({super.key});

  @override
  State<CreatePackageDialog> createState() => _CreatePackageDialogState();
}

class _CreatePackageDialogState extends State<CreatePackageDialog> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final latinNameController = TextEditingController();
  final priceController = TextEditingController();
  final taxController = TextEditingController();

  List<TextEditingController> itemsControllers = [];

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    itemsControllers.add(TextEditingController());
  }

  @override
  void dispose() {
    nameController.dispose();
    latinNameController.dispose();
    priceController.dispose();
    taxController.dispose();

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
          setState(() => _isSubmitting = false);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }

        if (state is ProviderPackagesSuccess) {
          Navigator.pop(context, true);
        }
      },
      child: AlertDialog(
        title: const Text("Create Package"),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// NAME
                TextFormFieldWidget(
                  text: AppLanguageKeys.name,
                  textFormController: nameController,
                  isValidator: true,
                  textSize: 14,
                  isSpaceAfterText: true,
                ),

                const SizedBox(height: 10),

                /// LATIN NAME
                TextFormFieldWidget(
                  text: AppLanguageKeys.latinName,
                  textFormController: latinNameController,
                  isValidator: true,
                  textSize: 14,
                ),

                const SizedBox(height: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TextInAppWidget(
                          text:AppLanguageKeys.items,
                          textSize: 12,
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, color: AppColors.greenColor),
                          onPressed: () {
                            setState(() {
                              itemsControllers.add(TextEditingController());
                            });
                          },
                        )
                      ],
                    ),

                    const SizedBox(height: 5),

                    Column(
                      children: List.generate(itemsControllers.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormFieldWidget(
                                  text: "${AppLanguageKeys.items} ${index + 1}",
                                  textFormController: itemsControllers[index],
                                  isValidator: true,
                                  textSize: 14,
                                ),
                              ),

                              if (itemsControllers.length > 1)
                                IconButton(
                                  icon: const Icon(Icons.close, color:AppColors.redColor),
                                  onPressed: () {
                                    setState(() {
                                      itemsControllers.removeAt(index);
                                    });
                                  },
                                )
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// PRICE
                TextFormFieldWidget(
                  text: AppLanguageKeys.price,
                  textFormController: priceController,
                  isValidator: true,
                  isDigitDot: true,
                  textSize: 14,
                ),

                const SizedBox(height: 10),

                /// TAX
                TextFormFieldWidget(
                  text: AppLanguageKeys.taxes,
                  textFormController: taxController,
                  isValidator: true,
                  isDigitDot: true,
                  textSize: 14,
                ),
              ],
            ),
          ),
        ),
        actions: [
          /// CANCEL
          ElevatedButton(
            onPressed: _isSubmitting
                ? null
                : () => Navigator.pop(context),
            child: const TextInAppWidget(
              text: AppLanguageKeys.cancel,
              textSize: 14,
              textColor: AppColors.orangeColor,
              decorationTextColor: AppColors.whiteColor,
            ),
          ),

          /// CREATE
          BlocBuilder<ProviderPackagesCubit, ProviderPackagesState>(
            builder: (context, state) {
              final isLoading = state is ProviderPackagesLoading;

              return ElevatedButton(
                onPressed: isLoading ? null : _submit,
                child: isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const TextInAppWidget(
                  text: AppLanguageKeys.create,
                  textSize: 14,
                  textColor: AppColors.greenColor,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 🔥 SUBMIT
  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final items = itemsControllers
        .map((e) => e.text.trim())
        .where((e) => e.isNotEmpty)
        .join(",");

    context.read<ProviderPackagesCubit>().createPackage(
      name: nameController.text.trim(),
      latinName: latinNameController.text.trim(),
      items: items,
      price: double.parse(priceController.text),
      tax: int.parse(taxController.text),
    );
  }
}