import 'package:get/get.dart';

// Defining Log In Types
enum LoginType { none, google, facebook, invested }

class LoginTypeController extends GetxController {
  LoginType currentLoginType = LoginType.none;

  setCurrentLoginType(LoginType loginType) {
    currentLoginType = loginType;
  }

  clearCurrentLoginType() {
    currentLoginType = LoginType.none;
  }
}