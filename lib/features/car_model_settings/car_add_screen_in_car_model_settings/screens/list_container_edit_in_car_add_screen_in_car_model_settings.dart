import 'package:flutter/cupertino.dart';
import '../../custom_widget/container_edit_delete_in_car_model_widget.dart';

class ListContainerEditInCarAddScreenInCarModelSettings
    extends StatelessWidget {
  const ListContainerEditInCarAddScreenInCarModelSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          spacing: 10,
          children: [
            Expanded(child: ContainerEditDeleteInCarModelWidget()),
            Expanded(child: ContainerEditDeleteInCarModelWidget())
          ],
        ),
      ],
    );
  }
}
