import 'dart:convert';
import 'package:sun_web_system/core/api/dio_function/api_constants.dart';
import 'package:sun_web_system/features/auth_page/data/datasource/login_datasource/login_repository.dart';
import 'package:sun_web_system/features/auth_page/data/model/create_user_model/create_user_emp_request.dart';
import 'package:sun_web_system/features/auth_page/presentation/bloc/auth_cubit/auth_cubit.dart';
import 'package:sun_web_system/features/auth_page/presentation/bloc/auth_cubit/auth_state.dart';
import 'package:sun_web_system/features/employee/data/model/employee_model/employee_model.dart';
import 'package:sun_web_system/features/employee/presentation/bloc/provider_employees_cubit/provider_employees_cubit.dart';
import 'package:sun_web_system/features/employee/presentation/bloc/provider_employees_cubit/provider_employees_state.dart';
import 'package:sun_web_system/features/employee/presentation/bloc/service_permission_cubit/service_permission_cubit.dart';
import 'package:sun_web_system/features/employee/presentation/pages/add_new_emp/presentation/pages/first_screen_permissions/screens/select_permissions_and_services_provided_to_the_user_with_image.dart';
import 'package:sun_web_system/features/store_page/presentation/pages/store_widgets/general_widgets_in_store/attach_file.dart';
import 'package:sun_web_system/features/store_page/presentation/pages/store_widgets/general_widgets_in_store/attach_image_emp.dart';
import '../../../../../../../features/auth_page/data/model/create_user_model/create_user_request.dart';
import '../../../../../../../features/auth_page/data/model/create_user_model/employee_wrapper_request.dart';
import '../../../../../../../features/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';
import '../../../../../../../features/store_page/presentation/bloc/facility_cubit/facility_tab_cubit/facility_tab_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../../../../core/language/language_constant.dart';
import '../../../../../../../core/theming/colors.dart';
import '../../../../../../../core/theming/text_styles.dart';

class FacilityDataContentEmp extends StatefulWidget {
  final CreateUserRequest? employee;

  const FacilityDataContentEmp({
    super.key,
    this.employee,
  });

  @override
  State<FacilityDataContentEmp> createState() => _FacilityDataContentEmpState();
}

class _FacilityDataContentEmpState extends State<FacilityDataContentEmp> {
  bool get isCreateMode => widget.employee == null;

  final facilityNameController = TextEditingController();

  final facilityNameEnController = TextEditingController();

  final phoneController = TextEditingController();

  final emailController = TextEditingController();

  final genderController = TextEditingController();

  final ageController = TextEditingController();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isEditMode = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.employee != null) {
      _loadUser();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ServicePermissionCubit>().setSelected(
          widget.employee?.employeeDetails?.serviceIds ?? [],
        );

        final employeeImage = widget.employee?.image;

        if (employeeImage != null) {
          context.read<FacilityTabCubit>().images['image'] =
              employeeImage;
        }
      });
    } else {
      isEditMode = true;
    }
  }

  void _loadUser() {
    final employee = widget.employee;

    if (employee == null) return;

    final empDetails =
        employee.employeeDetails?.employeeDetails;

    usernameController.text =
        employee.username ?? '';

    phoneController.text =
        employee.phone ?? '';

    emailController.text =
        employee.email ?? '';

    genderController.text =
    '${employee.gender ?? 0}';

    ageController.text =
    '${employee.age ?? 0}';

    facilityNameController.text =
        empDetails?.jobname ?? '';

    facilityNameEnController.text =
        empDetails?.joblatinname ?? '';
  }

  @override
  void dispose() {
    facilityNameController.dispose();
    facilityNameEnController.dispose();
    phoneController.dispose();
    emailController.dispose();
    genderController.dispose();
    ageController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  T? safe<T>(T? value) {
    if (value == null) return null;

    if (value is String && value.trim().isEmpty) {
      return null;
    }

    return value;
  }

  void _onUpdate() {
    final current = widget.employee;

    if (current == null) return;

    final facilityCubit = context.read<FacilityTabCubit>();
    final serviceIds =
        context.read<ServicePermissionCubit>().state;

    final selectedImage =
    facilityCubit.images['image'];

    final request = CreateUserEmpRequest(
      userid: current.userid,
      username: usernameController.text.trim(),
      phone: safe(phoneController.text),
      email: safe(emailController.text),
      age: int.tryParse(ageController.text),
      gender: int.tryParse(genderController.text),
      type: current.type,

      image: selectedImage ?? current.image,

      employeeDetails: EmployeeWrapperRequest(
        employeeDetails: EmployeeModel(
          id: current.employeeDetails?.employeeDetails?.id,
          provid: current.employeeDetails?.employeeDetails?.provid,
          branchid: current.employeeDetails?.employeeDetails?.branchid,
          jobname: facilityNameController.text.trim(),
          joblatinname: facilityNameEnController.text.trim(),
        ),
        serviceIds: serviceIds,
      ),
    );
    debugPrint(
      "UPDATE REQUEST => ${jsonEncode(request.toJson())}",
    );

    context.read<ProviderEmployeesCubit>().updateEmployee(
      request,
    );
  }

  Future<void> _onCreate() async {
    final user = await AuthLocalStorage.getUser();
    final serviceIds =
        context.read<ServicePermissionCubit>().state;
    if (passwordController.text != confirmPasswordController.text) {
      AppSnackBar.showError(
        AppLanguageKeys.passwordsDoNotMatch,
      );
      return;
    }

    final facilityCubit = context.read<FacilityTabCubit>();
    final image = facilityCubit.images['image'];

    if (image == null || image.toString().isEmpty) {
      AppSnackBar.showError(AppLanguageKeys.pleaseSelectImage);
      return;
    }
    final request = CreateUserRequest(
      username: usernameController.text.trim(),
      phone: phoneController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      image: facilityCubit.images['image'],
      type: UserType.employeeUser,
      employeeDetails: EmployeeWrapperRequest(
        employeeDetails: EmployeeModel(
          provid: user?.userid??0,
          jobname: facilityNameController.text.trim()??'',
          joblatinname: facilityNameEnController.text.trim()??'',
        ),
        serviceIds: serviceIds,
      ),
    );
    debugPrint(
      jsonEncode(
        request.toJson(),
      ),
    );

    context.read<AuthCubit>().signup(request);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProviderEmployeesCubit, ProviderEmployeesState>(
          listener: (context, state) {
            if (state is EmployeeUpdateSuccess) {
              setState(() {
                isEditMode = false;
              });

              AppSnackBar.showSuccess(
                AppLanguageKeys.success,
              );

              Navigator.pop(context, true);
            }
            if (state is EmployeeUpdateError) {
              AppSnackBar.showError(
                state.message,
              );
            }
          },
        ),
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSignupSuccess) {
              AppSnackBar.showSuccess(
                AppLanguageKeys.success,
              );

              Navigator.pop(context, true);
            }

            if (state is AuthSignupError) {
              AppSnackBar.showError(
                state.message,
              );
            }
          },
        ),
      ],
      child: BlocBuilder<ProviderEmployeesCubit, ProviderEmployeesState>(
        builder: (context, state) {
          final isLoading =
              state is ProviderEmployeesLoading ||
                  state is EmployeeUpdateLoading ||
                  context.watch<AuthCubit>().state
                  is AuthSignupLoading;

          return _buildContent(isLoading);
        },
      ),
    );
  }

  Widget _buildContent(bool isLoading) {
    return Form(
        key: _formKey,
      child:Padding(
        padding: const EdgeInsetsGeometry.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                UserTextFieldWidget(
                  controller: usernameController,
                  text: AppLanguageKeys.userName,
                  type: UserFieldType.name,
                  readOnly: !isCreateMode && !isEditMode,
                  width: 250,
                ),
                UserTextFieldWidget(
                  controller: facilityNameController,
                  text: AppLanguageKeys.facilityName,
                  type: UserFieldType.name,
                  readOnly: !isCreateMode && !isEditMode,
                  width: 250,
                ),
                UserTextFieldWidget(
                  controller: facilityNameEnController,
                  text: AppLanguageKeys.facilityNameEn,
                  type: UserFieldType.name,
                  readOnly: !isCreateMode && !isEditMode,
                  width: 250,
                ),
                UserTextFieldWidget(
                  controller: phoneController,
                  text: AppLanguageKeys.phoneNumber,
                  type: UserFieldType.phone,
                  readOnly: !isCreateMode && !isEditMode,
                  width: 250,
                ),
                UserTextFieldWidget(
                  controller: emailController,
                  text: AppLanguageKeys.email,
                  type: UserFieldType.email,
                  readOnly: !isCreateMode && !isEditMode,
                  width: 250,
                ),
                if (isCreateMode)
                  UserTextFieldWidget(
                    controller: passwordController,
                    text: AppLanguageKeys.password,
                    type: UserFieldType.password,
                    width: 250,
                  ),
                if (isCreateMode)
                  UserTextFieldWidget(
                    controller: confirmPasswordController,
                    text: AppLanguageKeys.confirmPasswordKey,
                    type: UserFieldType.password,
                    width: 250,
                  ),
                UserTextFieldWidget(
                  controller: genderController,
                  text: AppLanguageKeys.gender,
                  type: UserFieldType.gender,
                  readOnly: !isCreateMode && !isEditMode,
                  width: 250,
                ),
                AttachImageEmp(
                  title: AppLanguageKeys.ownerIdKey,
                  type: 'image',
                  isEditMode: isCreateMode || isEditMode,
                  initialImage: widget.employee?.image,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const SelectPermissionsAndServicesProvidedToTheUserWithImage(),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orangeColor,
                  ),
                  onPressed: isLoading
                      ? null
                      : () {

                    if (!isEditMode && !isCreateMode) {
                      setState(() {
                        isEditMode = true;
                      });
                      return;
                    }

                    if (!_formKey.currentState!.validate()) {
                      AppSnackBar.showError(
                        AppLanguageKeys.enterYourData,
                      );
                      return;
                    }

                    if (isCreateMode) {
                      _onCreate();
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
                    text: isCreateMode
                        ? AppLanguageKeys.createEmployee
                        : isEditMode
                        ? AppLanguageKeys.save
                        : AppLanguageKeys.edit,
                    textColor: AppColors.whiteColor,
                    textSize: 13,
                  ),
                ),
                const SizedBox(width: 10),
                if (isEditMode && !isCreateMode)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orangeColor,
                    ),
                    onPressed: () {
                      setState(() {
                        isEditMode = false;
                      });

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
        ),
      )
    );
  }
}
