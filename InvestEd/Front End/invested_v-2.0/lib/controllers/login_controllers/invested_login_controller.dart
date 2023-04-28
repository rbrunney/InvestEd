import 'package:get/get.dart';
import 'package:invested/controllers/user_data_controllers/user_data_controller.dart';
import 'login_type_controller.dart';

class InvestedLoginController extends GetxController {
  final loginTypeController = Get.put(LoginTypeController());
  final userDataController = Get.put(UserDataController());

  Map<String, dynamic>? userData;

  login() async {
    // Make Request Here
    // Get User Data
    _updateGlobalData('', '', '');
  }

  logout() async {
    userDataController.clearUserData();
    loginTypeController.clearCurrentLoginType();
  }

  _updateGlobalData(String name, String email, String photoUrl) {
    // Update Global User Data
    userDataController.setUserData(name, email, photoUrl);

    // Update LoginType for later
    loginTypeController.setCurrentLoginType(LoginType.invested);
  }
}
