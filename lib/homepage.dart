import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnw/Models/category_model.dart';
import 'package:gnw/pages/healthcare_page.dart';
import 'package:gnw/pages/sub_category_page.dart';
import 'package:gnw/services/auth_provider.dart';
import 'package:gnw/utils/SucessButton.dart';
import 'package:gnw/utils/responsive_helper.dart';
import 'package:gnw/widget/customAppBar.dart';
import 'package:gnw/widget/floating_search_widget.dart';
import 'package:gnw/widget/sponsor_banner_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_signup page/login.dart'; // Make sure the path matches where you saved it!

final userNameProvider = FutureProvider.autoDispose<String>((ref) async {
  return await AuthService.fetchUserName();
});

// Fetches the Categories List
final categoriesProvider = FutureProvider.autoDispose<List<CategoryModel>>((ref) async {
  return await AuthService.fetchCategories();

});

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}
class _HomepageState extends ConsumerState<Homepage> {

  Future<void> _refreshData() async {
    // 1. Invalidate providers to force a reload
    ref.invalidate(userNameProvider);
    ref.invalidate(categoriesProvider);
    try {
      await Future.wait([
        ref.read(userNameProvider.future),
        ref.read(categoriesProvider.future),
      ]);
    } catch (e) {
      debugPrint("Refresh failed: $e");
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // it will delete all user

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

  // --- ICON MAPPING LOGIC ---
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

  // --- NAVIGATION LOGIC ---
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
          builder: (_) => SubCategoryPage(
            categoryMasterId: item.id,
            categoryName: item.categoryName,
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
    // final bannerFontSize = width * 0.03;

    // --- WATCHING DATA FROM PROVIDERS ---
    // final userAsync = ref.watch(userNameProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    double wScale = ResponsiveHelper.screenWidth(context) / 390.0;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),

      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(appBarHeight: ResponsiveHelper.getAppBarHeight(context)),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refreshData,
            color: Colors.white,
            backgroundColor: const Color(0xFF1B2B36), // GNW Dark Blue

            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                // --- TOP BANNER & SEARCH ---
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      children: [
                        SizedBox(height: verticalSpacing),
                        const SponsorBannerWidget(
                          bannerType: "TOP BANNER",
                          aspectRatio: 16 / 6,
                          scrollSeconds: 6,
                        ),
                        SizedBox(height: verticalSpacing),
                        // Search
                        FloatingSearchWidget(
                          screenWidth: width,
                          horizontalPadding: horizontalPadding,
                        ),
                        SizedBox(height: verticalSpacing * 1.8),
                      ],
                    ),
                  ),
                ),

                // Inside Homepage.dart -> build() -> slivers: [ ... ]

                categoriesAsync.when(
                  // 1. SUCCESS CASE (Data loaded)
                  data: (categories) {
                    if (categories.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                              children: [
                                Icon(Icons.category_outlined, size: 60, color: Colors.grey.shade400),
                                const SizedBox(height: 16),
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
                                    icon: Icon(Icons.logout_outlined, size: 16 * wScale),
                                    label: Text(
                                      'Logout or Refresh',
                                      style: TextStyle(fontSize: 12 * wScale, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                // TextButton(
                                //   onPressed: _refreshData,
                                //   child: const Text("Tap to Refresh"),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

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
                                  () => _handleNavigation(item, context),
                            );
                          },
                          childCount: categories.length,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: (width * 0.04).clamp(10.0, 18.0),
                          mainAxisSpacing: (height * 0.012).clamp(6.0, 12.0),
                          childAspectRatio: width < 360 ? 0.85 : 0.90,
                        ),


                      ),
                    );
                  },

                  // 2. LOADING CASE
                  loading: () => const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),

                  // 3. ERROR CASE (This is where the actual error shows)
                  error: (error, stackTrace) => SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red, size: 40),
                            const SizedBox(height: 10),

                            // 🛑 DISPLAY THE ACTUAL ERROR HERE
                            Text(
                              "Error Details:\n$error",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 15),
                            ElevatedButton(
                              onPressed: _refreshData,
                              child: const Text("Retry"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // --- BOTTOM BANNER ---
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding,
                    bottom: horizontalPadding,
                      top: 0,
                    ),
                    child:const SponsorBannerWidget(
                      bannerType: "LOWER BANNER",
                      aspectRatio: 16 / 3,
                      scrollSeconds: 7, // 🚀 7 seconds ka time
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- GRID ITEM WIDGET ---
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
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}