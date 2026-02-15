import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/pages_widgets/button_widget.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/snakbar.dart';
import 'package:sun_web_system/core/setup_git_it.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/core/utilies/map_of_all_app.dart';
import 'package:sun_web_system/features/auth_page/auth_cubit/auth_cubit.dart';
import 'package:sun_web_system/features/auth_page/login_page/login_widgets/login_image.dart';
import 'package:sun_web_system/features/auth_page/login_page/login_widgets/user_text_field_widget.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key,required this.email});
  final String email;
  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();

}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late TextEditingController passwordController ;
  late TextEditingController confirmPasswordController ;
  late GlobalKey<FormState> resetPasswordFormKey ;

  @override
  void initState() {
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    resetPasswordFormKey = GlobalKey<FormState>();
    super.initState();
  }
  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    resetPasswordFormKey.currentState?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
        body: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: 20,
                    width: double.infinity,
                    color: AppColors.orangeColor,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Center(
                        child: SingleChildScrollView(
                          child: SizedBox(
                            width: 500,
                            child: Form(
                              key: resetPasswordFormKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const TextInAppWidget(
                                    text: AppLanguageKeys.authEnterCorrectEmail,
                                    textColor: AppColors.darkColor,
                                    textSize: 30,
                                    fontWeightIndex: FontSelectionData.semiBoldFontFamily,
                                  ),
                                  // const SizedBox(height: 20,),
                                  // TextInAppWidget(
                                  //   text: LocaleKeys.auth_login_text_subtitle.tr(),
                                  //   textColor: AppColors.appBlackColor,
                                  //   textSize: 17,
                                  //   fontWeightIndex: FontSelectionData.semiBoldFontFamily,
                                  // ),
                                  const SizedBox(height: 20,),
                                  UserTextFieldWidget(type: UserFieldType.password, controller: passwordController,),
                                  const SizedBox(height: 10,),
                                  UserTextFieldWidget(type: UserFieldType.password ,controller: confirmPasswordController),
                                  // const SizedBox(height: 20,),
                                  // Row(
                                  //   children: [
                                  //     ButtonWidget(
                                  //       text: LocaleKeys.auth_login_button.tr(),
                                  //       fontWeightIndex: FontSelectionData.semiBoldFontFamily,
                                  //       onTap: (){
                                  //         Navigator.of(context).push(
                                  //             NavigateToPageWidget(const LoginPage())
                                  //         );
                                  //       },
                                  //       textColor: AppColors.appBlackColor,
                                  //       buttonColor: Colors.transparent,
                                  //       textSize: 15,
                                  //     ),
                                  //   ],
                                  // ),
                                  const SizedBox(height: 20,),
                                  ButtonWidget(
                                    borderRadius: 20,
                                    text: AppLanguageKeys.send,
                                    onTap: ()async{
                                      if (resetPasswordFormKey.currentState!.validate()) {
                                        if(passwordController.text.trim() != confirmPasswordController.text.trim()){
                                          AppSnackBar.showWarning(AppLanguageKeys.passwordsDoNotMatch);
                                          return ;
                                        }else{

                                          // context.pushNamed(Routes.forgetPasswordScreen,arguments: ()  async {
                                          //   if (changePasswordFormKey.currentState!.validate()) {
                                          //     if (getIt<AuthCubit>().changePasswordController.text.trim() ==
                                          //         getIt<AuthCubit>().changePasswordConfirmController.text.trim()) {
                                                //       final res = await getIt<AuthCubit>().changePassword(
                                                //         widget.email,
                                                //         passwordController.text.trim(),);
                                                //       res.fold((errorMessage) {AppSnackBar.showWarning(errorMessage);},
                                                //             (successMessage) {
                                                //               AppSnackBar.showSuccess(successMessage);
                                                //               context.animationPush(
                                                //                 const LoginPage()
                                                //               );
                                                //         },
                                                //       );
                                          //     }
                                          //   }
                                          // });
                                        }
                                        // await context.read<AuthCubit>().login(context, emailController.text.trim(), passwordController.text.trim());

                                      }
                                      // Navigator.of(context).push(
                                      //     NavigateToPageWidget(OtpPage(timeCubit: getIt<TimeCubit>(), phoneNumber: '',))
                                      // );
                                    },
                                    textSize: 16,
                                    buttonColor: AppColors.orangeColor,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if(MediaQuery.of(context).size.width > ValuesOfAllApp.mobileWidth) const Expanded(child: LoginImage()),
          ],
        )
    );
  }
}
