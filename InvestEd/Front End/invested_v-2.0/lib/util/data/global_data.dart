// Global Data
LoginType currentLoginType = LoginType.none;

Map<String, dynamic> userData = {"name" : "", "email" : "", "username" : "", "photoUrl" : ""};

// Defining Log In Types
enum LoginType { none, google, facebook, invested }
