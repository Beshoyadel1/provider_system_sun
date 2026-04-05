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
  final taxController = TextEditingController();

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
      taxController.text = p.taxId.toString();

      itemsControllers = p.items
          .split(',')
          .map<TextEditingController>(
            (e) => TextEditingController(text: e.trim()),
      )
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProviderPackagesCubit, ProviderPackagesState>(
      listener: (context, state) {
        if (state is ProviderPackagesError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }

        /// ✅ CLOSE ONLY HERE
        if (state is ProviderPackagesCreateSuccess ||
            state is ProviderPackagesUpdateSuccess) {
          Navigator.pop(context, true);
        }
      },
      child: AlertDialog(
        title: Text(isEdit ? "Edit Package" : "Create Package"),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormFieldWidget(
                  text: AppLanguageKeys.name,
                  textFormController: nameController,
                  isValidator: true,
                  textSize: 15,
                ),

                const SizedBox(height: 10),

                TextFormFieldWidget(
                  text: AppLanguageKeys.latinName,
                  textFormController: latinNameController,
                  isValidator: true,
                  textSize: 15,
                ),

                const SizedBox(height: 10),

                /// ITEMS
                Column(
                  children: List.generate(itemsControllers.length, (index) {
                    return Row(
                      children: [
                        Expanded(
                          child: TextFormFieldWidget(
                            text: "Item ${index + 1}",
                            textFormController: itemsControllers[index],
                            isValidator: true,
                            textSize: 15,
                          ),
                        ),
                        if (itemsControllers.length > 1)
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                itemsControllers.removeAt(index);
                              });
                            },
                          )
                      ],
                    );
                  }),
                ),

                const SizedBox(height: 10),

                TextFormFieldWidget(
                  text: AppLanguageKeys.price,
                  textFormController: priceController,
                  isDigitDot: true,
                  textSize: 15,
                ),

                const SizedBox(height: 10),

                TextFormFieldWidget(
                  text: AppLanguageKeys.taxes,
                  textFormController: taxController,
                  isDigitDot: true,
                  textSize: 15,
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          BlocBuilder<ProviderPackagesCubit, ProviderPackagesState>(
            builder: (context, state) {
              final isLoading = state is ProviderPackagesLoading;

              return ElevatedButton(
                onPressed: isLoading ? null : _submit,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : Text(isEdit ? "Update" : "Create"),
              );
            },
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final items =
    itemsControllers.map((e) => e.text.trim()).join(",");

    if (isEdit) {
      context.read<ProviderPackagesCubit>().updatePackage(
        id: widget.package.id,
        name: nameController.text,
        latinName: latinNameController.text,
        items: items,
        price: double.parse(priceController.text),
        tax: int.parse(taxController.text),
      );
    } else {
      context.read<ProviderPackagesCubit>().createPackage(
        name: nameController.text,
        latinName: latinNameController.text,
        items: items,
        price: double.parse(priceController.text),
        tax: int.parse(taxController.text),
      );
    }
  }
}