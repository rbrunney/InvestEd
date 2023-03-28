import 'package:get/get.dart';

class UserDataController extends GetxController {
  String name = '';
  String email = '';
  String photoUrl = '';
  double buyingPower = 0;

  setUserData(String name, String email, String photoUrl) {
    this.name = name;
    this.email = email;
    this.photoUrl = photoUrl;
  }

  clearUserData() {
    name = '';
    email = '';
    photoUrl = '';
    buyingPower = 0;
  }

  showData() {
    print({
      'name' : name,
      'email' : email,
      'photoUrl' : photoUrl
    }.toString());
  }
}