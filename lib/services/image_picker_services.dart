import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final _picker = ImagePicker();

  Future<List<XFile>?> pickImagesFromGallery(
      {int? maxWidth, int? maxHeight}) async {
    try {
      List<XFile>? images = await _picker.pickMultiImage(
        imageQuality: 85,
      );
      return images;
    } catch (e) {
      print("Error picking images: $e");
      return null;
    }
  }

  Future<XFile?> pickImageFromGallery({int? maxWidth, int? maxHeight}) async {
    try {
      XFile? image = await _picker.pickImage(
        imageQuality: 85,
        source: ImageSource.gallery,
      );
      return image;
    } catch (e) {
      print("Error picking images: $e");
      return null;
    }
  }

  Future<XFile?> captureImageFromCamera({int? maxWidth, int? maxHeight}) async {
    try {
      XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
      );
      return image;
    } catch (e) {
      print("Error capturing image: $e");
      return null;
    }
  }
}
