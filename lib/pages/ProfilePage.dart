import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/responsive_helper.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  Future<Map<String, dynamic>> fetchProfile() async {
    try {
      final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users/1"));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to load profile: ${response.statusCode}");
      }
    } catch (e) {
      // Mock fallback data
      return {
        "name": "Prajjwal Srivastava",
        "profileType": "Resident",
        "address": "123 Main St, Banda, 210201",
        "gender": "Male",
        "birthday": "1995-06-15",
        "mobile": "+91 9876543210",
        "email": "prajjwals@gmail.com",
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No profile data"));
          }

          final profile = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Header
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
                    ),
                  ),
                ),

                // Profile picture
                Container(
                  transform: Matrix4.translationValues(0, -50, 0),
                  child: CircleAvatar(
                    radius: ResponsiveHelper.getIconSize(context, baseSize: 50),
                    backgroundColor: Colors.black,
                    child: Text(
                      "Picture",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.getFontSize(context, baseSize: 14),
                      ),
                    ),
                  ),
                ),

                // Details (matching your screenshot sections)
                buildDetail("Name", profile["name"] ?? "N/A"),

                // Profile type with Resident / Business options
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      const Text("Profile Type :",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 16),
                      Row(
                        children: [
                          Radio<String>(
                            value: "Resident",
                            groupValue: profile["profileType"],
                            onChanged: (_) {},
                          ),
                          const Text("Resident"),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Row(
                        children: [
                          Radio<String>(
                            value: "Business",
                            groupValue: profile["profileType"],
                            onChanged: (_) {},
                          ),
                          const Text("Business"),
                        ],
                      ),
                    ],
                  ),
                ),

                buildDetail("Address", profile["address"] ?? "N/A"),
                buildDetail("Gender", profile["gender"] ?? "N/A"),
                buildDetail("Birthday", profile["birthday"] ?? "N/A"),
                buildDetail("Mobile Number", profile["mobile"] ?? "N/A"),
                buildDetail("Email", profile["email"] ?? "N/A"),
              ],
            ),
          );
        },
      ),

      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(12.0),
      //   child: Center(
      //     child: ElevatedButton.icon(
      //       onPressed: () => Navigator.pop(context),
      //       icon: const Icon(Icons.arrow_back, size: 18),
      //       label: const Text("Back"),
      //       style: ElevatedButton.styleFrom(
      //         backgroundColor: Colors.red,
      //         foregroundColor: Colors.white,
      //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(30),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  Widget buildDetail(String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black26,),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
