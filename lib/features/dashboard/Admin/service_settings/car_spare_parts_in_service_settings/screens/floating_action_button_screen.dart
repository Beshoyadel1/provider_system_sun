import 'package:flutter/material.dart';
import '../../../../../../core/theming/colors.dart';

class FloatingActionButtonScreen extends StatelessWidget {
  final VoidCallback? onPressed;

  const FloatingActionButtonScreen({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: AppColors.orangeColor,
      shape: const CircleBorder(),
      child: const Icon(
        Icons.add,
        color: AppColors.whiteColor,
        size: 35,
      ),
    );
  }
}
