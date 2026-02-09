import 'package:flutter/material.dart';
import 'package:gnw/Models/category_model.dart'; // Ensure this matches your folder name (Models vs models)
import 'package:gnw/pages/healthcare_page.dart';
import 'package:gnw/pages/client_list_page.dart'; // <--- IMPORT THE NEW PAGE
import 'package:gnw/widget/customAppBar.dart';
import 'package:gnw/services/user_service.dart';
import 'package:gnw/providers/auth_provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<List<CategoryModel>> _categoriesFuture;
  late Future<String> _userNameFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = AuthService.fetchCategories();
    _userNameFuture = AuthService.fetchUserName();
  }

  // --- 1. LOCAL MAPPING LOGIC (Images) ---
  String _getIconForCategory(String apiCategoryName) {
    String name = apiCategoryName.trim().toLowerCase();
    if (name.contains("health")) return 'lib/images/MEDICARE.png';
    if (name.contains("food")) return 'lib/images/FOODIE.png';
    if (name.contains("shopping")) return 'lib/images/SHOPPING.png';
    if (name.contains("makeover")) return 'lib/images/MAKEOVER.png';
    if (name.contains("event")) return 'lib/images/EVENTS.png';
    if (name.contains("travel")) return 'lib/images/TRAVEL.png';
    if (name.contains("homecare")) return 'lib/images/HOMECARE_2.png';
    if (name.contains("property") || name.contains("real estate")) return 'lib/images/REAL_ESTATE.png';
    if (name.contains("astrology")) return 'lib/images/ASTROLOGY.png';
    if (name.contains("education")) return 'lib/images/EDUCATION.png';
    if (name.contains("fit")) return 'lib/images/FITNESS.png';
    if (name.contains("pet")) return 'lib/images/PETS.png';
    if (name.contains("relocation")) return 'lib/images/RELOCATION.png';
    if (name.contains("finance")) return 'lib/images/FINANCE.png';
    if (name.contains("security")) return 'lib/images/SECURITY.png';
    if (name.contains("service")) return 'lib/images/SERVICES.png';
    return 'lib/images/GNW_RED_LOGO.png';
  }

  // --- 2. UPDATED NAVIGATION LOGIC ---
  void _handleNavigation(CategoryModel item, BuildContext context) {
    String name = item.categoryName.trim().toLowerCase();

    if (name.contains("health")) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HealthcarePage())
      );
    } else {
        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ClientListPage(
            categoryId: item.id,         // Pass the ID from API
            categoryName: item.categoryName, // Pass the Name for the Title
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final height = media.size.height;
    final horizontalPadding = width * 0.03;
    final verticalSpacing = height * 0.01;
    final iconBoxSize = width * 0.15;
    final iconPadding = iconBoxSize * 0.2;
    final labelFontSize = (width * 0.030).clamp(11.0, 14.0);
    final bannerFontSize = width * 0.03;

    return FutureBuilder<String>(
      future: UserService.fetchUserName(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
              body: Center(
                  child: CircularProgressIndicator()
              ));
        }

        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: Scaffold(
            appBar: buildCustomAppBar(context, snapshot.data!, 90),
            body: SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // --- TOP BANNER & SEARCH ---
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Column(
                        children: [
                          SizedBox(height: verticalSpacing),
                          AspectRatio(
                            aspectRatio: 16 / 7,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              alignment: Alignment.center,
                              child: Text("SPONSOR\nBANNER",
                                  style: TextStyle(
                                      fontSize: bannerFontSize,
                                      fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                          SizedBox(height: verticalSpacing),
                          SizedBox(
                            height: height * 0.055,
                            child: TextField(
                              style: TextStyle(fontSize: labelFontSize * 1.5),
                              decoration: InputDecoration(
                                hintText: "Search...",
                                prefixIcon: Icon(Icons.search, size: labelFontSize * 2.5),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                                isDense: true,
                              ),
                            ),
                          ),
                          SizedBox(height: verticalSpacing * 1.8),
                        ],
                      ),
                    ),
                  ),

                  // --- DYNAMIC GRID ---
                  FutureBuilder<List<CategoryModel>>(
                    future: _categoriesFuture,
                    builder: (context, categorySnapshot) {
                      if (categorySnapshot.connectionState == ConnectionState.waiting) {
                        return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
                      }
                      if (categorySnapshot.hasError || !categorySnapshot.hasData) {
                        return const SliverToBoxAdapter(child: Center(child: Text("Error loading menu")));
                      }

                      final categories = categorySnapshot.data!;

                      return SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              final item = categories[index];
                              final iconPath = _getIconForCategory(item.categoryName);

                              return _gridItem(
                                iconPath,
                                item.categoryName,
                                iconBoxSize,
                                iconPadding,
                                labelFontSize,
                                // Pass the WHOLE item to navigation
                                    () => _handleNavigation(item, context),
                              );
                            },
                            childCount: categories.length,
                          ),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 23,
                            mainAxisSpacing: 5,
                            childAspectRatio: 0.90,
                          ),
                        ),
                      );
                    },
                  ),

                  // --- BOTTOM BANNER ---
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(horizontalPadding),
                      child: AspectRatio(
                        aspectRatio: 16 / 3,
                        child: Container(
                          decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(12)),
                          alignment: Alignment.center,
                          child: Text("DEAL OF THE DAY", style: TextStyle(fontSize: bannerFontSize, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _gridItem(String asset, String label, double iconSize, double iconPadding, double fontSize, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: iconSize,
            width: iconSize,
            padding: EdgeInsets.all(iconPadding),
            decoration: BoxDecoration(
              color: const Color(0xFF1B2B36),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(asset, fit: BoxFit.contain),
          ),
          SizedBox(height: fontSize * 0.3),
          Flexible(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}