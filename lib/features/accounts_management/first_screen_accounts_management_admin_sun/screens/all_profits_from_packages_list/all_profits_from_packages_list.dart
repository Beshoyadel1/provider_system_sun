import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/accounts_management/custom_widget/title_with_sub_title.dart';
import 'package:sun_web_system/features/accounts_management/logic/package_cubit/package_cubit.dart';
import 'package:sun_web_system/features/accounts_management/logic/package_cubit/package_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllProfitsFromPackagesList extends StatelessWidget {
  const AllProfitsFromPackagesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        const TextInAppWidget(
          text: AppLanguageKeys.packageName,
          textSize: 18,
          fontWeightIndex: FontSelectionData.semiBoldFontFamily,
          textColor: AppColors.blackColor,
        ),

        BlocProvider(
          create: (_) => PackageCubit()..getPackages(),
          child: BlocBuilder<PackageCubit, PackageState>(
            builder: (context, state) {


              if (state is PackageLoading) {
                return const CupertinoActivityIndicator();
              }


              if (state is PackageError) {
                return const Text("Error loading packages");
              }

              if (state is PackageSuccess) {
                final packages = state.packages;

                if (packages.isEmpty) {
                  return const Text("No packages");
                }

                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                      color: AppColors.greyColor.withOpacity(0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.darkColor.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: packages.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final package = packages[index];

                      return CustomContainer(
                        isSelected: false,
                        onTap: () {},
                        borderRadius: BorderRadius.circular(12),
                        typeWidget: Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.spaceBetween,
                          children: [
                            /// Name
                            TitleWithSubTitle(
                              title: AppLanguageKeys.packageName,
                              textSizeTitle: 13,
                              titleColor: AppColors.greyColor,
                              subTitle: package.getName(context),
                              textSizeSubTitle: 12,
                            ),

                            TitleWithSubTitle(
                              title: AppLanguageKeys.packageType,
                              textSizeTitle: 13,
                              titleColor: AppColors.greyColor,
                              subTitle: package.getDescription(context),
                              textSizeSubTitle: 12,
                            ),

                            TitleWithSubTitle(
                              title: AppLanguageKeys.annualPrice,
                              textSizeTitle: 13,
                              titleColor: AppColors.greyColor,
                              subTitle: "${package.annualPrice}",
                              textSizeSubTitle: 12,
                            ),

                            TitleWithSubTitle(
                              title: AppLanguageKeys.monthlyPrice,
                              textSizeTitle: 13,
                              titleColor: AppColors.greyColor,
                              subTitle: "${package.monthPrice}",
                              textSizeSubTitle: 12,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}