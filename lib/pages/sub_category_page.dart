import 'package:flutter/material.dart';
import 'package:gnw/Models/SubCategoryModel.dart';
import 'package:gnw/services/auth_provider.dart';
import '../widget/Sub_category_card_widget.dart';
import '../widget/customAppBar.dart';
import '../utils/responsive_helper.dart';
import 'other_Listing.dart';

class SubCategoryPage extends StatefulWidget {
  final int categoryMasterId;
  final String categoryName;

  const SubCategoryPage({
    super.key,
    required this.categoryMasterId,
    required this.categoryName,
  });

  @override
  State<SubCategoryPage> createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {

  late Future<String> _userNameFuture;
  // List<SubCategoryModel> _allCategories = [];
  List<SubCategoryModel> _filteredCategories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _userNameFuture = AuthService.fetchUserName();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final list = await AuthService.OtherSubCategory(widget.categoryMasterId);
    if (mounted) {
      setState(() {
        // _allCategories = list;
        _filteredCategories = list;
        _isLoading = false;
      });
    }
  }

  // 🚀 2. _colorPalette yahan se delete kar diya, code chhota ho gaya!

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<String>(
      future: _userNameFuture,
      builder: (context, snapshot) {
        // String userName = snapshot.data ?? "";

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: CustomAppBar(appBarHeight: ResponsiveHelper.getAppBarHeight(context)),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
            slivers: [

              // =======================
              // 🔵 TOP BANNER
              // =======================

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      aspectRatio: 16 / 6,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              "lib/images/premium.jpeg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // =======================
              // 🟢 CATEGORY CARDS
              // =======================

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filteredCategories.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 4,
                      ),
                      itemBuilder: (context, index) {
                        final item = _filteredCategories[index];

                        return CategoryCardWidget(
                          index: index,
                          title: item.categoryName,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ServiceListPage(
                                  subCategoryName: item.categoryName,
                                  subCategoryId: item.id,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}