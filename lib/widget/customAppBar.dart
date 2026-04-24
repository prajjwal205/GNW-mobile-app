import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gnw/pages/ProfilePage.dart';
import 'package:gnw/homepage.dart';
import '../utils/responsive_helper.dart';
import '../services/auth_provider.dart';
import 'dart:async';
import 'package:intl/intl.dart';

final appBarUserNameProvider = FutureProvider.autoDispose<String>((ref) async {
  return await AuthService.fetchUserName();
});


final realTimeProvider = StreamProvider.autoDispose<String>((ref) {
  return Stream.periodic(const Duration(seconds: 0), (_) {
    return DateFormat('hh:mm a | EEE, dd MMM, yyyy').format(DateTime.now());
  });
});
class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final double appBarHeight;

   CustomAppBar({
    super.key,
    required this.appBarHeight,
  });


  final realTimeProvider = StreamProvider.autoDispose<String>((ref) {
    return Stream.periodic(const Duration(seconds: 0), (_) {
      // Layout: 10:45 AM | Tue, 15 Apr, 2026
      return DateFormat('hh:mm a | EEE, dd MMM, yyyy').format(DateTime.now());
    });
  });
  @override
  Size get preferredSize => Size.fromHeight(appBarHeight+20);

  Future<void> _dialSOS(BuildContext context) async {
    final Uri uri = Uri(scheme: 'tel', path: '112');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red),
                SizedBox(width: 10),
                Text("Dialer Error"),
              ],
            ),
            content: const Text("Sorry, your device does not support direct calling. Please dial manually."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK", style: TextStyle(color: Color(0xFFFFA726), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTime = ref.watch(realTimeProvider).value ?? "...";
    final padding = ResponsiveHelper.getPadding(context);
    final spacing = ResponsiveHelper.getSpacing(context, baseSpacing: 6);

    final userAsync = ref.watch(appBarUserNameProvider);
    final String rawName = userAsync.value ?? "";

    // --- EXTRACT AND CAPITALIZE FIRST NAME ---
    final String firstName = rawName.trim().isNotEmpty ? rawName.trim().split(' ').first : '';
    final String displayFirstName = firstName.isNotEmpty
        ? '${firstName[0].toUpperCase()}${firstName.substring(1)}'
        : '...'; // Shows "..." while loading

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: SafeArea(
        bottom: false,
        child: Container(
          height: appBarHeight,
          padding: EdgeInsets.only(left: padding.horizontal / 2),
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
                      height: appBarHeight * 0.75,
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
                                fontSize: ResponsiveHelper.getFontSize(context, baseSize: 14),
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              displayFirstName, // Displays the extracted first name
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getFontSize(context, baseSize: 16),
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
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: 6,),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ActionIcon(
                          icon: Icons.person,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => Profilepage()),
                          ),
                        ),
                        SizedBox(width: spacing),

                        ActionIcon(
                          icon: Icons.home,
                          onTap: () => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const Homepage()),
                                (route) => false,
                          ),
                        ),
                        SizedBox(width: spacing),

                        ActionIcon(
                          icon: Icons.notifications,
                          onTap: () {},
                        ),
                        SizedBox(width: spacing,),
                        ActionIcon(
                          imagePath: 'lib/images/SOS_ICON.png',
                          onTap: () => _dialSOS(context),
                          icon: null,
                        ),
                        // const SizedBox(width: 0),
                        // _buildPopupMenu(context, ref),
                      ],
                    ),
                    Text(
                      currentTime, // Hamara provider wala time
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
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

  // --- POPUP MENU WIDGET ---
  // Widget _buildPopupMenu(BuildContext context, WidgetRef ref) {
  //   final double size = ResponsiveHelper.getIconSize(context, baseSize: 36);
  //
  //   return SizedBox(
  //     width: size,
  //     height: size,
  //     child: PopupMenuButton<String>(
  //       color: Colors.white,
  //       padding: EdgeInsets.zero,
  //       offset: const Offset(0, 45),
  //       icon: const Icon(Icons.more_vert, color: Colors.black),
  //       onSelected: (value) async {
  //         if (value == 'logout') {
  //           await ref.read(authControllerProvider.notifier).logout();
  //           if (context.mounted) {
  //             Navigator.pushAndRemoveUntil(
  //               context,
  //               MaterialPageRoute(builder: (_) => LoginPage()),
  //                   (route) => false,
  //             );
  //           }
  //         } else if (value == 'share') {
  //
  //           await Share.share(
  //             'Share app abhi nhi complete h!\nhttp://gnwbazaar.com',
  //             subject: 'GNW App Invitation',
  //           );
  //         }
  //       },
  //       itemBuilder: (context) => [
  //         const PopupMenuItem(
  //           value: 'share',
  //           child: ListTile(
  //             leading: Icon(Icons.share, color: Colors.blue, size: 20),
  //             title: Text('Share App', style: TextStyle(fontSize: 14)),
  //             contentPadding: EdgeInsets.zero,
  //           ),
  //         ),
  //         const PopupMenuDivider(),
  //         const PopupMenuItem(
  //           value: 'logout',
  //           child: ListTile(
  //             leading: Icon(Icons.logout, color: Colors.red, size: 20),
  //             title: Text('Logout', style: TextStyle(color: Colors.red, fontSize: 14)),
  //             contentPadding: EdgeInsets.zero,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

// Purane ActionIcon code ko isse replace karein
class ActionIcon extends StatelessWidget {
  final IconData? icon;
  final VoidCallback onTap;
  final String? imagePath;

  const ActionIcon({
    super.key,
    this.icon,
    required this.onTap,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final double size = ResponsiveHelper.getIconSize(context, baseSize: 36);

    return SizedBox(
      width: size,
      height: size,
      child: InkWell(
        borderRadius: BorderRadius.circular(size),
        onTap: onTap,
        child: Center(
          child: imagePath != null
              ? Container(
            // 🚀 Yahan black border add kiya hai
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 4.5),
            ),
            child: ClipOval(
              child: Image.asset(
                imagePath!,
                width: size * 0.9,
                height: size * 0.9,
                fit: BoxFit.cover,
              ),
            ),
          )
              : CircleAvatar(
            radius: size * 0.45,
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
}

