import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/technical_support/custom_widget/row_member_team_work_widget.dart';
import 'package:sun_web_system/features/technical_support/custom_widget/row_message_support_widget.dart';
import 'package:sun_web_system/features/technical_support/logic/work_team_cubit/work_team_cubit.dart';
import 'package:sun_web_system/features/technical_support/logic/work_team_cubit/work_team_state.dart';
import '../../../../../../../core/theming/assets.dart';
import '../../../../../../../core/language/language_constant.dart';
import '../../../../../../../core/pages_widgets/text_form_field_widget.dart';
import '../../../../../../../core/theming/colors.dart';



class SearchWithListDataChatAdminSun extends StatefulWidget {
  const SearchWithListDataChatAdminSun({super.key});

  @override
  State<SearchWithListDataChatAdminSun> createState() =>
      _SearchWithListDataChatAdminSunState();
}

class _SearchWithListDataChatAdminSunState
    extends State<SearchWithListDataChatAdminSun> {
  final TextEditingController textFormController = TextEditingController();

  @override
  void dispose() {
    textFormController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkTeamCubit()..getTeam(),
      child: BlocBuilder<WorkTeamCubit, WorkTeamState>(
        builder: (context, state) {

          if (state is WorkTeamLoading) {
            return const SizedBox(
              height: 300,
              child: Center(child: CupertinoActivityIndicator()),
            );
          }

          if (state is WorkTeamError) {
            return SizedBox(
              height: 300,
              child: Center(child: Text(state.message)),
            );
          }

          if (state is WorkTeamSuccess) {
            final users = state.users;

            if (users.isEmpty) {
              return const SizedBox(
                height: 300,
                child: Center(child: Text("No team members")),
              );
            }

            return SizedBox(
              height: 300,
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: users.length,
                separatorBuilder: (_, __) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final user = users[index];

                  return RowMemberTeamWorkWidget(
                    imageBytes:user.image,
                    subTitle: user.getJobName(context).isNotEmpty
                        ? user.getJobName(context)
                        : "User@gmail.com",
                    title: user.getName(context).isNotEmpty
                        ? user.getName(context)
                        : "User",
                    onTap: (){

                    },
                  );
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );

  }
}
/*SizedBox(
      height: 400,
      child: Column(
        children: [
          TextFormFieldWidget(
            textFormController: textFormController,
            fillColor: AppColors.greyColorSearch,
            hintText: AppLanguageKeys.searchInMessages,
            hintTextSize: 11,
            hintTextColor: AppColors.darkColor.withOpacity(0.4),
            textSize: 12,
            contentPadding: const EdgeInsets.all(5),
            focusedBorderRadius: BorderRadius.circular(5),
            enabledBorderRadius: BorderRadius.circular(5),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: data.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = data[index];

                return RowMessageSupportWidget(
                  imagePath: item["image"]!,
                  userName: item["name"]!,
                  message: item["message"]!,
                  time: item["time"]!,
                );
              },
            ),
          ),
        ],
      ),
    );
    const  List<Map<String, String>> data =  [
  {
    "image": AppImageKeys.support_message_emp1,
    "name": "الأدمن",
    "message": "تمام",
    "time": "12m"
  },
  {
    "image": AppImageKeys.support_message_emp2,
    "name": "المحاسب",
    "message": "شكرا أخي",
    "time": "12m"
  },
  {
    "image": AppImageKeys.support_message_emp3,
    "name": "الأدمن",
    "message": "رقم الطلب #444 فيه مشكلة",
    "time": "12m"
  },
  {
    "image": AppImageKeys.support_message_emp4,
    "name": "المحاسب",
    "message": "شكرا أخي",
    "time": "12m"
  },
  {
    "image": AppImageKeys.support_message_emp4,
    "name": "الأدمن",
    "message": "رقم الطلب #444 فيه مشكلة",
    "time": "12m"
  },
  {
    "image": AppImageKeys.support_message_emp4,
    "name": "المحاسب",
    "message": "شكرا أخي",
    "time": "12m"
  },
  {
    "image": AppImageKeys.support_message_emp4,
    "name": "الأدمن",
    "message": "رقم الطلب #444 فيه مشكلة",
    "time": "12m"
  },
];
    */
