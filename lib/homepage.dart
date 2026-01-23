import 'package:flutter/material.dart';
import 'package:gnw/pages/healthcare_page.dart';
import 'package:gnw/pages/food_page.dart';
import 'package:gnw/widget/customAppBar.dart';
import 'package:gnw/services/user_service.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final height = media.size.height;

    // ========= RESPONSIVE SCALES =========
    final horizontalPadding = width * 0.03;
    final verticalSpacing = height * 0.01;

    final sponsorHeight = height * 0.12;
    final searchHeight = height * 0.055;

    final iconBoxSize = width * 0.15;
    final iconPadding = iconBoxSize * 0.2;

    final labelFontSize = (width * 0.035).clamp(11.0, 14.0);
    final bannerFontSize = width * 0.03;

    return FutureBuilder<String>(
      future: UserService.fetchUserName(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: buildCustomAppBar(context, snapshot.data!, 90),
          body: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ================= SPONSOR + SEARCH =================
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      children: [
                        SizedBox(height: verticalSpacing),

                        // Sponsor Banner
                        Container(
                          height: sponsorHeight *1.5,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "SPONSOR\nBANNER",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: bannerFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        SizedBox(height: verticalSpacing),

                        // Search Bar
                        SizedBox(
                          height: searchHeight,
                          child: TextField(
                            style:
                            TextStyle(fontSize: labelFontSize*1.5),
                            decoration: InputDecoration(
                              hintText: "Search Ayurveda",
                              prefixIcon: Icon(
                                Icons.search,
                                size: labelFontSize * 2.5,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              isDense: true,
                            ),
                          ),
                        ),

                        SizedBox(height: verticalSpacing*1.8),
                      ],
                    ),
                  ),
                ),

                // ================= CATEGORY GRID =================
                SliverPadding(
                  padding:
                  EdgeInsets.symmetric(horizontal: horizontalPadding),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) => _gridItems(
                        context,
                        iconBoxSize,
                        iconPadding,
                        labelFontSize,
                      )[index],
                      childCount: _gridItems(
                        context,
                        iconBoxSize,
                        iconPadding,
                        labelFontSize,
                      ).length,
                    ),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,          // ✅ ALWAYS 4
                      crossAxisSpacing: 23, // helps to decrese the size between icons
                      mainAxisSpacing: .01,
                      childAspectRatio: 0.75,     // ✅ responsive height
                    ),
                  ),
                ),

                // ================= DEAL =================
                SliverToBoxAdapter(
                  child: Container(
                    height: height * 0.07,
                    margin: EdgeInsets.all(horizontalPadding),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "DEAL OF THE DAY",
                      style: TextStyle(
                        fontSize: bannerFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================= GRID ITEMS =================
  List<Widget> _gridItems(
      BuildContext context,
      double iconSize,
      double iconPadding,
      double fontSize,
      ) {
    return [
      _gridItem('lib/images/MEDICARE.png', 'Healthcare', iconSize,
          iconPadding, fontSize, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => HealthcarePage()),
            );
          }),
      _gridItem('lib/images/FOODIE.png', 'Food', iconSize, iconPadding,
          fontSize, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FoodPage()),
            );
          }),
      _gridItem('lib/images/SHOPPING.png', 'Shopping', iconSize,
          iconPadding, fontSize, _notImplemented),
      _gridItem('lib/images/MAKEOVER.png', 'Makeovers', iconSize,
          iconPadding, fontSize, _notImplemented),
      _gridItem('lib/images/EVENTS.png', 'Events', iconSize,
          iconPadding, fontSize, _notImplemented),
      _gridItem('lib/images/TRAVEL.png', 'Travel', iconSize,
          iconPadding, fontSize, _notImplemented),
      _gridItem('lib/images/HOMECARE_2.png', 'Homecare', iconSize,
          iconPadding, fontSize, _notImplemented),
      _gridItem('lib/images/REAL_ESTATE.png', 'Property', iconSize,
          iconPadding, fontSize, _notImplemented),
      _gridItem('lib/images/ASTROLOGY.png', 'Astrology', iconSize,
          iconPadding, fontSize, _notImplemented),
      _gridItem('lib/images/EDUCATION.png', 'Education', iconSize,
          iconPadding, fontSize, _notImplemented),
      _gridItem('lib/images/FITNESS.png', 'FitLife', iconSize,
          iconPadding, fontSize, _notImplemented),
      _gridItem('lib/images/PETS.png', 'Pets', iconSize,
          iconPadding, fontSize, _notImplemented),
      _gridItem('lib/images/RELOCATION.png', 'Relocation', iconSize,
          iconPadding, fontSize, _notImplemented),
      _gridItem('lib/images/FINANCE.png', 'Finance', iconSize,
          iconPadding, fontSize, _notImplemented),
      _gridItem('lib/images/SECURITY.png', 'Security', iconSize,
          iconPadding, fontSize, _notImplemented),
      _gridItem('lib/images/SERVICES.png', 'Services', iconSize,
          iconPadding, fontSize, _notImplemented),
    ];
  }

  // ================= GRID ITEM =================
  Widget _gridItem(
      String asset,
      String label,
      double iconSize,
      double iconPadding,
      double fontSize,
      VoidCallback onTap,
      ) {
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _notImplemented() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Page not implemented')),
    );
  }
}
