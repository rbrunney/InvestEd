import 'package:get/get.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:invested/controllers/login_controllers/login_type_controller.dart';
import 'package:invested/controllers/user_data_controllers/user_data_controller.dart';

class FacebookLoginController extends GetxController {

  final loginTypeController = Get.put(LoginTypeController());
  final userDataController = Get.put(UserDataController());
  Map<String, dynamic>? userData;
  AccessToken? accessToken;

  checkIfLoggedIn() async {
    accessToken = (await FacebookAuth.instance.accessToken)!;

    if (accessToken != null) {
      userData = await FacebookAuth.instance.getUserData();
    } else {
      login();
      _updateGlobalData();
    }
  }

  login() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      accessToken = result.accessToken!;
      userData = await FacebookAuth.instance.getUserData();
    }
  }

  logout() async {
    await FacebookAuth.instance.logOut();
    accessToken = null;
    userData = null;
    userDataController.clearUserData();
    loginTypeController.clearCurrentLoginType();
  }

  _updateGlobalData() {
    // Update Global User Data
    userDataController.setUserData(userData!["name"], userData!["email"], userData!["picture"]["data"]["url"]);

    // Update LoginType for later
    loginTypeController.setCurrentLoginType(LoginType.facebook);
  }
}
