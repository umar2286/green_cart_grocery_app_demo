import 'package:image_picker/image_picker.dart';

Future pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);

  if (file != null) {
    try {
      // Read the image file as bytes and return it
      return await file.readAsBytes();
    } catch (e) {
      // Handle any errors that occur during reading the image file
      'Error reading image file: $e';
      return null;
    }
  } else {
    // Return null if no image file was picked
    return null;
  }
}
