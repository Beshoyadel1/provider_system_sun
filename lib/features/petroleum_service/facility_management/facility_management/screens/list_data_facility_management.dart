import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../../features/communication_and_policies_pages/first_screen_communication_and_policies_pages/logic/tab_new_cubit/tab_insurance_new_offers_cubit.dart';
import '../../../../../../../../features/Petroleum_Service/Facility_Management/facility_management/screens/default_tab_controller_facility_management.dart';

class ListDataFacilityManagement extends StatefulWidget {
  const ListDataFacilityManagement({super.key});

  @override
  State<ListDataFacilityManagement> createState() =>
      _ScreenListDataFirstScreenCommunicationAndPoliciesPagesState();
}

class _ScreenListDataFirstScreenCommunicationAndPoliciesPagesState
    extends State<ListDataFacilityManagement> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TabInsuranceNewOffersCubit(),
      child: DefaultTabControllerFacilityManagement(),
    );
  }
}
