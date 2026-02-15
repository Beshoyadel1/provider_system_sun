import 'package:flutter/cupertino.dart';
import '../../../../../../../../features/Petroleum_Service/Petroleum_Filling_Requests/screens/design_crave_digram_for_petroleum/first_row_data_container_design_crave_digram_for_petroleum.dart';
import '../../../../../../../../features/Petroleum_Service/Petroleum_Filling_Requests/screens/design_crave_digram_for_petroleum/crave_digram_for_petroleum.dart';

class DataContainerDesignCraveDigramForPetroleum extends StatelessWidget {
  const DataContainerDesignCraveDigramForPetroleum({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        const FirstRowDataContainerDesignCraveDigramForPetroleum(),
        CraveDigramForPetroleum()
      ],
    );
  }
}
