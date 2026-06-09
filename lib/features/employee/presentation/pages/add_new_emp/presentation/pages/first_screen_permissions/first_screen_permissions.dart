import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sun_web_system/features/employee/presentation/pages/add_new_emp/presentation/pages/first_screen_permissions/screens/list_data_first_screen_permissions.dart';


class FirstScreenPermissions extends StatelessWidget {
  const FirstScreenPermissions({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(child: ListDataFirstScreenPermissions());
  }
}
