import 'package:flutter/material.dart';
import 'package:gnw/Models/healthcare_model.dart';
import 'package:gnw/pages/doctor_details_page.dart';
import 'package:gnw/services/auth_provider.dart';
import '../widget/customAppBar.dart';
import '../utils/responsive_helper.dart';

class HealthcarePage extends StatefulWidget {
  const HealthcarePage({super.key});

  @override
  State<HealthcarePage> createState() => _HealthcarePageState();
}

class _HealthcarePageState extends State<HealthcarePage> {

  late Future<String> _userNameFuture;
  List<HealthcareCategoryModel> _allCategories = [];
  List<HealthcareCategoryModel> _filteredCategories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _userNameFuture = AuthService.fetchUserName();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final list = await AuthService.fetchHealthcareCategories();
    if (mounted) {
      setState(() {
        _allCategories = list;
        _filteredCategories = list;
        _isLoading = false;
      });
    }
  }

  List<List<HealthcareCategoryModel>> _chunkList(
      List<HealthcareCategoryModel> list, int chunkSize) {
    List<List<HealthcareCategoryModel>> chunks = [];
    for (int i = 0; i < list.length; i += chunkSize) {
      chunks.add(
        list.sublist(
          i,
          i + chunkSize > list.length ? list.length : i + chunkSize,
        ),
      );
    }
    return chunks;
  }

  final List<Color> _colorPalette = [
    Colors.red.shade200,
    Colors.blue.shade200,
    Colors.green.shade200,
    Colors.orange.shade200,
    Colors.purple.shade200,
    Colors.teal.shade200,
    Colors.pink.shade200,
    Colors.indigo.shade200,
    Colors.cyan.shade400,
    Colors.deepOrange.shade400,
    Colors.amber.shade200,
    Colors.lightBlue.shade200,
    Colors.lightGreen.shade200,
    Colors.brown.shade400,
    Colors.blueGrey.shade400,
    Colors.deepPurple.shade400,
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<String>(
      future: _userNameFuture,
      builder: (context, snapshot) {

        String userName = snapshot.data ?? "";

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: buildCustomAppBar(
            context,
            userName,
            ResponsiveHelper.getAppBarHeight(context),
          ),
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
                              "lib/images/image_21.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            left: 20,
                            top: 20,
                            child: Text(
                              "Find Your Specialist",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                (screenWidth * 0.05).clamp(16, 22),
                                fontWeight: FontWeight.bold,
                              ),
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
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 4,
                      ),
                      itemBuilder: (context, index) {
                        final item = _filteredCategories[index];

                        return InkWell(
                          borderRadius: BorderRadius.circular(40),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoctorListPage(
                                  categoryName: item.category,
                                  categoryId: item.id,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                color: _colorPalette[index % _colorPalette.length],
                                width: 2,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            child: Text(
                              item.category,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.03,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),


              // SliverList(
              //   delegate: SliverChildBuilderDelegate(
              //         (context, cardIndex) {
              //
              //       final chunkedList =
              //       _chunkList(_filteredCategories, 16);
              //       final currentChunk =
              //       chunkedList[cardIndex];
              //
              //       return Container(
              //         margin: const EdgeInsets.symmetric(
              //             horizontal: 16, vertical: 10),
              //         padding: const EdgeInsets.all(16),
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(20),
              //
              //           boxShadow: const [
              //             BoxShadow(
              //               color: Colors.black,
              //               blurRadius: 8,
              //               offset: Offset(0, 4),
              //             )
              //           ],
              //         ),
              //         child: GridView.builder(
              //           shrinkWrap: true,
              //           physics:
              //           const NeverScrollableScrollPhysics(),
              //           itemCount: currentChunk.length,
              //           gridDelegate:
              //           const SliverGridDelegateWithFixedCrossAxisCount(
              //             crossAxisCount: 2,
              //             crossAxisSpacing: 12,
              //             mainAxisSpacing: 12,
              //             childAspectRatio: 4,
              //           ),
              //           itemBuilder: (context, index) {
              //
              //             final item =
              //             currentChunk[index];
              //
              //             return InkWell(
              //               borderRadius: BorderRadius.circular(40),
              //               onTap: () {
              //                 Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                     builder: (context) => DoctorDetailsPage(
              //                       categoryName: item.category,
              //                       categoryId: item.id,
              //                     ),
              //                   ),
              //                 );
              //               },
              //               child: Container(
              //                 alignment: Alignment.center,
              //                 decoration: BoxDecoration(
              //                   color: Colors.white,
              //                   borderRadius: BorderRadius.circular(40),
              //                   border: Border.all(
              //                     color: _colorPalette[index % _colorPalette.length], // ✅ Colorful border
              //                     width: 2,
              //                   ),
              //
              //                 ),
              //                 padding: const EdgeInsets.symmetric(
              //                   horizontal: 14,
              //                   vertical: 6, // 🔥 very small vertical padding
              //                 ),
              //                 child: Text(
              //                   item.category,
              //                   textAlign: TextAlign.center,
              //                   style: TextStyle(
              //                     fontSize: (MediaQuery.of(context).size.width * 0.030)
              //                         ,
              //                     fontWeight: FontWeight.w700,
              //                     color: Colors.black,
              //                   ),
              //                   maxLines: 1,
              //                   overflow: TextOverflow.ellipsis,
              //                 ),
              //               ),
              //             );
              //           },
              //         ),
              //       );
              //     },
              //     childCount:
              //     _chunkList(_filteredCategories, 16)
              //         .length,
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}