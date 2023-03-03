// Login Data
LoginType currentLoginType = LoginType.none;
Map<String, dynamic> userData = {"name": "", "email": "", "photoUrl": ""};

// Authorization Data
String accessToken = '';
String refreshToken = '';

// Defining Log In Types
enum LoginType { none, google, facebook, invested }
