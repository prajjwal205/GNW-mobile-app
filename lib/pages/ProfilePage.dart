import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnw/utils/SucessButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

import '../login_signup page/login.dart';
import '../services/auth_provider.dart';
import '../utils/responsive_helper.dart';

// 🚀 YAHAN APNI AuthService WALI FILE IMPORT KAR LENA (Path check kar lena)
// import '../providers/auth_provider.dart'; // Example path

class Profilepage extends ConsumerStatefulWidget {
  const Profilepage({super.key});

  @override
  ConsumerState<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends ConsumerState<Profilepage> {
  bool _isLoading = true;

  // --- ZAROORI CONTROLLERS ---
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _selectedGender = "Male";
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Page khulte hi data load hoga
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // ==========================================
  // 🚀 API INTEGRATION (AuthService ka use)
  // ==========================================
  Future<void> _loadProfileData() async {
    // 1. Pehle local memory se data dikhao (Fast loading)
    final localData = await AuthService.getLocalProfileData();
    setState(() {
      _nameController.text = localData["name"]!;
      _emailController.text = localData["email"]!;
      _mobileController.text = localData["phone"]!;
      _selectedGender = localData["gender"]!;
      if (localData["image"]!.isNotEmpty) {
        _imageFile = File(localData["image"]!);
      }
    });

    // 2. Background me API se fresh data laao
    final apiData = await AuthService.fetchAndSyncUserProfile();
    if (apiData != null && mounted) {
      setState(() {
        _nameController.text = apiData["name"]!;
        _emailController.text = apiData["email"]!;
        _mobileController.text = apiData["phone"]!;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveProfileData() async {
    FocusScope.of(context).unfocus();

    // AuthService se data local memory me save karo
    await AuthService.saveLocalProfileData(_selectedGender, _imageFile?.path);

    if (mounted) {
      Sucessbutton.show(context, message: "Profile Saved!");
    }
  }

  // --- ACTUAL LOGOUT LOGIC ---
  Future<void> _logout() async {
    await AuthService.clearDataOnLogout();

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>  LoginPage()),
            (route) => false,
      );
      Sucessbutton.show(context, message: "Logged out");
    }
  }

  // --- SHARE APP LOGIC ---
  // --- SHARE APP LOGIC ---
  void _shareApp() {
    const String playStoreLink = "https://play.google.com/store/apps/details?id=com.gnwbazaar.gnw";

    // Yahan hum normal String use kar rahe hain, Uri.parse nahi
    final String shareText = "Check out GNW Bazaar! The No.1 Search App for Greater Noida West. Download now!\n\n👇 Click here to install:\n$playStoreLink";

    // Text aur link share karne ke liye Share.share() best hai
    Share.share(shareText);
  }
  // --- LOGOUT CONFIRMATION DIALOG ---
  void _showLogoutConfirmation() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CupertinoAlertDialog(
          title: const Text(""),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            CupertinoDialogAction(
              child: const Text("Cancel", style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(dialogContext);
                _logout();
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
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
        textScaler: const TextScaler.linear(1.0),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F7),
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

              // --- CLICKABLE PROFILE PICTURE WITH DYNAMIC AVATAR ---
              Container(
                transform: Matrix4.translationValues(0, -50 * wScale, 0),
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: ResponsiveHelper.getIconSize(context, baseSize: 55),
                        backgroundColor: Colors.white, // Avatar background white
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!)
                            : AssetImage(
                            _selectedGender == "Male"
                                ? "lib/images/MALE.png"
                                : "lib/images/FEMALE.png"
                        ) as ImageProvider,
                      ),
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
                    // --- IOS GROUPED LIST CONTAINER ---
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16 * wScale),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildEditableDetail("Name", _nameController, context, wScale),

                          // --- IOS STYLE GENDER TOGGLE ---
                          _buildIOSSegmentedRow(
                            title: "Gender",
                            context: context,
                            wScale: wScale,
                            groupValue: _selectedGender,
                            children: {
                              "Male": const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text("Male")),
                              "Female": const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("Female")),
                            },
                            onValueChanged: (value) {
                              setState(() {
                                _selectedGender = value.toString();
                                _imageFile = null; // Gender change hone par default image aayegi
                              });
                            },
                          ),

                          _buildEditableDetail("Mobile", _mobileController, context, wScale, isPhone: true),

                          _buildEditableDetail("Email", _emailController, context, wScale, showDivider: false),
                        ],
                      ),
                    ),

                    SizedBox(height: 30 * wScale),

                    // --- BUTTONS ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: ElevatedButton.icon(
                            onPressed: _shareApp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(horizontal: 16 * wScale, vertical: 10 * wScale),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10 * wScale),
                                side: const BorderSide(color: Colors.red, width: 1),
                              ),
                              elevation: 0,
                            ),
                            icon: Icon(Icons.share_sharp, size: 18 * wScale),
                            label: Text(
                              'Share',
                              style: TextStyle(fontSize: 14 * wScale, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(width: 10 * wScale),
                        // LOGOUT BUTTON
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        //   child: ElevatedButton.icon(
                        //     onPressed: _showLogoutConfirmation,
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: Colors.white,
                        //       foregroundColor: Colors.grey.shade700,
                        //       padding: EdgeInsets.symmetric(horizontal: 16 * wScale, vertical: 10 * wScale),
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(10 * wScale),
                        //         side: BorderSide(color: Colors.grey.shade400, width: 1),
                        //       ),
                        //       elevation: 0,
                        //     ),
                        //     icon: Icon(Icons.logout_outlined, size: 18 * wScale),
                        //     label: Text(
                        //       'Logout',
                        //       style: TextStyle(fontSize: 14 * wScale, fontWeight: FontWeight.bold),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),

                    SizedBox(height: 20 * wScale),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16 * wScale),
                      child: SizedBox(
                        width: double.infinity,
                        child: CupertinoButton(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                          onPressed: _saveProfileData,
                          child: Text(
                            "Save Profile",
                            style: TextStyle(color: Colors.white, fontSize: 18 * wScale, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30 * wScale),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- IOS STYLE INLINE EDIT WIDGET ---
  Widget _buildEditableDetail(String title, TextEditingController controller, BuildContext context, double wScale, {String hint = "", bool isPhone = false, bool readOnly = false, VoidCallback? onTap, bool showDivider = true}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16 * wScale, right: 16 * wScale, top: 4 * wScale, bottom: 4 * wScale),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 90 * wScale,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getFontSize(context, baseSize: 15),
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
                  readOnly: readOnly,
                  onTap: onTap,
                  // 🚀 TEXT COLOR KI PROBLEM YAHAN FIX KI HAI
                  style: TextStyle(
                      fontSize: ResponsiveHelper.getFontSize(context, baseSize: 15),
                      color: Colors.black87
                  ),
                  decoration: InputDecoration(
                    hintText: hint.isNotEmpty ? hint : title,
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: ResponsiveHelper.getFontSize(context, baseSize: 15)),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10 * wScale, horizontal: 0),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Padding(
            padding: EdgeInsets.only(left: 16 * wScale),
            child: const Divider(height: 1, thickness: 0.5, color: CupertinoColors.separator),
          ),
      ],
    );
  }

  Widget _buildIOSSegmentedRow({required String title, required BuildContext context, required double wScale, required String groupValue, required Map<String, Widget> children, required ValueChanged<String?> onValueChanged}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16 * wScale, vertical: 10 * wScale),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 90 * wScale,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getFontSize(context, baseSize: 15),
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Expanded(
                child: CupertinoSlidingSegmentedControl<String>(
                  groupValue: groupValue,
                  thumbColor: Colors.white,
                  backgroundColor: CupertinoColors.systemGrey5,
                  children: children,
                  onValueChanged: onValueChanged,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16 * wScale),
          child: const Divider(height: 1, thickness: 0.5, color: CupertinoColors.separator),
        ),
      ],
    );
  }
}