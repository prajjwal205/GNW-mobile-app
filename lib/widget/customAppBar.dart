import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod
import 'package:share_plus/share_plus.dart';             // Share Plus
import 'package:gnw/pages/ProfilePage.dart';
import 'package:gnw/homepage.dart';
import '../utils/responsive_helper.dart';

// Import Auth Provider & Login Page
import '../providers/auth_provider.dart';
import '../login_signup page/login.dart';

PreferredSizeWidget buildCustomAppBar(
    BuildContext context, String userName, double appBarHeight) {

  // 1. Get Responsive Values
  final responsiveHeight = ResponsiveHelper.getAppBarHeight(context);
  final padding = ResponsiveHelper.getPadding(context);
  final spacing = ResponsiveHelper.getSpacing(context, baseSpacing: 10);

  return PreferredSize(
    preferredSize: Size.fromHeight(responsiveHeight),
    child: SafeArea(
      minimum: const EdgeInsets.only(top: 10),
      child: Container(
        height: responsiveHeight,
        color: const Color(0xFFFFA726), // Orange background
        // FIX 1: Use specific padding. Left keeps resizing, Right is fixed small (5)
        padding: EdgeInsets.only(
            left: padding.horizontal / 2,
            right: 5 // Forces icons closer to the right edge
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // --- LEFT SIDE: Logo + Name ---
            Row(
              children: [
                Image.asset(
                  'lib/images/GNW_RED_LOGO.png',
                  height: responsiveHeight * 0.80, // Dynamic Logo Size
                ),
                SizedBox(width: spacing),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi,',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ResponsiveHelper.getFontSize(context, baseSize: 14),
                      ),
                    ),
                    Text(
                      userName.toUpperCase(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ResponsiveHelper.getFontSize(context, baseSize: 16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // --- RIGHT SIDE: Icons & Menu ---
            Row(
              children: [
                // 1. Profile
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profilepage()),
                    );
                  },
                  child: _roundedIconWithLabel(context, Icons.person, "Profile"),
                ),
                SizedBox(width: spacing),

                // 2. Home
                InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Homepage()),
                          (route) => false,
                    );
                  },
                  child: _roundedIconWithLabel(context, Icons.home, "Home"),
                ),
                SizedBox(width: spacing),

                // 3. Notification
                _roundedIconWithLabel(context, Icons.notifications, "Notification"),

                // FIX 2: Use half-spacing here (reduces gap between Notification & Dots)
                SizedBox(width: spacing /50),

                // 4. THREE DOT MENU (Logout & Share)
                Consumer(
                  builder: (context, ref, child) {
                    return PopupMenuButton<String>(
                      // FIX 3: Remove the button's internal invisible padding
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.black,
                        size: ResponsiveHelper.getIconSize(context, baseSize: 29),
                      ),
                      onSelected: (value) async {
                        if (value == 'logout') {
                          await ref.read(authControllerProvider.notifier).logout();
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                                  (route) => false,
                            );
                          }
                        } else if (value == 'share') {
                          await Share.share(
                              'Check out GNW - The No.1 Search Engine! \nhttp://gnwbazaar.com',
                              subject: 'GNW App Invitation'
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'share',
                          child: ListTile(
                            leading: Icon(Icons.share, color: Colors.blue, size: 20),
                            title: Text('Share App', style: TextStyle(fontSize: 14)),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem<String>(
                          value: 'logout',
                          child: ListTile(
                            leading: Icon(Icons.logout, color: Colors.red, size: 20),
                            title: Text('Logout', style: TextStyle(color: Colors.red, fontSize: 14)),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    );
                  },
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}

// Helper widget for fully responsive icons
Widget _roundedIconWithLabel(BuildContext context, IconData icon, String label) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircleAvatar(
        // Responsive Radius
        radius: ResponsiveHelper.getIconSize(context, baseSize: 18),
        backgroundColor: Colors.black,
        child: Icon(
          icon,
          color: Colors.white,
          // Responsive Icon Size
          size: ResponsiveHelper.getIconSize(context, baseSize: 22),
        ),
      ),
      SizedBox(height: 2),
      Text(
        label,
        style: TextStyle(
            color: Colors.black,
            // Responsive Font Size
            fontSize: ResponsiveHelper.getFontSize(context, baseSize: 10),
            fontWeight: FontWeight.bold
        ),
      ),
    ],
  );
}