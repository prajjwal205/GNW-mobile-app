class UserService {
  static String _userName = "User"; // Default value
  
  // Get the current username
  static String get userName => _userName;
  
  // Set the username
  static void setUserName(String name) {
    _userName = name;
  }
  
  // Fetch username from API (simulated)
  static Future<String> fetchUserName() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call delay
    _userName = "Prajjwal"; // Replace with actual API response
    return _userName;
  }
}

