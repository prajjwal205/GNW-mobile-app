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
    return FutureBuilder<String>(
      future: UserService.fetchUserName(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.noScaling),
          child: Scaffold(
            appBar: buildCustomAppBar(context, snapshot.data!, 90),
            body: SafeArea(
              child: CustomScrollView(
                slivers: [

                  // ================= SPONSOR + SEARCH =================
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 8),

                        // Sponsor Banner
                        Container(
                          height: 120,
                          width: MediaQuery.of(context).size.width * 0.90,
                          margin:
                          const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "SPONSOR\nBANNER",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Search Bar
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: SizedBox(
                            height: 45,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Search Ayurveda",
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                contentPadding:
                                const EdgeInsets.symmetric(horizontal: 12),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),
                      ],
                    ),
                  ),

                  // ================= GRID =================
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final items = _gridItems(context);
                          return items[index];
                        },
                        childCount: _gridItems(context).length,
                      ),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.9,
                      ),
                    ),
                  ),

                  // ================= DEAL OF THE DAY =================
                  SliverToBoxAdapter(
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "DEAL OF THE DAY",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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

  // ================= GRID ITEMS =================
  List<Widget> _gridItems(BuildContext context) {
    return [
      _gridItem(
        'lib/images/MEDICARE.png',
        'Healthcare',
            () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => HealthcarePage()),
          );
        },
      ),
      _gridItem(
        'lib/images/FOODIE.png',
        'Food',
            () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FoodPage()),
          );
        },
      ),
      _gridItem('lib/images/SHOPPING.png', 'Shopping', _notImplemented),
      _gridItem('lib/images/MAKEOVER.png', 'Makeovers', _notImplemented),
      _gridItem('lib/images/EVENTS.png', 'Events', _notImplemented),
      _gridItem('lib/images/TRAVEL.png', 'Travel', _notImplemented),
      _gridItem('lib/images/HOMECARE_2.png', 'Homecare', _notImplemented),
      _gridItem('lib/images/REAL_ESTATE.png', 'Property', _notImplemented),
      _gridItem('lib/images/ASTROLOGY.png', 'Astrology', _notImplemented),
      _gridItem('lib/images/EDUCATION.png', 'Education', _notImplemented),
      _gridItem('lib/images/FITNESS.png', 'FitLife', _notImplemented),
      _gridItem('lib/images/PETS.png', 'Pets', _notImplemented),
      _gridItem('lib/images/RELOCATION.png', 'Relocation', _notImplemented),
      _gridItem('lib/images/FINANCE.png', 'Finance', _notImplemented),
      _gridItem('lib/images/SECURITY.png', 'Security', _notImplemented),
      _gridItem('lib/images/SERVICES.png', 'Services', _notImplemented),
    ];
  }

  // ================= GRID ITEM WIDGET =================
  Widget _gridItem(String asset, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 60,
            width: 60,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1B2B36),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(asset, fit: BoxFit.contain),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
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
