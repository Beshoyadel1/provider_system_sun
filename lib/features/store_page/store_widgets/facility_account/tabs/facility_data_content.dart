import 'package:flutter/material.dart';
import 'package:sun_web_system/features/internal_services/internal_orders/first_screen_internal_orders/logic/order_funcations/order_functions.dart';
import '../../../../../../core/api_functions/user/login_model/login_repository.dart';
import '../../../../../../core/pages_widgets/text_form_field_widget.dart';
import '../../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../general_widgets_in_store/attach_file.dart';

import 'package:flutter/material.dart';
import 'package:sun_web_system/features/internal_services/internal_orders/first_screen_internal_orders/logic/order_funcations/order_functions.dart';
import '../../../../../../core/api_functions/user/login_model/login_repository.dart';
import '../../../../../../core/pages_widgets/text_form_field_widget.dart';
import '../../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../general_widgets_in_store/attach_file.dart';

class FacilityDataContent extends StatefulWidget {
  const FacilityDataContent({super.key});

  @override
  State<FacilityDataContent> createState() => _FacilityDataContentState();
}

class _FacilityDataContentState extends State<FacilityDataContent> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController joiningDateController = TextEditingController();

  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isLoaded) {
      _loadUser();
      _isLoaded = true;
    }
  }

  Future<void> _loadUser() async {
    final user = await AuthLocalStorage.getUser();

    if (user != null) {
      usernameController.text =
          OrderFunctions.valueOrEmpty(user.username, context);

      phoneController.text = OrderFunctions.valueOrEmpty(user.phone, context);

      emailController.text = OrderFunctions.valueOrEmpty(user.email, context);

      ageController.text = OrderFunctions.valueOrEmpty(user.age, context);

      genderController.text = OrderFunctions.getGenderText(user.gander, context);

      joiningDateController.text =
          OrderFunctions.formatDateFromDateTime(user.joinDate);

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile =
        MediaQuery.of(context).size.width < ValuesOfAllApp.mobileWidth;

    return Column(
      spacing: 30,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildField(isMobile, AppLanguageKeys.username, usernameController),
            _buildField(isMobile, AppLanguageKeys.phoneNumber, phoneController),
            _buildField(isMobile, AppLanguageKeys.email, emailController),
            _buildField(isMobile, AppLanguageKeys.gender, genderController),
            _buildField(isMobile, AppLanguageKeys.age, ageController),
            //  _buildField(isMobile, AppLanguageKeys.nationality, nationalityController),
            _buildField(
                isMobile, AppLanguageKeys.joiningDate, joiningDateController),
          ],
        ),
        const Wrap(
          spacing: 60,
          runSpacing: 10,
          children: [
            AttachFile(
              fileName: AppLanguageKeys.commercialRecordKey,
              fileType: 'commercial',
            ),
            AttachFile(
              fileName: AppLanguageKeys.ownerIdKey,
              fileType: 'owner',
            ),
          ],
        )
      ],
    );
  }

  Widget _buildField(
      bool isMobile, String label, TextEditingController controller) {
    return SizedBox(
      width: isMobile ? double.infinity : 280,
      child: TextFormFieldWidget(
        textFormController: controller,
        text: label,
        textSize: 16,
        isColumn: true,
        textColor: AppColors.darkColor,
        borderColor: AppColors.darkGreyColor,
        fillColor: AppColors.whiteColor,
        textFormHeight: 35,
        hintTextColor: AppColors.greyColor,
        readOnly: true,
      ),
    );
  }
}
