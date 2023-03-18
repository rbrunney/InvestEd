import 'package:get/get.dart';

class TokenController extends GetxController {

  String? accessToken;
  String? refreshToken;

  getAuthenticationTokens(String username, String password) {
    // Make Request Here to API
    // RSA Encrypt Here
    accessToken = '';
    refreshToken = '';
  }
}