import 'package:flutter/cupertino.dart';
import '../../../../../../../../features/dashboard/Admin/Petroleum_Service/Petroleum_Filling_Requests/screens/design_digram_for_petroleum/digram_for_petroleum.dart';
import '../../../../../../../../features/dashboard/Admin/Petroleum_Service/Petroleum_Filling_Requests/screens/design_digram_for_petroleum/first_row_data_container_design_digram_for_petroleum.dart';

class DataContainerDesignDigramForPetroleum extends StatelessWidget {
  const DataContainerDesignDigramForPetroleum({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        FirstRowDataContainerDesignDigramForPetroleum(),
        DigramForPetroleum()
      ],
    );
  }
}
