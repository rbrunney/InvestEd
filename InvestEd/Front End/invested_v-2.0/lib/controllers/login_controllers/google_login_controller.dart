import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:invested/controllers/token_controllers/token_controller.dart';
import 'package:invested/controllers/url_controller/url_controller.dart';
import 'package:invested/controllers/user_data_controllers/user_data_controller.dart';
import 'package:invested/util/requests/auth_request.dart';
import 'package:invested/util/requests/basic_request.dart';
import 'package:invested/util/security/RSA.dart';
import 'login_type_controller.dart';

class GoogleLoginController extends GetxController {
  var _googleSignIn = GoogleSignIn();
  var googleAccount = Rx<GoogleSignInAccount?>(null);

  final loginTypeController = Get.put(LoginTypeController());
  final userDataController = Get.put(UserDataController());
  final urlController = Get.put(URLController());
  final tokenController = Get.put(TokenController());

  login() async {
    googleAccount.value = await _googleSignIn.signIn();
    _updateGlobalData();

    Map<String, dynamic> userCredentials = {
      "username" : RSA.encrypt(googleAccount.value!.id),
      "password" : RSA.encrypt("google${googleAccount.value!.id}pass")
    };

    if(await _checkIfAccountExists()) {
      await _makeAccount();
      await _makePortfolio(userCredentials);
    }

    await _getTokens(userCredentials);
  }

  logout() async {
    googleAccount.value = await _googleSignIn.signOut();
    userDataController.clearUserData();
    loginTypeController.clearCurrentLoginType();
  }

  Future<bool> _checkIfAccountExists() async {
    BasicRequest.makeGetRequest(
        "${urlController.localBaseURL}/invested_account/check_taken?email=${googleAccount.value!.email}&username=${googleAccount.value!.id}")
    .then((value) {
      var response = json.decode(value);

      if(response['results']['status-code'] == 200) {
        return false;
      }
    });
    return true;
  }

  _makeAccount() async {
    String name = googleAccount.value!.displayName.toString();
    List<String> nameSplit = name.split(' ');

    Map<String, dynamic> requestBody = {
      "username" : RSA.encrypt(googleAccount.value!.id),
      "password" : RSA.encrypt("google${googleAccount.value!.id}pass"),
      "firstName" : RSA.encrypt(nameSplit.elementAt(0)),
      "lastName" : RSA.encrypt(nameSplit.elementAt(1)),
      "birthdate" : RSA.encrypt('12-12-1212'),
      "email" : RSA.encrypt(googleAccount.value!.email),
      "phone" : RSA.encrypt("555-555-5555"),
      "buyingPower" : 5000
    };

    await BasicRequest.makePostRequest("${urlController.localBaseURL}/invested_account", requestBody);
  }

  _makePortfolio(Map<String, dynamic> userCredentials) async {

    await BasicRequest.makePostRequest("${urlController.localBaseURL}/invested_account/authenticate", userCredentials)
        .then((value) async {
      var response = json.decode(value);
      await AuthRequest.makePostRequest("${urlController.localBaseURL}/invested_portfolio", {}, response['results']['access-token'])
      .then((value) {
        var response = json.decode(value);
        userDataController.portfolioId = response['results']['portfolio-id'];
      });
    });
  }

  _getTokens(Map<String, dynamic> userCredentials) async {

    await BasicRequest.makePostRequest("${urlController.localBaseURL}/invested_account/authenticate", userCredentials)
        .then((value) async {
      var response = json.decode(value);
      tokenController.accessToken = response['results']['access-token'];
      tokenController.refreshToken = response['results']['refresh-token'];
    });
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
