import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:invested/controllers/user_data_controllers/user_data_controller.dart';
import 'login_type_controller.dart';

class GoogleLoginController extends GetxController {
  var _googleSignIn = GoogleSignIn();
  var googleAccount = Rx<GoogleSignInAccount?>(null);

  final loginTypeController = Get.put(LoginTypeController());
  final userDataController = Get.put(UserDataController());

  login() async {
    googleAccount.value = await _googleSignIn.signIn();
    _updateGlobalData();
  }

  logout() async {
    googleAccount.value = await _googleSignIn.signOut();
    userDataController.clearUserData();
    loginTypeController.clearCurrentLoginType();
  }

  _updateGlobalData() {
    // Update Global User Data
    userDataController.setUserData(
        googleAccount.value!.displayName.toString(), googleAccount.value!.email, googleAccount.value!.photoUrl.toString()
    );

    // Update LoginType for later
    loginTypeController.setCurrentLoginType(LoginType.google);
  }
}
