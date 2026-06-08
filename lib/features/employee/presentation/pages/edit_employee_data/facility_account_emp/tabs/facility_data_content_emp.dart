import 'dart:convert';
import 'package:sun_web_system/features/auth_page/data/model/create_user_model/create_user_emp_request.dart';
import 'package:sun_web_system/features/employee/data/model/employee_model/employee_model.dart';
import 'package:sun_web_system/features/internal_services/presentation/cubit/order_funcations/order_functions.dart';
import 'package:sun_web_system/features/store_page/presentation/pages/store_widgets/general_widgets_in_store/attach_file.dart';
import '../../../../../../../features/auth_page/data/model/create_user_model/create_user_request.dart';
import '../../../../../../../features/auth_page/data/model/create_user_model/employee_details_request.dart';
import '../../../../../../../features/auth_page/data/model/create_user_model/employee_wrapper_request.dart';
import 'package:sun_web_system/features/employee/presentation/bloc/employee_cubit/employee_cubit.dart';
import 'package:sun_web_system/features/employee/presentation/bloc/employee_cubit/employee_state.dart';
import '../../../../../../../features/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';
import '../../../../../../../features/store_page/presentation/bloc/facility_cubit/facility_tab_cubit/facility_tab_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../../../../core/language/language_constant.dart';
import '../../../../../../../core/theming/colors.dart';
import '../../../../../../../core/theming/text_styles.dart';

class FacilityDataContentEmp extends StatefulWidget {
  final EmployeeModel employee;

  const FacilityDataContentEmp({
    super.key,
    required this.employee,
  });

  @override
  State<FacilityDataContentEmp> createState() => _FacilityDataContentEmpState();
}

class _FacilityDataContentEmpState extends State<FacilityDataContentEmp> {
  final facilityNameController = TextEditingController();

  final facilityNameEnController = TextEditingController();

  final phoneController = TextEditingController();

  final emailController = TextEditingController();

  final genderController = TextEditingController();

  final ageController = TextEditingController();


  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    final employee = widget.employee;

    facilityNameController.text = employee.jobName;

    facilityNameEnController.text = employee.jobLatinName;

    phoneController.text = employee.phone;

    emailController.text = employee.email;

    genderController.text = employee.gender.toString();

    ageController.text = employee.age.toString();

  }

  T? safe<T>(T? value) {
    if (value == null) return null;

    if (value is String && value.trim().isEmpty) {
      return null;
    }

    return value;
  }

  void _onUpdate() {
    final facilityCubit = context.read<FacilityTabCubit>();
    final request = CreateUserEmpRequest(
      userid: widget.employee.userId,
      username: widget.employee.userName,
      phone: safe(phoneController.text),
      email: safe(emailController.text),
      age: ageController.text.isNotEmpty
          ? int.tryParse(ageController.text)
          : null,
      gender: genderController.text.isNotEmpty
          ? int.tryParse(
              genderController.text,
            )
          : null,
      type: widget.employee.type,
      image: facilityCubit.images['image'],
      employeeDetails: EmployeeWrapperRequest(
        employeeDetails: EmployeeDetailsRequest(
          id: widget.employee.userId,
          provid: widget.employee.providerId,
          branchid: 0,
          jobname: safe(
            facilityNameController.text,
          ),
          joblatinname: safe(
            facilityNameEnController.text,
          ),
        ),
      )
    );

    debugPrint(
      jsonEncode(
        request.toJson(),
      ),
    );

    context.read<EmployeeCubit>().updateEmployee(
          request,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmployeeCubit, EmployeeState>(
      listener: (
        context,
        state,
      ) {
        if (state is EmployeeUpdateSuccess) {
          setState(() {
            isEditMode = false;
          });
          AppSnackBar.showSuccess(
            AppLanguageKeys.success,
          );
        }

        if (state is EmployeeUpdateError) {
          AppSnackBar.showError(
            state.message,
          );
        }
      },
      builder: (
        context,
        state,
      ) {
        final isLoading = state is EmployeeUpdateLoading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                UserTextFieldWidget(
                  controller: facilityNameController,
                  text: AppLanguageKeys.facilityName,
                  type: UserFieldType.name,
                  readOnly: !isEditMode,
                  width: 250,
                ),
                UserTextFieldWidget(
                  controller: facilityNameEnController,
                  text: AppLanguageKeys.facilityNameEn,
                  type: UserFieldType.name,
                  readOnly: !isEditMode,
                  width: 250,
                ),
                UserTextFieldWidget(
                  controller: phoneController,
                  text: AppLanguageKeys.phoneNumber,
                  type: UserFieldType.phone,
                  readOnly: !isEditMode,
                  width: 250,
                ),
                UserTextFieldWidget(
                  controller: emailController,
                  text: AppLanguageKeys.email,
                  type: UserFieldType.email,
                  readOnly: !isEditMode,
                  width: 250,
                ),
                UserTextFieldWidget(
                  controller: ageController,
                  text: AppLanguageKeys.age,
                  readOnly: !isEditMode,
                  width: 250,
                ),
                UserTextFieldWidget(
                  controller: genderController,
                  text: AppLanguageKeys.gender,
                  type: UserFieldType.gender,
                  readOnly: !isEditMode,
                  width: 250,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            AttachImage(
              title: AppLanguageKeys.ownerIdKey,
              type: 'image',
              isEditMode: isEditMode,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orangeColor,
                  ),
                  onPressed: isLoading
                      ? null
                      : () {
                          if (!isEditMode) {
                            setState(
                              () {
                                isEditMode = true;
                              },
                            );
                          } else {
                            _onUpdate();
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : TextInAppWidget(
                          text: isEditMode
                              ? AppLanguageKeys.save
                              : AppLanguageKeys.edit,
                          textColor: AppColors.whiteColor,
                          textSize: 13,
                        ),
                ),
                const SizedBox(
                  width: 10,
                ),
                if (isEditMode)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orangeColor,
                    ),
                    onPressed: () {
                      setState(
                        () {
                          isEditMode = false;
                        },
                      );

                      _loadUser();
                    },
                    child: const TextInAppWidget(
                      text: AppLanguageKeys.cancel,
                      textSize: 13,
                      textColor: AppColors.whiteColor,
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
