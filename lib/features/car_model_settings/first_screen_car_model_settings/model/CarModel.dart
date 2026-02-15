import '../../../../../../core/theming/assets.dart';

class CarModel {
  final String name;
  final String imagePath;

  CarModel({required this.name, required this.imagePath});

  static final carCategory = [
    CarModel(name: 'CR - V', imagePath: AppImageKeys.car500),
    CarModel(name: 'Koenigsegg', imagePath: AppImageKeys.car501),
    CarModel(name: 'Nissan GT - R', imagePath: AppImageKeys.car502),
    CarModel(name: 'Ariya', imagePath: AppImageKeys.car503),
    CarModel(name: 'BMW', imagePath: AppImageKeys.car500),
    CarModel(name: 'Mercedes', imagePath: AppImageKeys.car501),
    CarModel(name: 'Toyota', imagePath: AppImageKeys.car502),
    CarModel(name: 'Hyundai', imagePath: AppImageKeys.car503),
    CarModel(name: 'Ford', imagePath: AppImageKeys.car500),
    CarModel(name: 'Peugeot', imagePath: AppImageKeys.car501),
    CarModel(name: 'Suzuki', imagePath: AppImageKeys.car502),
    CarModel(name: 'Opel', imagePath: AppImageKeys.car503),
    CarModel(name: 'Peugeot', imagePath: AppImageKeys.car501),
    CarModel(name: 'Suzuki', imagePath: AppImageKeys.car502),
    CarModel(name: 'Opel', imagePath: AppImageKeys.car503),
    CarModel(name: 'Koenigsegg', imagePath: AppImageKeys.car501),
    CarModel(name: 'CR - V', imagePath: AppImageKeys.car500),
  ];
  static final carModels = [
    CarModel(name: 'Nissan', imagePath: AppImageKeys.logo10),
    CarModel(name: 'مرسيدس', imagePath: AppImageKeys.logo11),
    CarModel(name: 'BMW', imagePath: AppImageKeys.logo12),
    CarModel(name: 'بورش', imagePath: AppImageKeys.logo13),
    CarModel(name: 'تويوتا', imagePath: AppImageKeys.logo10),
    CarModel(name: 'كيا', imagePath: AppImageKeys.logo11),
    CarModel(name: 'هوندا', imagePath: AppImageKeys.logo12),
    CarModel(name: 'جيب', imagePath: AppImageKeys.logo13),
    CarModel(name: 'فورد', imagePath: AppImageKeys.logo10),
    CarModel(name: 'هيونداي', imagePath: AppImageKeys.logo11),
    CarModel(name: 'سوزوكي', imagePath: AppImageKeys.logo12),
    CarModel(name: 'رنج روفر', imagePath: AppImageKeys.logo13),
    CarModel(name: 'شيفروليه', imagePath: AppImageKeys.logo10),
    CarModel(name: 'بيجو', imagePath: AppImageKeys.logo11),
    CarModel(name: 'سكودا', imagePath: AppImageKeys.logo12),
    CarModel(name: 'اوبل', imagePath: AppImageKeys.logo13),
  ];
}
