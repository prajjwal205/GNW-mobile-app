import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnw/utils/SucessButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../login_signup page/login.dart';
import '../utils/responsive_helper.dart';
import 'package:share_plus/share_plus.dart';

class Profilepage extends ConsumerStatefulWidget {
  const Profilepage({super.key});

  @override
  ConsumerState<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends ConsumerState<Profilepage> {
  bool _isLoading = true;


  // --- SHARE APP LOGIC ---
  void _shareApp() {
    SharePlus.instance.share(ShareParams(text: "Check out GNW Bazaar! The No.1 Search APP for Greater Noida West. Download now!"));  }

  // --- LOGOUT LOGIC ---
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Saara user data delete karega

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>  LoginPage()),
        (route) => false,
      );

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("Logged out successfully!"), backgroundColor: Colors.green),
      // );
      Sucessbutton.show(context, message: "you log out");

    }
  }
  // Controllers for direct inline editing
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _profileType = "Resident";
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _genderController.dispose();
    _birthdayController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // --- 1. LOAD DATA ON STARTUP ---
  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString("user_name") ?? "";
      _emailController.text = prefs.getString("user_email") ?? "";
      _mobileController.text = prefs.getString("user_phone") ?? "";
      _addressController.text = prefs.getString("address") ?? "";
      _genderController.text = prefs.getString("gender") ?? "";
      _birthdayController.text = prefs.getString("birthday") ?? "";
      _profileType = prefs.getString("profileType") ?? "Resident";

      String? imagePath = prefs.getString("profile_image");
      if (imagePath != null && imagePath.isNotEmpty) {
        _imageFile = File(imagePath);
      }
      _isLoading = false;
    });
  }

  // --- 2. PICK IMAGE FROM GALLERY ---
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // --- 3. SAVE ALL DATA ---
  Future<void> _saveProfileData() async {
    FocusScope.of(context).unfocus(); // Close the keyboard

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_name", _nameController.text.trim());
    await prefs.setString("user_email", _emailController.text.trim());
    await prefs.setString("user_phone", _mobileController.text.trim());
    await prefs.setString("address", _addressController.text.trim());
    await prefs.setString("gender", _genderController.text.trim());
    await prefs.setString("birthday", _birthdayController.text.trim());
    await prefs.setString("profileType", _profileType);

    if (_imageFile != null) {
      await prefs.setString("profile_image", _imageFile!.path);
    }

    if (mounted) {
      Sucessbutton.show(context, message: "Profile Saved!");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Colors.red)),
      );
    }

    double wScale = ResponsiveHelper.screenWidth(context) / 390.0;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(1.0), // Prevent OS huge fonts from breaking UI
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // --- HEADER ---
              Container(
                width: double.infinity,
                height: ResponsiveHelper.getContainerHeight(context, baseHeight: 200),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(120),
                    bottomRight: Radius.circular(120),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  "MY PROFILE",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.getFontSize(context, baseSize: 24),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              // --- CLICKABLE PROFILE PICTURE ---
              Container(
                transform: Matrix4.translationValues(0, -50 * wScale, 0),
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: ResponsiveHelper.getIconSize(context, baseSize: 55),
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                        child: _imageFile == null
                            ? Icon(Icons.person, size: 60 * wScale, color: Colors.grey.shade600)
                            : null,
                      ),
                      // Small camera icon badge
                      Container(
                        padding: EdgeInsets.all(6 * wScale),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.camera_alt, color: Colors.white, size: 18 * wScale),
                      ),
                    ],
                  ),
                ),
              ),

              Transform.translate(
                offset: Offset(0, -30 * wScale),
                child: Column(
                  children: [
                    // --- DIRECT INLINE EDIT FIELDS ---
                    _buildEditableDetail("Name", _nameController, context, wScale),

                    // --- PROFILE TYPE RADIO BUTTONS ---
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20 * wScale, vertical: 10 * wScale),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              "Profile Type",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: ResponsiveHelper.getFontSize(context, baseSize: 15),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Row(
                              children: [
                                Radio<String>(
                                  value: "Resident",
                                  groupValue: _profileType,
                                  activeColor: Colors.red,
                                  visualDensity: VisualDensity.compact,
                                  onChanged: (value) => setState(() => _profileType = value!),
                                ),
                                Text("Resident", style: TextStyle(fontSize: ResponsiveHelper.getFontSize(context, baseSize: 13))),

                                Radio<String>(
                                  value: "Business",
                                  groupValue: _profileType,
                                  activeColor: Colors.red,
                                  visualDensity: VisualDensity.compact,
                                  onChanged: (value) => setState(() => _profileType = value!),
                                ),
                                Text("Business", style: TextStyle(fontSize: ResponsiveHelper.getFontSize(context, baseSize: 13))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    _buildEditableDetail("Address", _addressController, context, wScale),
                    _buildEditableDetail("Gender", _genderController, context, wScale, hint: "Male / Female"),
                    _buildEditableDetail("Birthday", _birthdayController, context, wScale, hint: "DD/MM/YYYY"),
                    _buildEditableDetail("Mobile Number", _mobileController, context, wScale, isPhone: true),
                    _buildEditableDetail("Email", _emailController, context, wScale),

                    SizedBox(height: 30 * wScale),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // 🚀 Dono ko center mein laane ke liye
                      children: [
                        // SHARE BUTTON
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: ElevatedButton.icon(
                            onPressed: _shareApp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              // 🚀 Padding kam kar di taaki button ki height/width choti ho jaye
                              padding: EdgeInsets.symmetric(horizontal: 12 * wScale, vertical: 8 * wScale),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12 * wScale),
                              ),
                              elevation: 0,
                            ),
                            icon: Icon(Icons.share_sharp, size: 16 * wScale), // 🚀 Icon size 20 se 16 kiya
                            label: Text(
                              'Share', // 🚀 Text thoda chota kar diya better look ke liye
                              style: TextStyle(fontSize: 12 * wScale, fontWeight: FontWeight.bold), // 🚀 Font 14 se 12 kiya
                            ),
                          ),
                        ),

                        SizedBox(width: 10 * wScale), // 🚀 Beech ka gap 15 se 10 kar diya

                        // LOGOUT BUTTON
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: ElevatedButton.icon(
                            onPressed: _logout,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              // 🚀 Padding kam kar di
                              padding: EdgeInsets.symmetric(horizontal: 12 * wScale, vertical: 8 * wScale),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12 * wScale),
                              ),
                              elevation: 0,
                            ),
                            icon: Icon(Icons.logout_outlined, size: 16 * wScale), // 🚀 Icon size 20 se 16 kiya
                            label: Text(
                              'Logout',
                              style: TextStyle(fontSize: 12 * wScale, fontWeight: FontWeight.bold), // 🚀 Font 14 se 12 kiya
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // SizedBox(height:5 * wScale),
                    // --- SAVE BUTTON ---
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20 * wScale, ),
                      child: ElevatedButton(
                        onPressed: _saveProfileData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12 * wScale)),
                          elevation: 3,
                        ),
                        child: Text(
                          "Save Profile",
                          style: TextStyle(color: Colors.white, fontSize: 18 * wScale, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(height: 30 * wScale),
                  ],
                ),
        ),
      ),
    );
  }

  // Custom Inline TextFormField Widget
  Widget _buildEditableDetail(String title, TextEditingController controller, BuildContext context, double wScale, {String hint = "", bool isPhone = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20 * wScale, vertical: 6 * wScale),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveHelper.getFontSize(context, baseSize: 15),
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: TextFormField(
              controller: controller,
              keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
              style: TextStyle(
                fontSize: ResponsiveHelper.getFontSize(context, baseSize: 15),
                color: Colors.grey[800],
              ),
              decoration: InputDecoration(
                hintText: hint.isNotEmpty ? hint : "Enter $title",
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: ResponsiveHelper.getFontSize(context, baseSize: 14)),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8 * wScale, horizontal: 5 * wScale),
                // Clean bottom border line for the form field
                border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}