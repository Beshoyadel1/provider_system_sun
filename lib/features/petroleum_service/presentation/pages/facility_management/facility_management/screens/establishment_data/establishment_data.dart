import 'package:flutter/material.dart';
import 'package:sun_web_system/features/petroleum_service/presentation/pages/facility_management/facility_management/screens/establishment_data/data_view_establishment_data.dart';

class EstablishmentData extends StatelessWidget {
  const EstablishmentData({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsetsGeometry.all(15),
      child: DataViewEstablishmentData(),
    );
  }
}
