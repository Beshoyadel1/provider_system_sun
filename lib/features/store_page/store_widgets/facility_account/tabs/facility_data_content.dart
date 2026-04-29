import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/snakbar.dart';
import 'package:sun_web_system/features/auth_page/login_page/login_widgets/user_text_field_widget.dart';
import 'package:sun_web_system/features/internal_services/internal_orders/first_screen_internal_orders/logic/order_funcations/order_functions.dart';

import '../../../../../../core/api_functions/user/create_user_model/create_user_request.dart';
import '../../../../../../core/api_functions/user/create_user_model/provider_details_request.dart';
import '../../../../../../core/api_functions/user/login_model/login_repository.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/text_styles.dart';

import '../../../../../../features/auth_page/auth_cubit/auth_cubit.dart';
import '../../../../../../features/auth_page/auth_cubit/auth_state.dart';

import '../../../../../../features/store_page/model/facility_cubit/facility_tab_cubit/facility_tab_cubit.dart';

import '../../general_widgets_in_store/attach_file.dart';

class FacilityDataContent extends StatefulWidget {
  const FacilityDataContent({super.key});

  @override
  State<FacilityDataContent> createState() => _FacilityDataContentState();
}

class _FacilityDataContentState extends State<FacilityDataContent> {
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final genderController = TextEditingController();
  final ageController = TextEditingController();
  final dateController = TextEditingController();

  bool isEditMode = false;
  bool isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isLoaded) {
      _loadUser();
      isLoaded = true;
    }
  }

  Future<void> _loadUser() async {
    final user = await AuthLocalStorage.getUser();

    if (user != null) {
      usernameController.text = user.username ?? "";
      phoneController.text = user.phone ?? "";
      emailController.text = user.email ?? "";
      ageController.text = user.age?.toString() ?? "";
      genderController.text = user.gander?.toString() ?? "";
      dateController.text =
          OrderFunctions.formatDateFromDateTime(user.joinDate);

      setState(() {});
    }
  }

  /// ================= UPDATE =================
  void _onUpdate() async {
    final user = await AuthLocalStorage.getUser();
    final facilityCubit = context.read<FacilityTabCubit>();

    final oldProvider = user?.providerDetails;

    final request = CreateUserRequest(
      userid: user?.userid,
      type: user?.type,
      username: usernameController.text,
      phone: phoneController.text,
      email: emailController.text,
      age: int.tryParse(ageController.text),
      gander: int.tryParse(genderController.text),
      image: facilityCubit.images['image'] ?? user?.image,
      providerDetails: ProviderDetailsRequest(
        id: oldProvider?.id,
        provid: oldProvider?.provid,
        name: oldProvider?.name,
        latinname: oldProvider?.latinname,
        description: oldProvider?.description,
        latindesc: oldProvider?.latindesc,
        cr: oldProvider?.cr,
        vatno: oldProvider?.vatno,
        packageid: oldProvider?.packageid,
        iban: oldProvider?.iban,
        nationaladdress: oldProvider?.nationaladdress,
        subscriptionstartdate: oldProvider?.subscriptionstartdate,
        subscriptionenddate: oldProvider?.subscriptionenddate,

        /// الصور الجديدة فقط
        crimage: facilityCubit.images['crimage'],
        vatnoimage: facilityCubit.images['vatnoimage'],
      ),
    );

    debugPrint("========== FIXED REQUEST ==========");
    debugPrint(request.toJson().toString());

    context.read<AuthCubit>().updateUser(request);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            UserTextFieldWidget(
              controller: usernameController,
              text: AppLanguageKeys.username,
              type: UserFieldType.name,
              readOnly: !isEditMode,
            ),
            UserTextFieldWidget(
              controller: phoneController,
              text: AppLanguageKeys.phoneNumber,
              type: UserFieldType.phone,
              readOnly: !isEditMode,
            ),
            UserTextFieldWidget(
              controller: emailController,
              text: AppLanguageKeys.email,
              type: UserFieldType.email,
              readOnly: !isEditMode,
            ),
            UserTextFieldWidget(
              controller: ageController,
              text: AppLanguageKeys.age,
              readOnly: !isEditMode,
            ),
            UserTextFieldWidget(
              controller: dateController,
              text: AppLanguageKeys.joiningDate,
              type: UserFieldType.name,
              readOnly: true,
            ),
            UserTextFieldWidget(
              controller: genderController,
              text: AppLanguageKeys.gender,
              type: UserFieldType.gender,
              readOnly: !isEditMode,
            ),
          ],
        ),

        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            AttachImage(
              title: AppLanguageKeys.commercialRecordKey,
              type: 'crimage',
              isEditMode: isEditMode,
            ),
            AttachImage(
              title: AppLanguageKeys.taxNumber,
              type: 'vatnoimage',
              isEditMode: isEditMode,
            ),
            AttachImage(
              title: AppLanguageKeys.ownerIdKey,
              type: 'image',
              isEditMode: isEditMode,
            ),
          ],
        ),
        

        BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthUpdateSuccess) {
              setState(() => isEditMode = false);
              AppSnackBar.showSuccess(AppLanguageKeys.success);
            }

            if (state is AuthUpdateError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthUpdateLoading;

            return Row(
              children: [
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          if (!isEditMode) {
                            setState(() => isEditMode = true);
                          } else {
                            _onUpdate();
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : TextInAppWidget(
                          text: isEditMode ? AppLanguageKeys.save : AppLanguageKeys.edit,
                          textSize: 13,
                        ),
                ),
                const SizedBox(width: 10),
                if (isEditMode)
                  ElevatedButton(

                    onPressed: () {
                      setState(() => isEditMode = false);
                      _loadUser();
                    },
                    child: const TextInAppWidget(
                      text:  AppLanguageKeys.cancel,
                      textSize: 13,
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
