import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/advertisements/presentation/bloc/upload_image_advertisements_cubit/upload_image_advertisements_state.dart';
class UploadImageAdvertisementsCubit
    extends Cubit<UploadImageAdvertisementsState> {
  UploadImageAdvertisementsCubit() : super(UploadImageInitial());

  Future<void> pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null && result.files.single.path != null) {
        emit(UploadImageSelected(File(result.files.single.path!)));
      }
    } catch (e) {
      emit(UploadImageError("Error picking image: $e"));
    }
  }

  void clearImage() {
    emit(UploadImageInitial());
  }
}
