import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/features/employee/presentation/bloc/provider_employees_cubit/provider_employees_cubit.dart';
import 'package:sun_web_system/features/employee/presentation/pages/view_employee_data/screens/list_data_view_employee.dart';
import 'package:sun_web_system/features/employee/presentation/pages/view_employee_data/screens/title_view_employee_data.dart';

class ViewEmployeeData extends StatelessWidget {
  final int branchId;
  const ViewEmployeeData({super.key,required this.branchId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: BlocProvider(
                create: (_) => ProviderEmployeesCubit()..getBranchEmployees(branchId: branchId),
                child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleViewEmployeeData(
                        branchId: branchId,
                      ),
                      ListDataViewEmployee(
                          branchId:branchId
                      ),
                    ]),
              ),
            )),
      ),
    );
  }
}
