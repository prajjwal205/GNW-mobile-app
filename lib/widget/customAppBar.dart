import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import 'package:gnw/pages/ProfilePage.dart';
import 'package:gnw/homepage.dart';
import '../utils/responsive_helper.dart';
import '../services/auth_provider.dart';
import '../login_signup page/login.dart';

PreferredSizeWidget buildCustomAppBar(
    BuildContext context,
    String userName,
    double appBarHeight,
    ) {
  final responsiveHeight = ResponsiveHelper.getAppBarHeight(context);
  final padding = ResponsiveHelper.getPadding(context);
  final spacing = ResponsiveHelper.getSpacing(context, baseSpacing: 6);

  // --- EXTRACT AND CAPITALIZE FIRST NAME ---
  String rawName = userName.toString().trim();
  String firstName = rawName.isNotEmpty ? rawName.split(' ').first : '';
  String displayFirstName = firstName.isNotEmpty
      ? '${firstName[0].toUpperCase()}${firstName.substring(1)}'
      : '';

  return PreferredSize(
    preferredSize: Size.fromHeight(responsiveHeight),
    child: SafeArea(
      bottom: false,
      child: Container(
        height: responsiveHeight,
        padding: EdgeInsets.only(
          left: padding.horizontal / 2,
        ),
        color: const Color(0xFFFFA726),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // ================= LEFT SIDE =================
            Expanded(
              child: Row(
                children: [
                  Image.asset(
                    'lib/images/GNW_RED_LOGO.png',
                    height: responsiveHeight * 0.75,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: spacing),

                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi,',
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getFontSize(
                                context,
                                baseSize: 14,
                              ),
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            displayFirstName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getFontSize(
                                context,
                                baseSize: 16,
                              ),
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ================= RIGHT SIDE =================
            SizedBox(
              height: responsiveHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  _actionIcon(
                    context,
                    icon: Icons.person,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Profilepage()),
                      );
                    },
                  ),
                  SizedBox(width: spacing),

                  _actionIcon(
                    context,
                    icon: Icons.home,
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const Homepage()),
                            (route) => false,
                      );
                    },
                  ),
                  SizedBox(width: spacing),

                  _actionIcon(
                    context,
                    icon: Icons.notifications,
                    onTap: () {},
                  ),
                  const SizedBox(width: .01),
                  Consumer(
                    builder: (context, ref, child) {
                      // 1. Maintain the same container size (36) for alignment
                      final double size = ResponsiveHelper.getIconSize(context, baseSize: 36);

                      return SizedBox(
                        width: size,
                        height: size,
                        child: PopupMenuButton<String>(
                          color: Colors.white,
                          padding: EdgeInsets.zero,
                          offset: const Offset(0, 45),
                              child: Container(
                            child: Center(
                              child: Icon(
                                Icons.more_vert,
                                color: Colors.black, // Black icon on Orange background
                              ),
                            ),
                          ),

                          onSelected: (value) async {
                            if (value == 'logout') {
                              await ref.read(authControllerProvider.notifier).logout();
                              if (context.mounted) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (_) => LoginPage()),
                                      (route) => false,
                                );
                              }
                            } else if (value == 'share') {
                              await Share.share(
                                'Check out GNW - The No.1 Search Engine!\nhttp://gnwbazaar.com',
                                subject: 'GNW App Invitation',
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'share',
                              child: ListTile(
                                leading: const Icon(Icons.share, color: Colors.blue, size: 20),
                                title: const Text('Share App', style: TextStyle(fontSize: 14)),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            const PopupMenuDivider(),
                            PopupMenuItem(
                              value: 'logout',
                              child: ListTile(
                                leading: const Icon(Icons.logout, color: Colors.red, size: 20),
                                title: const Text('Logout', style: TextStyle(color: Colors.red, fontSize: 14)),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    ),
  );
}

// ================= ACTION ICON WIDGET =================
Widget _actionIcon(
    BuildContext context, {
      required IconData icon,
      required VoidCallback onTap,
    }) {
  final double size = ResponsiveHelper.getIconSize(context, baseSize: 36);

  return SizedBox(
    width: size,
    height: size,
    child: InkWell(
      borderRadius: BorderRadius.circular(size),
      onTap: onTap,
      child: Center(
        child: CircleAvatar(
          radius: 16,
          backgroundColor: Colors.black,
          child: Icon(
            icon,
            size: ResponsiveHelper.getIconSize(context, baseSize: 22),
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
