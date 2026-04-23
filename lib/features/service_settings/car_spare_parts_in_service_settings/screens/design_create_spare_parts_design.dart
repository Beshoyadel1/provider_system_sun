import 'package:flutter/cupertino.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/service_settings/added_maintenance_and_internal_services_in_service_settings/screens/enter_name_laten_name_service.dart';
import 'package:sun_web_system/features/service_settings/added_maintenance_and_internal_services_in_service_settings/screens/select_tax_page.dart';

class DesignCreateSparePartsDesign extends StatefulWidget {
  final TextEditingController nameController, latinNameController;

  const DesignCreateSparePartsDesign({
    super.key,
    required this.nameController,
    required this.latinNameController,
  });

  @override
  State<DesignCreateSparePartsDesign> createState() =>
      _DesignCreateSparePartsDesignState();
}

class _DesignCreateSparePartsDesignState
    extends State<DesignCreateSparePartsDesign> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        const Row(
          children: [
            TextInAppWidget(
              text: AppLanguageKeys.createService,
              textSize: 15,
              fontWeightIndex: FontSelectionData.boldFontFamily,
            ),
          ],
        ),
        Form(
          key: _formKey,
          child: Column(
            spacing: 10,
            children: [
              EnterNameLatenNameService(
                nameController: widget.nameController,
                latinNameController: widget.latinNameController,
              ),
              const SelectTaxPage()
            ],
          ),
        ),
      ],
    );
  }
}
