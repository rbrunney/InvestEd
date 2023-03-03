import 'package:get/get.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:invested/util/data/global_data.dart' as global_data;

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
      _updateGlobalData();
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

  _updateGlobalData() {
    // Update Global User Data
    global_data.userData["name"] = userData!["name"];
    global_data.userData["email"] = userData!["email"];
    global_data.userData["photoUrl"] = userData!["picture"]["data"]["url"];

    // Update LoginType for later
    global_data.currentLoginType = global_data.LoginType.facebook;
  }
}
