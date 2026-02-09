import 'package:flutter/material.dart';
import 'package:gnw/Models/healthcare_model.dart';
import 'package:gnw/pages/doctor_details_page.dart';
import 'package:gnw/providers/auth_provider.dart';
import 'package:gnw/widget/Health_category_button.dart';
import 'package:gnw/widget/fade_in_animation.dart';
import '../widget/customAppBar.dart';
import '../utils/responsive_helper.dart';


class HealthcarePage extends StatefulWidget {
  const HealthcarePage({super.key});

  @override
  State<HealthcarePage> createState() => _HealthcarePageState();
}

class _HealthcarePageState extends State<HealthcarePage> {
  // Variables
  late Future<String> _userNameFuture;
  List<HealthcareCategoryModel> _allCategories = []; // Stores full list
  List<HealthcareCategoryModel> _filteredCategories = []; // Stores filtered list
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userNameFuture = AuthService.fetchUserName();
    _loadCategories();
  }

  // Fetch and Store Data
  Future<void> _loadCategories() async {
    final list = await AuthService.fetchHealthcareCategories();
    if (mounted) {
      setState(() {
        _allCategories = list.cast<HealthcareCategoryModel>();
        _filteredCategories = list.cast<HealthcareCategoryModel>(); // Initially, show everything
        _isLoading = false;
      });
    }
  }

  // Search Logic
  void _filterCategories(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      _filteredCategories = _allCategories.where((item) {
        return item.category.toLowerCase().contains(lowerQuery);
      }).toList();
    });
  }

  // --- Helpers ---
  IconData _getIcon(String category) {
    String name = category.toLowerCase();
    if (name.contains("cardio")) return Icons.favorite;
    if (name.contains("dentist")) return Icons.medical_services_outlined;
    if (name.contains("derma")) return Icons.face;
    if (name.contains("eye")) return Icons.remove_red_eye;
    if (name.contains("ortho")) return Icons.accessibility_new;
    if (name.contains("pediatric")) return Icons.child_care;
    if (name.contains("gynae")) return Icons.female;
    if (name.contains("neuro")) return Icons.psychology;
    if (name.contains("ent")) return Icons.hearing;
    if (name.contains("physio")) return Icons.fitness_center;
    if (name.contains("nutrition")) return Icons.apple;
    if (name.contains("nephro")) return Icons.water_drop;
    if (name.contains("onco")) return Icons.science;
    if (name.contains("psych")) return Icons.self_improvement;
    return Icons.medical_services;
  }

  Color _getColor(String category) {
    String name = category.toLowerCase();
    if (name.contains("cardio")) return Colors.red;
    if (name.contains("dentist")) return Colors.cyan;
    if (name.contains("derma")) return Colors.brown;
    if (name.contains("eye")) return Colors.blue;
    if (name.contains("ortho")) return Colors.orange;
    if (name.contains("pediatric")) return Colors.purple;
    if (name.contains("gynae")) return Colors.pink;
    if (name.contains("neuro")) return Colors.deepPurple;
    if (name.contains("ent")) return Colors.teal;
    if (name.contains("physio")) return Colors.green;
    return Colors.indigo;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _userNameFuture,
      builder: (context, userSnapshot) {
        String userName = userSnapshot.data ?? "Prajjwal";

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA), // Light grey background for contrast
          appBar: buildCustomAppBar(context, userName, ResponsiveHelper.getAppBarHeight(context)),
          body: SafeArea(
            child: Column(
              children: [
                // --- 1. SEARCH BAR ---
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterCategories, // Call filter logic on type
                    decoration: InputDecoration(
                      hintText: "Search doctors, specialities...",
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,

                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      // Soft Shadow
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
                      ),
                    ),
                  ),
                ),

                // --- 2. HEADER BANNER ---
                // --- REDESIGNED HEALTHCARE BANNER CARD ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    height: 170, // Fixed height for a prominent banner
                    width: double.infinity,
                    // Clip the content to the rounded corners
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        children: [
                          // --- LAYER 1: Background Image ---
                          // This is the generated image, placed to fill the container.
                          Positioned.fill(
                            child: Image.asset(
                              "lib/images/image_21.png", // Ensure this asset is in your folder
                              fit: BoxFit.cover,
                            ),
                          ),

                          // --- LAYER 2: Gradient Overlay (for blending) ---
                          // This creates a smooth transition from a solid color on the left
                          // to transparent on the right, making the text readable.
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(

                              ),
                            ),
                          ),

                          // --- LAYER 3: Content (Icon & Text) on the Left ---
                          Positioned(
                            left: 20,
                            top: 20,
                            bottom: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // 1. Circular Icon Container
                                // Container(
                                //   padding: const EdgeInsets.all(12),
                                //   decoration: BoxDecoration(
                                //     color: const Color(0xFF0A4A7B), // Dark Blue from the image's theme
                                //     shape: BoxShape.circle,
                                //     boxShadow: [
                                //       BoxShadow(
                                //         color: Colors.blue.withOpacity(0.3),
                                //         blurRadius: 8,
                                //         offset: const Offset(0, 4),
                                //       ),
                                //     ],
                                //   ),
                                //   // Use your existing icon here
                                //   child: Image.asset(
                                //     "lib/images/MEDICARE.png",
                                //     height: 32,
                                //     width: 32,
                                //     color: Colors.white, // Make the icon white for contrast
                                //   ),
                                // ),
                                // const SizedBox(height: 16),
                                //
                                // // 2. "Healthcare" Text
                                // const Text(
                                //   "Healthcare",
                                //   style: TextStyle(
                                //     fontSize: 24,
                                //     fontWeight: FontWeight.w800, // Extra bold for emphasis
                                //     color: Color(0xFF0A4A7B), // Match the icon container color
                                //     letterSpacing: 0.5,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // --- 3. DYNAMIC GRID ---
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _filteredCategories.isEmpty
                      ? const Center(child: Text("No Specialities Found"))
                      : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3.2, // Makes them wide pills
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _filteredCategories.length,
                    itemBuilder: (context, index) {
                      final item = _filteredCategories[index];
                      return FadeInAnimation(
                        delay: index * 50, // Faster animation
                        child: CategoryButton(
                          title: item.category,
                          icon: _getIcon(item.category),
                          color: _getColor(item.category),
                          // Inside HealthcarePage.dart
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoctorDetailsPage(
                                  categoryName: item.category, // e.g. "Cardiology"
                                  categoryId: item.id,         // e.g. 2 (Matches HealthCareSubCategoryId)
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}