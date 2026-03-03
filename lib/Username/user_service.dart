class UserService {
  static String _userName = "User"; // Default value
  
  static String get userName => _userName;
  
  static void setUserName(String name) {
    _userName = name;
  }
  
  static Future<String> fetchUserName() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call delay
    _userName = "Prajjwal"; // Replace with actual API response
    return _userName;
  }
}

