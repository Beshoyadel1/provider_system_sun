import 'package:flutter/material.dart';
import '../../../../../core/language/language_constant.dart';
import '../../../../../core/pages_widgets/button_widget.dart';
import '../../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';
import '../../../../../core/theming/text_styles.dart';
import '../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../features/auth_page/login_page/login_widgets/login_image.dart';
import '../../../../../features/auth_page/login_page/login_widgets/user_text_field_widget.dart';


class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});
  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();

}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late TextEditingController emailController ;
  late GlobalKey<FormState> resetPasswordFormKey ;

  @override
  void initState() {
    emailController = TextEditingController();
    resetPasswordFormKey = GlobalKey<FormState>();
    super.initState();
  }
  @override
  void dispose() {
    emailController.dispose();
    resetPasswordFormKey.currentState?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                    child: AppBar(backgroundColor: AppColors.orangeColor),
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
                                  const  TextInAppWidget(
                                    text: AppLanguageKeys.authEnterCorrectEmail,
                                    textColor: AppColors.darkColor,
                                    textSize: 20,
                                    fontWeightIndex: FontSelectionData.semiBoldFontFamily,
                                  ),
                                  UserTextFieldWidget(type: UserFieldType.email, controller: emailController,),
                                  const SizedBox(height: 10,),
                                  ButtonWidget(
                                    borderRadius: 20,
                                    text: AppLanguageKeys.send,
                                    onTap: ()async{
                                      if (resetPasswordFormKey.currentState!.validate()) {
                                      }
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
