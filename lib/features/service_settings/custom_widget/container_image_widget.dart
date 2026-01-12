import 'package:flutter/cupertino.dart';
import '../../../../../core/theming/colors.dart';

class ContainerImageWidget extends StatelessWidget {
  final String imagePath;
  final double? width, height;
  final Color color;
  final bool? isBorder;

  const ContainerImageWidget({
    super.key,
    required this.imagePath,
    required this.color,
    this.width,
    this.height,
    this.isBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsetsGeometry.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        border: Border.all(
            color: isBorder!
                ? AppColors.greyColor.withOpacity(0.3)
                : AppColors.transparent),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Image.asset(imagePath),
    );
  }
}
