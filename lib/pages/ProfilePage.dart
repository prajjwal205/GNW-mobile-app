// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:gnw/utils/SucessButton.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:image_picker/image_picker.dart';
// // import '../login_signup page/login.dart';
// // import '../utils/responsive_helper.dart';
// // import 'package:share_plus/share_plus.dart';
// //
// // class Profilepage extends ConsumerStatefulWidget {
// //   const Profilepage({super.key});
// //
// //   @override
// //   ConsumerState<Profilepage> createState() => _ProfilepageState();
// // }
// //
// // class _ProfilepageState extends ConsumerState<Profilepage> {
// //   bool _isLoading = true;
// //
// //
// //   // --- SHARE APP LOGIC ---
// //   void _shareApp() {
// //     SharePlus.instance.share(ShareParams(text: "Check out GNW Bazaar! The No.1 Search APP for Greater Noida West. Download now!"));  }
// //
// //   // --- LOGOUT LOGIC ---
// //   Future<void> _logout() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.clear(); // Saara user data delete karega
// //
// //     if (mounted) {
// //       Navigator.pushAndRemoveUntil(
// //         context,
// //         MaterialPageRoute(builder: (context) =>  LoginPage()),
// //         (route) => false,
// //       );
// //
// //       // ScaffoldMessenger.of(context).showSnackBar(
// //       //   const SnackBar(content: Text("Logged out successfully!"), backgroundColor: Colors.green),
// //       // );
// //       Sucessbutton.show(context, message: "you log out");
// //
// //     }
// //   }
// //   // Controllers for direct inline editing
// //   final TextEditingController _nameController = TextEditingController();
// //   final TextEditingController _addressController = TextEditingController();
// //   final TextEditingController _genderController = TextEditingController();
// //   final TextEditingController _birthdayController = TextEditingController();
// //   final TextEditingController _mobileController = TextEditingController();
// //   final TextEditingController _emailController = TextEditingController();
// //
// //   String _profileType = "Resident";
// //   File? _imageFile;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadProfileData();
// //   }
// //
// //   @override
// //   void dispose() {
// //     _nameController.dispose();
// //     _addressController.dispose();
// //     _genderController.dispose();
// //     _birthdayController.dispose();
// //     _mobileController.dispose();
// //     _emailController.dispose();
// //     super.dispose();
// //   }
// //
// //   // --- 1. LOAD DATA ON STARTUP ---
// //   Future<void> _loadProfileData() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       _nameController.text = prefs.getString("user_name") ?? "";
// //       _emailController.text = prefs.getString("user_email") ?? "";
// //       _mobileController.text = prefs.getString("user_phone") ?? "";
// //       _addressController.text = prefs.getString("address") ?? "";
// //       _genderController.text = prefs.getString("gender") ?? "";
// //       _birthdayController.text = prefs.getString("birthday") ?? "";
// //       _profileType = prefs.getString("profileType") ?? "Resident";
// //
// //       String? imagePath = prefs.getString("profile_image");
// //       if (imagePath != null && imagePath.isNotEmpty) {
// //         _imageFile = File(imagePath);
// //       }
// //       _isLoading = false;
// //     });
// //   }
// //
// //   // --- 2. PICK IMAGE FROM GALLERY ---
// //   Future<void> _pickImage() async {
// //     final picker = ImagePicker();
// //     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
// //
// //     if (pickedFile != null) {
// //       setState(() {
// //         _imageFile = File(pickedFile.path);
// //       });
// //     }
// //   }
// //
// //   // --- 3. SAVE ALL DATA ---
// //   Future<void> _saveProfileData() async {
// //     FocusScope.of(context).unfocus(); // Close the keyboard
// //
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setString("user_name", _nameController.text.trim());
// //     await prefs.setString("user_email", _emailController.text.trim());
// //     await prefs.setString("user_phone", _mobileController.text.trim());
// //     await prefs.setString("address", _addressController.text.trim());
// //     await prefs.setString("gender", _genderController.text.trim());
// //     await prefs.setString("birthday", _birthdayController.text.trim());
// //     await prefs.setString("profileType", _profileType);
// //
// //     if (_imageFile != null) {
// //       await prefs.setString("profile_image", _imageFile!.path);
// //     }
// //
// //     if (mounted) {
// //       Sucessbutton.show(context, message: "Profile Saved!");
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     if (_isLoading) {
// //       return const Scaffold(
// //         backgroundColor: Colors.white,
// //         body: Center(child: CircularProgressIndicator(color: Colors.red)),
// //       );
// //     }
// //
// //     double wScale = ResponsiveHelper.screenWidth(context) / 390.0;
// //
// //     return MediaQuery(
// //       data: MediaQuery.of(context).copyWith(
// //         textScaler: const TextScaler.linear(1.0), // Prevent OS huge fonts from breaking UI
// //       ),
// //       child: Scaffold(
// //         backgroundColor: Colors.white,
// //         body: SingleChildScrollView(
// //           child: Column(
// //             children: [
// //               // --- HEADER ---
// //               Container(
// //                 width: double.infinity,
// //                 height: ResponsiveHelper.getContainerHeight(context, baseHeight: 200),
// //                 decoration: const BoxDecoration(
// //                   color: Colors.red,
// //                   borderRadius: BorderRadius.only(
// //                     bottomLeft: Radius.circular(120),
// //                     bottomRight: Radius.circular(120),
// //                   ),
// //                 ),
// //                 alignment: Alignment.center,
// //                 child: Text(
// //                   "MY PROFILE",
// //                   style: TextStyle(
// //                     color: Colors.white,
// //                     fontSize: ResponsiveHelper.getFontSize(context, baseSize: 24),
// //                     fontWeight: FontWeight.bold,
// //                     letterSpacing: 1.2,
// //                   ),
// //                 ),
// //               ),
// //
// //               // --- CLICKABLE PROFILE PICTURE ---
// //               Container(
// //                 transform: Matrix4.translationValues(0, -50 * wScale, 0),
// //                 child: GestureDetector(
// //                   onTap: _pickImage,
// //                   child: Stack(
// //                     alignment: Alignment.bottomRight,
// //                     children: [
// //                       CircleAvatar(
// //                         radius: ResponsiveHelper.getIconSize(context, baseSize: 55),
// //                         backgroundColor: Colors.grey.shade300,
// //                         backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
// //                         child: _imageFile == null
// //                             ? Icon(Icons.person, size: 60 * wScale, color: Colors.grey.shade600)
// //                             : null,
// //                       ),
// //                       // Small camera icon badge
// //                       Container(
// //                         padding: EdgeInsets.all(6 * wScale),
// //                         decoration: const BoxDecoration(
// //                           color: Colors.red,
// //                           shape: BoxShape.circle,
// //                         ),
// //                         child: Icon(Icons.camera_alt, color: Colors.white, size: 18 * wScale),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //
// //               Transform.translate(
// //                 offset: Offset(0, -30 * wScale),
// //                 child: Column(
// //                   children: [
// //                     // --- DIRECT INLINE EDIT FIELDS ---
// //                     _buildEditableDetail("Name", _nameController, context, wScale),
// //
// //                     // --- PROFILE TYPE RADIO BUTTONS ---
// //                     Container(
// //                       margin: EdgeInsets.symmetric(horizontal: 20 * wScale, vertical: 10 * wScale),
// //                       child: Row(
// //                         children: [
// //                           Expanded(
// //                             flex: 3,
// //                             child: Text(
// //                               "Profile Type",
// //                               style: TextStyle(
// //                                 fontWeight: FontWeight.bold,
// //                                 fontSize: ResponsiveHelper.getFontSize(context, baseSize: 15),
// //                               ),
// //                             ),
// //                           ),
// //                           Expanded(
// //                             flex: 5,
// //                             child: Row(
// //                               children: [
// //                                 Radio<String>(
// //                                   value: "Resident",
// //                                   groupValue: _profileType,
// //                                   activeColor: Colors.red,
// //                                   visualDensity: VisualDensity.compact,
// //                                   onChanged: (value) => setState(() => _profileType = value!),
// //                                 ),
// //                                 Text("Resident", style: TextStyle(fontSize: ResponsiveHelper.getFontSize(context, baseSize: 13))),
// //
// //                                 Radio<String>(
// //                                   value: "Business",
// //                                   groupValue: _profileType,
// //                                   activeColor: Colors.red,
// //                                   visualDensity: VisualDensity.compact,
// //                                   onChanged: (value) => setState(() => _profileType = value!),
// //                                 ),
// //                                 Text("Business", style: TextStyle(fontSize: ResponsiveHelper.getFontSize(context, baseSize: 13))),
// //                               ],
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //
// //                     _buildEditableDetail("Address", _addressController, context, wScale),
// //                     _buildEditableDetail("Gender", _genderController, context, wScale, hint: "Male / Female"),
// //                     _buildEditableDetail("Date of Birth", _birthdayController, context, wScale, hint: "DD/MM/YYYY"),
// //                     _buildEditableDetail("Mobile", _mobileController, context, wScale, isPhone: true),
// //                     _buildEditableDetail("Email", _emailController, context, wScale),
// //
// //                     SizedBox(height: 30 * wScale),
// //
// //
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.center, // 🚀 Dono ko center mein laane ke liye
// //                       children: [
// //                         // SHARE BUTTON
// //                         Padding(
// //                           padding: const EdgeInsets.symmetric(horizontal: 5.0),
// //                           child: ElevatedButton.icon(
// //                             onPressed: _shareApp,
// //                             style: ElevatedButton.styleFrom(
// //                               backgroundColor: Colors.red,
// //                               foregroundColor: Colors.white,
// //                               // 🚀 Padding kam kar di taaki button ki height/width choti ho jaye
// //                               padding: EdgeInsets.symmetric(horizontal: 12 * wScale, vertical: 8 * wScale),
// //                               shape: RoundedRectangleBorder(
// //                                 borderRadius: BorderRadius.circular(12 * wScale),
// //                               ),
// //                               elevation: 0,
// //                             ),
// //                             icon: Icon(Icons.share_sharp, size: 16 * wScale), // 🚀 Icon size 20 se 16 kiya
// //                             label: Text(
// //                               'Share', // 🚀 Text thoda chota kar diya better look ke liye
// //                               style: TextStyle(fontSize: 12 * wScale, fontWeight: FontWeight.bold), // 🚀 Font 14 se 12 kiya
// //                             ),
// //                           ),
// //                         ),
// //
// //                         SizedBox(width: 10 * wScale), // 🚀 Beech ka gap 15 se 10 kar diya
// //
// //                         // LOGOUT BUTTON
// //                         Padding(
// //                           padding: const EdgeInsets.symmetric(horizontal: 5.0),
// //                           child: ElevatedButton.icon(
// //                             onPressed: _logout,
// //                             style: ElevatedButton.styleFrom(
// //                               backgroundColor: Colors.red,
// //                               foregroundColor: Colors.white,
// //                               // 🚀 Padding kam kar di
// //                               padding: EdgeInsets.symmetric(horizontal: 12 * wScale, vertical: 8 * wScale),
// //                               shape: RoundedRectangleBorder(
// //                                 borderRadius: BorderRadius.circular(12 * wScale),
// //                               ),
// //                               elevation: 0,
// //                             ),
// //                             icon: Icon(Icons.logout_outlined, size: 16 * wScale), // 🚀 Icon size 20 se 16 kiya
// //                             label: Text(
// //                               'Logout',
// //                               style: TextStyle(fontSize: 12 * wScale, fontWeight: FontWeight.bold), // 🚀 Font 14 se 12 kiya
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //
// //               // SizedBox(height:5 * wScale),
// //                     // --- SAVE BUTTON ---
// //                     Padding(
// //                       padding: EdgeInsets.symmetric(horizontal: 20 * wScale, ),
// //                       child: ElevatedButton(
// //                         onPressed: _saveProfileData,
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: Colors.red,
// //                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12 * wScale)),
// //                           elevation: 3,
// //                         ),
// //                         child: Text(
// //                           "Save Profile",
// //                           style: TextStyle(color: Colors.white, fontSize: 18 * wScale, fontWeight: FontWeight.bold),
// //                         ),
// //                       ),
// //                     ),
// //                     SizedBox(height: 30 * wScale),
// //                   ],
// //                 ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   // Custom Inline TextFormField Widget
// //   Widget _buildEditableDetail(String title, TextEditingController controller, BuildContext context, double wScale, {String hint = "", bool isPhone = false}) {
// //     return Padding(
// //       padding: EdgeInsets.symmetric(horizontal: 20 * wScale, vertical: 6 * wScale),
// //       child: Row(
// //         crossAxisAlignment: CrossAxisAlignment.center,
// //         children: [
// //           Expanded(
// //             flex: 3,
// //             child: Text(
// //               title,
// //               style: TextStyle(
// //                 fontWeight: FontWeight.bold,
// //                 fontSize: ResponsiveHelper.getFontSize(context, baseSize: 15),
// //                 color: Colors.black87,
// //               ),
// //             ),
// //           ),
// //           Expanded(
// //             flex: 5,
// //             child: TextFormField(
// //               controller: controller,
// //               keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
// //               style: TextStyle(
// //                 fontSize: ResponsiveHelper.getFontSize(context, baseSize: 15),
// //                 color: Colors.grey[800],
// //               ),
// //               decoration: InputDecoration(
// //                 hintText: hint.isNotEmpty ? hint : "Enter $title",
// //                 hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: ResponsiveHelper.getFontSize(context, baseSize: 14)),
// //                 isDense: true,
// //                 contentPadding: EdgeInsets.symmetric(vertical: 8 * wScale, horizontal: 5 * wScale),
// //                 // Clean bottom border line for the form field
// //                 border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
// //                 enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
// //                 focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2)),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
//
//
// import 'package:flutter/cupertino.dart';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gnw/utils/SucessButton.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:image_picker/image_picker.dart';
// import '../login_signup page/login.dart';
// import '../utils/responsive_helper.dart';
// import 'package:share_plus/share_plus.dart';
//
// class Profilepage extends ConsumerStatefulWidget {
//   const Profilepage({super.key});
//
//   @override
//   ConsumerState<Profilepage> createState() => _ProfilepageState();
// }
//
// class _ProfilepageState extends ConsumerState<Profilepage> {
//   bool _isLoading = true;
//
//   // --- SHARE APP LOGIC ---
//   void _shareApp() {
//     SharePlus.instance.share(ShareParams(text: "Check out GNW Bazaar! The No.1 Search APP for Greater Noida West. Download now!"));
//   }
//
//   // --- LOGOUT LOGIC ---
//   Future<void> _logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear(); // Saara user data delete karega
//
//     if (mounted) {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => LoginPage()),
//             (route) => false,
//       );
//       Sucessbutton.show(context, message: "you log out");
//     }
//   }
//
//   // Controllers for direct inline editing
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _birthdayController = TextEditingController();
//   final TextEditingController _mobileController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//
//   String _profileType = "Resident";
//   String _selectedGender = "Male"; // Added state variable for Gender
//   File? _imageFile;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadProfileData();
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _addressController.dispose();
//     _birthdayController.dispose();
//     _mobileController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }
//
//   // --- 1. LOAD DATA ON STARTUP ---
//   Future<void> _loadProfileData() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _nameController.text = prefs.getString("user_name") ?? "";
//       _emailController.text = prefs.getString("user_email") ?? "";
//       _mobileController.text = prefs.getString("user_phone") ?? "";
//       _addressController.text = prefs.getString("address") ?? "";
//       _selectedGender = prefs.getString("gender") ?? "Male"; // Load gender as String
//       _birthdayController.text = prefs.getString("birthday") ?? "";
//       _profileType = prefs.getString("profileType") ?? "Resident";
//
//       String? imagePath = prefs.getString("profile_image");
//       if (imagePath != null && imagePath.isNotEmpty) {
//         _imageFile = File(imagePath);
//       }
//       _isLoading = false;
//     });
//   }
//
//   // --- 2. PICK IMAGE FROM GALLERY ---
//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }
//
//   // --- 3. SAVE ALL DATA ---
//   Future<void> _saveProfileData() async {
//     FocusScope.of(context).unfocus(); // Close the keyboard
//
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString("user_name", _nameController.text.trim());
//     await prefs.setString("user_email", _emailController.text.trim());
//     await prefs.setString("user_phone", _mobileController.text.trim());
//     await prefs.setString("address", _addressController.text.trim());
//     await prefs.setString("gender", _selectedGender); // Save gender state
//     await prefs.setString("birthday", _birthdayController.text.trim());
//     await prefs.setString("profileType", _profileType);
//
//     if (_imageFile != null) {
//       await prefs.setString("profile_image", _imageFile!.path);
//     }
//
//     if (mounted) {
//       Sucessbutton.show(context, message: "Profile Saved!");
//     }
//   }
//
// // --- 4. SELECT DATE OF BIRTH (MODERN BOTTOM SHEET) ---
// // --- 4. SELECT DATE OF BIRTH (MODERN SCROLLING WHEEL) ---
//   Future<void> _selectDate(BuildContext context) async {
//     DateTime initialDate = DateTime.now();
//
//     // Parse existing date to show it on the wheel if already selected
//     if (_birthdayController.text.isNotEmpty) {
//       try {
//         List<String> parts = _birthdayController.text.split('/');
//         if (parts.length == 3) {
//           initialDate = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
//         }
//       } catch (e) {
//         // Fallback to current date on parsing error
//       }
//     }
//
//     // Temporary variable to hold the date while scrolling
//     DateTime tempPickedDate = initialDate;
//
//     await showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (BuildContext builderContext) {
//         return SizedBox(
//           height: ResponsiveHelper.getContainerHeight(context, baseHeight: 320),
//           child: Column(
//             children: [
//               // Top Action Bar (Cancel & Done)
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(builderContext),
//                       child: const Text("Cancel", style: TextStyle(color: Colors.grey, fontSize: 16)),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         // Only save the date when "Done" is clicked
//                         setState(() {
//                           _birthdayController.text =
//                           "${tempPickedDate.day.toString().padLeft(2, '0')}/${tempPickedDate.month.toString().padLeft(2, '0')}/${tempPickedDate.year}";
//                         });
//                         Navigator.pop(builderContext);
//                       },
//                       child: const Text("Done", style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold)),
//                     ),
//                   ],
//                 ),
//               ),
//               const Divider(height: 1, thickness: 1, color: Colors.black12),
//
//               // 3-Column Scrolling Wheel (Day, Month, Year)
//               Expanded(
//                 child: CupertinoDatePicker(
//                   mode: CupertinoDatePickerMode.date, // Restricts to Date only (no time)
//                   initialDateTime: initialDate,
//                   minimumDate: DateTime(1900),
//                   maximumDate: DateTime.now(), // Prevents selecting future dates
//                   onDateTimeChanged: (DateTime newDate) {
//                     tempPickedDate = newDate;
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Scaffold(
//         backgroundColor: Colors.white,
//         body: Center(child: CircularProgressIndicator(color: Colors.red)),
//       );
//     }
//
//     double wScale = ResponsiveHelper.screenWidth(context) / 390.0;
//
//     return MediaQuery(
//       data: MediaQuery.of(context).copyWith(
//         textScaler: const TextScaler.linear(1.0),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               // --- HEADER ---
//               Container(
//                 width: double.infinity,
//                 height: ResponsiveHelper.getContainerHeight(context, baseHeight: 200),
//                 decoration: const BoxDecoration(
//                   color: Colors.red,
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(120),
//                     bottomRight: Radius.circular(120),
//                   ),
//                 ),
//                 alignment: Alignment.center,
//                 child: Text(
//                   "MY PROFILE",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: ResponsiveHelper.getFontSize(context, baseSize: 24),
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1.2,
//                   ),
//                 ),
//               ),
//
//               // --- CLICKABLE PROFILE PICTURE ---
//               Container(
//                 transform: Matrix4.translationValues(0, -50 * wScale, 0),
//                 child: GestureDetector(
//                   onTap: _pickImage,
//                   child: Stack(
//                     alignment: Alignment.bottomRight,
//                     children: [
//                       CircleAvatar(
//                         radius: ResponsiveHelper.getIconSize(context, baseSize: 55),
//                         backgroundColor: Colors.grey.shade300,
//                         backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
//                         child: _imageFile == null
//                             ? Icon(Icons.person, size: 60 * wScale, color: Colors.grey.shade600)
//                             : null,
//                       ),
//                       Container(
//                         padding: EdgeInsets.all(6 * wScale),
//                         decoration: const BoxDecoration(
//                           color: Colors.red,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(Icons.camera_alt, color: Colors.white, size: 18 * wScale),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               Transform.translate(
//                 offset: Offset(0, -30 * wScale),
//                 child: Column(
//                   children: [
//                     // --- DIRECT INLINE EDIT FIELDS ---
//                     _buildEditableDetail("Name", _nameController, context, wScale),
//
//                     // --- PROFILE TYPE RADIO BUTTONS ---
//                     Container(
//                       margin: EdgeInsets.symmetric(horizontal: 20 * wScale, vertical: 10 * wScale),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             flex: 3,
//                             child: Text(
//                               "Profile Type",
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: ResponsiveHelper.getFontSize(context, baseSize: 15),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             flex: 5,
//                             child: Row(
//                               children: [
//                                 Radio<String>(
//                                   value: "Resident",
//                                   groupValue: _profileType,
//                                   activeColor: Colors.red,
//                                   visualDensity: VisualDensity.compact,
//                                   onChanged: (value) => setState(() => _profileType = value!),
//                                 ),
//                                 Text("Resident", style: TextStyle(fontSize: ResponsiveHelper.getFontSize(context, baseSize: 13))),
//
//                                 Radio<String>(
//                                   value: "Business",
//                                   groupValue: _profileType,
//                                   activeColor: Colors.red,
//                                   visualDensity: VisualDensity.compact,
//                                   onChanged: (value) => setState(() => _profileType = value!),
//                                 ),
//                                 Text("Business", style: TextStyle(fontSize: ResponsiveHelper.getFontSize(context, baseSize: 13))),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     _buildEditableDetail("Address", _addressController, context, wScale),
//
//                     // --- GENDER RADIO BUTTONS ---
//                     Container(
//                       margin: EdgeInsets.symmetric(horizontal: 20 * wScale, vertical: 6 * wScale),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             flex: 3,
//                             child: Text(
//                               "Gender",
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: ResponsiveHelper.getFontSize(context, baseSize: 15),
//                                 color: Colors.black87,
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             flex: 5,
//                             child: Row(
//                               children: [
//                                 Radio<String>(
//                                   value: "Male",
//                                   groupValue: _selectedGender,
//                                   activeColor: Colors.red,
//                                   visualDensity: VisualDensity.compact,
//                                   onChanged: (value) => setState(() => _selectedGender = value!),
//                                 ),
//                                 Text("Male", style: TextStyle(fontSize: ResponsiveHelper.getFontSize(context, baseSize: 13))),
//
//                                 Radio<String>(
//                                   value: "Female",
//                                   groupValue: _selectedGender,
//                                   activeColor: Colors.red,
//                                   visualDensity: VisualDensity.compact,
//                                   onChanged: (value) => setState(() => _selectedGender = value!),
//                                 ),
//                                 Text("Female", style: TextStyle(fontSize: ResponsiveHelper.getFontSize(context, baseSize: 13))),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     // --- DATE OF BIRTH FIELD (WITH CALENDAR TRIGGER) ---
//                     _buildEditableDetail(
//                       "Date of Birth",
//                       _birthdayController,
//                       context,
//                       wScale,
//                       hint: "DD/MM/YYYY",
//                       readOnly: true, // Prevents keyboard from opening
//                       onTap: () => _selectDate(context), // Opens the calendar
//                     ),
//
//                     _buildEditableDetail("Mobile", _mobileController, context, wScale, isPhone: true),
//                     _buildEditableDetail("Email", _emailController, context, wScale),
//
//                     SizedBox(height: 30 * wScale),
//
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         // SHARE BUTTON
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 5.0),
//                           child: ElevatedButton.icon(
//                             onPressed: _shareApp,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.red,
//                               foregroundColor: Colors.white,
//                               padding: EdgeInsets.symmetric(horizontal: 12 * wScale, vertical: 8 * wScale),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12 * wScale),
//                               ),
//                               elevation: 0,
//                             ),
//                             icon: Icon(Icons.share_sharp, size: 16 * wScale),
//                             label: Text(
//                               'Share',
//                               style: TextStyle(fontSize: 12 * wScale, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ),
//
//                         SizedBox(width: 10 * wScale),
//
//                         // LOGOUT BUTTON
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 5.0),
//                           child: ElevatedButton.icon(
//                             onPressed: _logout,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.red,
//                               foregroundColor: Colors.white,
//                               padding: EdgeInsets.symmetric(horizontal: 12 * wScale, vertical: 8 * wScale),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12 * wScale),
//                               ),
//                               elevation: 0,
//                             ),
//                             icon: Icon(Icons.logout_outlined, size: 16 * wScale),
//                             label: Text(
//                               'Logout',
//                               style: TextStyle(fontSize: 12 * wScale, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//
//               // --- SAVE BUTTON ---
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20 * wScale),
//                 child: ElevatedButton(
//                   onPressed: _saveProfileData,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12 * wScale)),
//                     elevation: 3,
//                   ),
//                   child: Text(
//                     "Save Profile",
//                     style: TextStyle(color: Colors.white, fontSize: 18 * wScale, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 30 * wScale),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // --- UPDATED INLINE EDIT WIDGET ---
//   // Added 'readOnly' and 'onTap' properties to support the Date Picker
//   Widget _buildEditableDetail(String title, TextEditingController controller, BuildContext context, double wScale, {String hint = "", bool isPhone = false, bool readOnly = false, VoidCallback? onTap}) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20 * wScale, vertical: 6 * wScale),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Expanded(
//             flex: 3,
//             child: Text(
//               title,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: ResponsiveHelper.getFontSize(context, baseSize: 15),
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 5,
//             child: TextFormField(
//               controller: controller,
//               keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
//               readOnly: readOnly, // Use this for Calendar
//               onTap: onTap,       // Trigger action on tap
//               style: TextStyle(
//                 fontSize: ResponsiveHelper.getFontSize(context, baseSize: 15),
//                 color: Colors.grey[800],
//               ),
//               decoration: InputDecoration(
//                 hintText: hint.isNotEmpty ? hint : "Enter $title",
//                 hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: ResponsiveHelper.getFontSize(context, baseSize: 14)),
//                 isDense: true,
//                 contentPadding: EdgeInsets.symmetric(vertical: 8 * wScale, horizontal: 5 * wScale),
//                 border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
//                 enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
//                 focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2)),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // REQUIRED FOR IOS WIDGETS
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
    SharePlus.instance.share(ShareParams(text: "Check out GNW Bazaar! The No.1 Search APP for Greater Noida West. Download now!"));
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
                Navigator.pop(dialogContext); // Close the dialog
              },
            ),
            CupertinoDialogAction(
              isDestructiveAction: true, // Automatically makes text red in iOS
              onPressed: () {
                Navigator.pop(dialogContext); // Close the dialog first
                _logout(); // Execute the actual logout
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  // --- ACTUAL LOGOUT LOGIC ---
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>  LoginPage()), // Make sure LoginPage matches your import
            (route) => false,
      );
      Sucessbutton.show(context, message: "Logged out");
    }
  }

  // --- LOGOUT LOGIC ---


  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _profileType = "Resident";
  String _selectedGender = "Male";
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
    _birthdayController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString("user_name") ?? "";
      _emailController.text = prefs.getString("user_email") ?? "";
      _mobileController.text = prefs.getString("user_phone") ?? "";
      _addressController.text = prefs.getString("address") ?? "";
      _selectedGender = prefs.getString("gender") ?? "Male";
      _birthdayController.text = prefs.getString("birthday") ?? "";
      _profileType = prefs.getString("profileType") ?? "Resident";

      String? imagePath = prefs.getString("profile_image");
      if (imagePath != null && imagePath.isNotEmpty) {
        _imageFile = File(imagePath);
      }
      _isLoading = false;
    });
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

  Future<void> _saveProfileData() async {
    FocusScope.of(context).unfocus();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_name", _nameController.text.trim());
    await prefs.setString("user_email", _emailController.text.trim());
    await prefs.setString("user_phone", _mobileController.text.trim());
    await prefs.setString("address", _addressController.text.trim());
    await prefs.setString("gender", _selectedGender);
    await prefs.setString("birthday", _birthdayController.text.trim());
    await prefs.setString("profileType", _profileType);

    if (_imageFile != null) {
      await prefs.setString("profile_image", _imageFile!.path);
    }

    if (mounted) {
      Sucessbutton.show(context, message: "Profile Saved!");
    }
  }

  // --- 4. SELECT DATE OF BIRTH (MODERN SCROLLING WHEEL) ---
  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();

    if (_birthdayController.text.isNotEmpty) {
      try {
        List<String> parts = _birthdayController.text.split('/');
        if (parts.length == 3) {
          initialDate = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
        }
      } catch (e) {}
    }

    DateTime tempPickedDate = initialDate;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext builderContext) {
        return SizedBox(
          height: ResponsiveHelper.getContainerHeight(context, baseHeight: 320),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(builderContext),
                      child: const Text("Cancel", style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _birthdayController.text =
                          "${tempPickedDate.day.toString().padLeft(2, '0')}/${tempPickedDate.month.toString().padLeft(2, '0')}/${tempPickedDate.year}";
                        });
                        Navigator.pop(builderContext);
                      },
                      child: const Text("Done", style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1, color: Colors.black12),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: initialDate,
                  minimumDate: DateTime(1900),
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: (DateTime newDate) {
                    tempPickedDate = newDate;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
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
        backgroundColor: const Color(0xFFF2F2F7), // Apple System Grouped Background Color
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

                          // --- IOS STYLE PROFILE TYPE TOGGLE ---
                          _buildIOSSegmentedRow(
                            title: "Profile",
                            context: context,
                            wScale: wScale,
                            groupValue: _profileType,
                            children: {
                              "Resident": const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text("Resident")),
                              "Business": const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text("Business")),
                            },
                            onValueChanged: (value) => setState(() => _profileType = value.toString()),
                          ),

                          _buildEditableDetail("Address", _addressController, context, wScale),

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
                            onValueChanged: (value) => setState(() => _selectedGender = value.toString()),
                          ),

                          _buildEditableDetail(
                            "DOB",
                            _birthdayController,
                            context,
                            wScale,
                            hint: "   DD/MM/YYYY",
                            readOnly: true,

                            onTap: () => _selectDate(context),
                          ),

                          _buildEditableDetail("Mobile", _mobileController, context, wScale, isPhone: true),

                          // Final item doesn't need a bottom divider, so we use a modified widget or let it be
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: ElevatedButton.icon(
                            onPressed: _showLogoutConfirmation, // CHANGED HERE
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.grey.shade700,
                              padding: EdgeInsets.symmetric(horizontal: 16 * wScale, vertical: 10 * wScale),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10 * wScale),
                                side: BorderSide(color: Colors.grey.shade400, width: 1),
                              ),
                              elevation: 0,
                            ),
                            icon: Icon(Icons.logout_outlined, size: 18 * wScale),
                            label: Text(
                              'Logout',
                              style: TextStyle(fontSize: 14 * wScale, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
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
                width: 90 * wScale, // Fixed width so all inputs align perfectly vertically
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getFontSize(context, baseSize: 15),
                    color: Colors.black, // Solid black like iOS
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
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getFontSize(context, baseSize: 15),
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: hint.isNotEmpty ? hint : title,
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: ResponsiveHelper.getFontSize(context, baseSize: 15)),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10 * wScale, horizontal: 0),
                    // iOS TRICK: Completely remove borders
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        // iOS TRICK: Thin grey inset divider
        if (showDivider)
          Padding(
            padding: EdgeInsets.only(left: 16 * wScale),
            child: const Divider(height: 1, thickness: 0.5, color: CupertinoColors.separator),
          ),
      ],
    );
  }

  // --- IOS STYLE SEGMENTED CONTROL ROW WIDGET ---
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