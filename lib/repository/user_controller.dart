import 'package:get/get.dart';

class UserController extends GetxController {
  var userName = ''.obs;

  void setUserName(String name) {
    userName.value = name;
  }

  String getUserName() {
    return userName.value;
  }
}
