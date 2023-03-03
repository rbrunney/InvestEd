import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:invested/util/data/global_data.dart' as global_data;

class GoogleLoginController extends GetxController {
  var _googleSignIn = GoogleSignIn();
  var googleAccount = Rx<GoogleSignInAccount?>(null);

  login() async {
    googleAccount.value = await _googleSignIn.signIn();
    _updateGlobalData();
  }

  logout() async {
    googleAccount.value = await _googleSignIn.signOut();
  }

  _updateGlobalData() {
    // Update Global User Data
    global_data.userData["name"] = googleAccount.value!.displayName;
    global_data.userData["email"] = googleAccount.value!.email;
    global_data.userData["photoUrl"] = googleAccount.value!.photoUrl;

    // Update LoginType for later
    global_data.currentLoginType = global_data.LoginType.google;
  }
}
