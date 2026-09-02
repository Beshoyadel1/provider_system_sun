import 'package:sun_web_system/core/api/dio_function/api_constants.dart';
import 'package:sun_web_system/core/theming/auth_local_storage.dart';
import 'package:sun_web_system/features/auth_page/data/model/create_user_model/create_user_emp_request.dart';
import 'package:sun_web_system/features/auth_page/presentation/bloc/auth_cubit/auth_cubit.dart';
import 'package:sun_web_system/features/auth_page/presentation/bloc/auth_cubit/auth_state.dart';
import 'package:sun_web_system/features/employee/data/model/employee_model/employee_model.dart';
import 'package:sun_web_system/features/employee/presentation/bloc/provider_employees_cubit/provider_employees_cubit.dart';
import 'package:sun_web_system/features/employee/presentation/bloc/provider_employees_cubit/provider_employees_state.dart';
import 'package:sun_web_system/features/employee/presentation/bloc/service_permission_cubit/service_permission_cubit.dart';
import 'package:sun_web_system/features/employee/presentation/custom_widget/status_field_widget.dart';
import 'package:sun_web_system/features/employee/presentation/pages/add_edit_employee_data/facility_account_emp/sub/employee_branch_dropdown.dart';
import 'package:sun_web_system/features/employee/presentation/pages/add_edit_employee_data/facility_account_emp/sub/permissions_and_services_provided_to_the_user_text.dart';
import 'package:sun_web_system/features/employee/presentation/pages/add_edit_employee_data/facility_account_emp/sub/select_employee_permissions.dart';
import 'package:sun_web_system/features/employee/presentation/pages/add_edit_employee_data/facility_account_emp/sub/select_permissions_and_services_provided_to_the_user_with_image.dart';
import 'package:sun_web_system/features/store_page/presentation/pages/store_widgets/general_widgets_in_store/attach_image_emp.dart';
import '../../../../../../auth_page/data/model/create_user_model/create_user_request.dart';
import '../../../../../../auth_page/data/model/create_user_model/employee_wrapper_request.dart';
import '../../../../../../auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';
import '../../../../../../store_page/presentation/bloc/facility_cubit/facility_tab_cubit/facility_tab_cubit.dart';
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

  bool get isViewMode => widget.employee != null && !isEditMode;

  bool isEditMode = false;

  bool isActive = false;

  int selectedBranchId = 0;

  final jobNameController = TextEditingController();
  final jobLatinNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final genderController = TextEditingController();
  final ageController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.employee != null) {
      context.read<ProviderEmployeesCubit>().setSelectedEmployee(
            widget.employee!,
          );

      _loadUser();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        final serviceIds =
            widget.employee?.employeeDetails?.serviceIds ?? const <int>[];

        final permissions = widget.employee?.employeeDetails?.permissions;

        context.read<ServicePermissionCubit>().setSelected(serviceIds);

        context.read<ProviderEmployeesCubit>().setPermissions(permissions);

        final employeeImage = widget.employee?.image;

        if (employeeImage != null) {
          context.read<FacilityTabCubit>().images['image'] = employeeImage;
        }
      });
    } else {
      isEditMode = true;
      selectedBranchId = 0;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        context.read<ServicePermissionCubit>().setSelected([]);

        context.read<ProviderEmployeesCubit>().clearPermissions();
      });
    }
  }

  void _loadUser() {
    final employee = widget.employee;

    if (employee == null) return;

    final empDetails = employee.employeeDetails?.employeeDetails;

    usernameController.text = employee.username ?? '';

    phoneController.text = employee.phone ?? '';

    emailController.text = employee.email ?? '';

    genderController.text = '${employee.gender ?? 0}';

    ageController.text = '${employee.age ?? 0}';

    isActive = employee.isActive ?? false;

    jobNameController.text = empDetails?.jobname ?? '';

    jobLatinNameController.text = empDetails?.joblatinname ?? '';

    selectedBranchId = empDetails?.branchid ?? 0;
  }

  @override
  void dispose() {
    jobNameController.dispose();
    jobLatinNameController.dispose();
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

  String? _requiredFieldValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLanguageKeys.addAllRequiredFieldsKey;
    }

    return null;
  }

  String? _emailValidator(String? value) {
    final requiredError = _requiredFieldValidator(value);
    if (requiredError != null) return requiredError;

    final emailRegex = RegExp(
      r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!emailRegex.hasMatch(value!.trim())) {
      return AppLanguageKeys.pleaseEnterValidEmail;
    }

    return null;
  }

  void _onUpdate() {
    final current = widget.employee;

    if (current == null) return;

    final facilityCubit = context.read<FacilityTabCubit>();

    final serviceCubit = context.read<ServicePermissionCubit>();

    final employeeCubit = context.read<ProviderEmployeesCubit>();

    final selectedImage = facilityCubit.images['image'];

    final List<int> serviceIds = List<int>.from(serviceCubit.state);

    final permissions =
        employeeCubit.selectedPermissions ?? employeeCubit.emptyPermissions;

    final request = CreateUserEmpRequest(
      userid: current.userid,
      username: usernameController.text.trim(),
      phone: safe(
        phoneController.text,
      ),
      email: safe(
        emailController.text,
      ),
      age: int.tryParse(
        ageController.text.trim(),
      ),
      gender: int.tryParse(
        genderController.text.trim(),
      ),
      type: 5,
      image: selectedImage,
      isActive: isActive,
      employeeDetails: EmployeeWrapperRequest(
        employeeDetails: EmployeeModel(
          id: current.employeeDetails?.employeeDetails?.id,
          provid: current.employeeDetails?.employeeDetails?.provid,
          branchid: selectedBranchId,
          jobname: jobNameController.text.trim(),
          joblatinname: jobLatinNameController.text.trim(),
        ),
        serviceIds: serviceIds,
        permissions: permissions,
      ),
    );

    context.read<ProviderEmployeesCubit>().updateEmployee(request);
  }

  Future<void> _onCreate() async {
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    final requiredValues = [
      usernameController.text,
      jobNameController.text,
      jobLatinNameController.text,
      phone,
      emailController.text,
      genderController.text,
      password,
      confirmPassword,
    ];

    if (requiredValues.any((value) => value.trim().isEmpty)) {
      AppSnackBar.showError(
        AppLanguageKeys.addAllRequiredFieldsKey,
      );
      return;
    }

    final phoneError = AuthCubit.employeePhoneValidationError(phone);
    if (phoneError != null) {
      AppSnackBar.showError(phoneError);
      return;
    }

    final emailError = _emailValidator(emailController.text);
    if (emailError != null) {
      AppSnackBar.showError(emailError);
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) {
      AppSnackBar.showError(
        AppLanguageKeys.enterYourData,
      );
      return;
    }

    if (password != confirmPassword) {
      AppSnackBar.showError(
        AppLanguageKeys.passwordsDoNotMatch,
      );
      return;
    }

    final facilityCubit = context.read<FacilityTabCubit>();
    final image = facilityCubit.images['image'];

    if (image == null || image.toString().isEmpty) {
      AppSnackBar.showError(
        AppLanguageKeys.pleaseSelectImage,
      );
      return;
    }

    final serviceIds = context.read<ServicePermissionCubit>().state;
    final employeeCubit = context.read<ProviderEmployeesCubit>();
    final permissions =
        employeeCubit.selectedPermissions ?? employeeCubit.emptyPermissions;
    final authCubit = context.read<AuthCubit>();
    final user = await AuthLocalStorage.getUser();

    if (!mounted) return;

    final request = CreateUserRequest(
      username: usernameController.text.trim(),
      phone: phone,
      email: emailController.text.trim(),
      password: password,
      image: image,
      type: UserType.employeeUser,
      employeeDetails: EmployeeWrapperRequest(
        employeeDetails: EmployeeModel(
          provid: user?.userid ?? 0,
          branchid: selectedBranchId,
          jobname: jobNameController.text.trim(),
          joblatinname: jobLatinNameController.text.trim(),
        ),
        serviceIds: List<int>.from(serviceIds),
        permissions: permissions,
      ),
    );

    authCubit.signupEmp(request);
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

              Navigator.pop(
                context,
                true,
              );
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
            if (state is AuthSignupEmpCompleted) {
              AppSnackBar.showSuccess(
                state.message,
              );

              Navigator.pop(
                context,
                true,
              );

              return;
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
          final isLoading = state is ProviderEmployeesLoading ||
              state is EmployeeUpdateLoading ||
              context.watch<AuthCubit>().state is AuthSignupLoading;

          return _buildContent(
            isLoading,
          );
        },
      ),
    );
  }

  Widget _buildContent(
    bool isLoading,
  ) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                UserTextFieldWidget(
                  controller: usernameController,
                  text: AppLanguageKeys.userName,
                  type: UserFieldType.name,
                  validator: isCreateMode ? _requiredFieldValidator : null,
                  readOnly: isViewMode,
                  width: 250,
                  height: 40,
                ),
                UserTextFieldWidget(
                  controller: jobNameController,
                  text: AppLanguageKeys.jobName,
                  type: UserFieldType.name,
                  validator: isCreateMode ? _requiredFieldValidator : null,
                  readOnly: isViewMode,
                  width: 250,
                  height: 40,
                ),
                UserTextFieldWidget(
                  controller: jobLatinNameController,
                  text: AppLanguageKeys.jobNameEnglish,
                  type: UserFieldType.name,
                  validator: isCreateMode ? _requiredFieldValidator : null,
                  readOnly: isViewMode,
                  width: 250,
                  height: 40,
                ),
                UserTextFieldWidget(
                  controller: phoneController,
                  text: AppLanguageKeys.phoneNumber,
                  type: UserFieldType.phone,
                  validator: isCreateMode ? _requiredFieldValidator : null,
                  readOnly: isViewMode,
                  width: 250,
                  height: 40,
                ),
                UserTextFieldWidget(
                  controller: emailController,
                  text: AppLanguageKeys.email,
                  type: UserFieldType.email,
                  validator: isCreateMode ? _emailValidator : null,
                  readOnly: isViewMode,
                  width: 250,
                  height: 40,
                ),
                UserTextFieldWidget(
                  controller: genderController,
                  text: AppLanguageKeys.gender,
                  type: UserFieldType.gender,
                  validator: isCreateMode ? _requiredFieldValidator : null,
                  readOnly: isViewMode,
                  width: 250,
                  height: 40,
                ),
                if (isCreateMode)
                  UserTextFieldWidget(
                    controller: passwordController,
                    text: AppLanguageKeys.password,
                    type: UserFieldType.password,
                    validator: _requiredFieldValidator,
                    width: 250,
                    height: 40,
                  ),
                if (isCreateMode)
                  UserTextFieldWidget(
                    controller: confirmPasswordController,
                    text: AppLanguageKeys.confirmPasswordKey,
                    type: UserFieldType.password,
                    validator: _requiredFieldValidator,
                    width: 250,
                    height: 40,
                  ),
                EmployeeBranchDropdown(
                  selectedBranchId: selectedBranchId,
                  readOnly: isViewMode,
                  width: 250,
                  height: 40,
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }

                    setState(() {
                      selectedBranchId = value;
                    });
                  },
                ),
                if (!isCreateMode)
                  StatusFieldWidget(
                    isActive: isActive,
                    isEditMode: isEditMode,
                    onChanged: isEditMode
                        ? (value) {
                            setState(() {
                              isActive = value;
                            });
                          }
                        : null,
                  ),
              ],
            ),
            AttachImageEmp(
              title: AppLanguageKeys.profilePicture,
              type: 'image',
              isEditMode: !isViewMode,
              initialImage: widget.employee?.image,
            ),
            const PermissionsAndServicesProvidedToTheUserText(),
            SelectPermissionsAndServicesProvidedToTheUserWithImage(
              isEditMode: !isViewMode,
            ),
            const PermissionsAndServicesProvidedToTheUserText(
              text: AppLanguageKeys.employeeAvailablePermissions,
            ),
            SelectEmployeePermissions(
              isEditMode: !isViewMode,
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
                          if (isViewMode) {
                            setState(() {
                              isEditMode = true;
                            });
                            return;
                          }

                          if (isCreateMode) {
                            _onCreate();
                            return;
                          }

                          _onUpdate();
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
                const SizedBox(
                  width: 10,
                ),
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

                      final oldServices =
                          widget.employee?.employeeDetails?.serviceIds ??
                              const <int>[];

                      context.read<ServicePermissionCubit>().setSelected(
                            oldServices,
                          );

                      final oldPermissions =
                          widget.employee?.employeeDetails?.permissions;

                      context.read<ProviderEmployeesCubit>().setPermissions(
                            oldPermissions,
                          );
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
      ),
    );
  }
}
