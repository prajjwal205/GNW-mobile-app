import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gnw/Models/client_model.dart';
import 'package:gnw/services/auth_provider.dart';
import 'package:gnw/utils/responsive_helper.dart';
import 'package:gnw/widget/customAppBar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/info_row_svg.dart';

final userNameProvider = FutureProvider<String>((ref) async {
  return AuthService.fetchUserName();
});

class ClientDetailPage extends ConsumerWidget {
  final ClientModel client;

  const ClientDetailPage({super.key, required this.client});

  Future<void> _callNumber(BuildContext context, String number) async {
    if (number.isEmpty) return;

    final Uri uri = Uri(scheme: 'tel', path: number);

    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not call $number")),
      );
    }
  }

  Future<void> _openWhatsapp(BuildContext context, String number) async {
    if (number.isEmpty) return;

    String formatted = number.replaceAll(" ", "").replaceAll("+91", "");
    final Uri uri = Uri.parse("https://wa.me/91$formatted");

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open WhatsApp")),
      );
    }
  }

  Future<void> _openMap(BuildContext context, String address) async {
    if (address.isEmpty) return;

    final Uri uri = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}",
    );

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open Maps")),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNameAsync = ref.watch(userNameProvider);

    return userNameAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        body: Center(child: Text("Error: $err")),
      ),
      data: (userName) {
        double width = MediaQuery.of(context).size.width;
        bool isSmall = width < 400;

        double posterHeight = isSmall ? 300 : 380;
        double titleFont = isSmall ? 20 : 24;
        double normalFont = isSmall ? 13 : 15;

        final imageProvider =
        (client.clientImage != null && client.clientImage!.isNotEmpty)
            ? NetworkImage(client.clientImage!)
            : const AssetImage('lib/images/image_21.png') as ImageProvider;

        return Scaffold(
          backgroundColor: Colors.white,

          // ✅ Custom AppBar
          appBar: buildCustomAppBar(
            context,
            userName,
            ResponsiveHelper.getAppBarHeight(context),
          ),

          body: SingleChildScrollView(
            child: Column(
              children: [
                // ==============================
                // POSTER IMAGE
                // ==============================
                Container(
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Column(
                      children: [
                        Container(
                          height: posterHeight,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // Bottom Gradient Bar
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF6A1B9A), Color(0xFFD81B60)],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Book your Appointment today!",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isSmall ? 12 : 13,
                                ),
                              ),
                              InkWell(
                                onTap: () =>
                                    _callNumber(context, client.phoneNumber),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.call,
                                          size: 14,
                                          color: Color(0xFFD81B60)),
                                      const SizedBox(width: 4),
                                      Text(
                                        client.phoneNumber,
                                        style: TextStyle(
                                          color: const Color(0xFFD81B60),
                                          fontWeight: FontWeight.bold,
                                          fontSize: isSmall ? 11 : 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ==============================
                // TITLE + WHATSAPP ICON
                // ==============================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          client.clientName,
                          style: TextStyle(
                            fontSize: titleFont,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      GestureDetector(
                        onTap: () =>
                            _openWhatsapp(context, client.phoneNumber),
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          child: SvgPicture.asset(
                            "lib/icons/whatsapp.svg",
                            height: isSmall ? 35 : 28,
                            width: isSmall ? 35 : 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ==============================
                // ADDRESS SECTION
                // ==============================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => _openMap(context, client.address),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFF263238),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.navigation,
                              color: Colors.white, size: 28),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          client.address,
                          style: TextStyle(
                            fontSize: normalFont,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // ==============================
                // CALL BUTTON
                // ==============================
                GestureDetector(
                  onTap: () => _callNumber(context, client.phoneNumber),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFA726),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black, width: 1.3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "CALL",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(width: 12),
                        Container(width: 1, height: 18, color: Colors.black),
                        const SizedBox(width: 12),
                        Text(
                          client.phoneNumber,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFA726),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "CONTACT DETAILS",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),

                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      InfoRowSvg(
                        svgPath: "lib/icons/user.svg",
                        label: "Contact",
                        value: client.contactPerson,
                      ),

                      const SizedBox(height: 12),

                      InfoRowSvg(
                        svgPath: "lib/icons/email.svg",
                        label: "Email",
                        value: client.email,
                        isEmail: true,

                      ),
                      const SizedBox(height: 12),

                      InfoRowSvg(
                        svgPath: "lib/icons/location.svg",
                        label: "Location",
                        value: client.location,
                      ),

                    ],

                  ),
                ),

                const SizedBox(height: 25),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(width: 10),
        Text(
          "$label : ",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: Colors.grey[800]),
          ),
        ),
      ],
    );
  }
}
