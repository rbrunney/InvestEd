import 'package:get/get.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookLoginController extends GetxController {
  Map<String, dynamic>? userData;
  bool checking = true;
  AccessToken? accessToken;

  checkIfLoggedIn() async {
    accessToken = (await FacebookAuth.instance.accessToken)!;
    checking = false;

    if (accessToken != null) {
      userData = await FacebookAuth.instance.getUserData();
    } else {
      login();
    }
  }

  login() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      accessToken = result.accessToken!;

      userData = await FacebookAuth.instance.getUserData();
    } else {
      print(result.status);
      print(result.message);
    }

    checking = false;
  }

  logout() async {
    await FacebookAuth.instance.logOut();
    accessToken = null;
    userData = null;

  }
}
