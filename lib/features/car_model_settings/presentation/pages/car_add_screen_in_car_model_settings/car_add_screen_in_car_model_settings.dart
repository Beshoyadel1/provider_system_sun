import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screens/list_data_car_add_screen_in_car_model_settings.dart';


class CarAddScreenInCarModelSettings extends StatelessWidget {
  const CarAddScreenInCarModelSettings({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                  child: ListDataCarAddScreenInCarModelSettings()),
            ),
          ],
        ),
      ),
    );
  }
}
