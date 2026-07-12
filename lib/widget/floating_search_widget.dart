//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gnw/Models/client_model.dart';
// import 'package:gnw/Models/doctor_model.dart';
// import 'package:gnw/Models/category_model.dart';
// import 'package:gnw/Models/healthcare_model.dart';
// import 'package:gnw/Models/SubCategoryModel.dart';
// import 'package:gnw/pages/doctor_details_page.dart';
// import 'package:gnw/pages/other_Listing.dart';
// import 'package:gnw/services/auth_provider.dart';
//
// import '../utils/responsive_helper.dart';
// import 'customAppBar.dart';
//
// // 1. PROVIDER: Fetches all data simultaneously
// final allSearchDataProvider = FutureProvider.autoDispose<Map<String, List<dynamic>>>((ref) async {
//   final results = await Future.wait([
//     AuthService.fetchDoctor(),
//     AuthService.fetchCategories(),
//     AuthService.fetchHealthcareCategories(),
//     AuthService.fetchAllClients(),
//     AuthService.fetchAllSubCategories(),
//   ]);
//
//   return {
//     "doctors": results[0] as List<DoctorModel>,
//     "categories": results[1] as List<CategoryModel>,
//     "healthcare": results[2] as List<HealthcareCategoryModel>,
//     "clients": results[3] as List<ClientModel>,
//     "subCategories": results[4] as List<SubCategoryModel>,
//   };
// });
//
// class FloatingSearchWidget extends ConsumerStatefulWidget {
//   final double screenWidth;
//   final double horizontalPadding;
//
//   const FloatingSearchWidget({
//     super.key,
//     required this.screenWidth,
//     required this.horizontalPadding,
//   });
//
//   @override
//   ConsumerState<FloatingSearchWidget> createState() => _FloatingSearchWidgetState();
// }
//
// class _FloatingSearchWidgetState extends ConsumerState<FloatingSearchWidget> {
//
//   final TextEditingController _searchController = TextEditingController();
//   final FocusNode _focusNode = FocusNode();
//
//   Object? _topSuggestion;
//
//   // 2. FILTERING LOGIC
//   void _findTopSuggestion(String query) {
//     if (query.isEmpty) {
//       setState(() => _topSuggestion = null);
//       return;
//     }
//
//     final queryLower = query.toLowerCase();
//     final data = ref.read(allSearchDataProvider).value;
//     if (data == null) return;
//
//     // Filter Sub-Categories
//     final subCats = (data["subCategories"] as List<SubCategoryModel>).where((sc) {
//       return sc.categoryName.toLowerCase().contains(queryLower);
//     }).toList();
//
//     // 🚀 Filter Clients (Yahan query matching ke sath .isValid ka check thoka hai)
//     final clients = (data["clients"] as List<ClientModel>).where((c) {
//       final matchesQuery = c.clientName.toLowerCase().contains(queryLower) ||
//           c.highlights.toLowerCase().contains(queryLower);
//       return matchesQuery && c.isValid; // 👈 Expired client block!
//     }).toList();
//
//     // 🚀 Filter Doctors (Yahan query matching ke sath .isValid ka check thoka hai)
//     final doctors = (data["doctors"] as List<DoctorModel>).where((doc) {
//       final matchesQuery = doc.name.toLowerCase().contains(queryLower) ||
//           doc.address.toLowerCase().contains(queryLower);
//       return matchesQuery && doc.isValid; // 👈 Expired doctor block!
//     }).toList();
//
//     // Filter Healthcare Categories
//     final healthcare = (data["healthcare"] as List<HealthcareCategoryModel>).where((hCat) {
//       return hCat.category.toLowerCase().contains(queryLower);
//     }).toList();
//
//     // Combine all results prioritizing SubCategories and Clients first
//     final combinedResults = [...subCats, ...clients, ...healthcare, ...doctors];
//
//     setState(() {
//       _topSuggestion = combinedResults.isNotEmpty ? combinedResults.first : null;
//     });
//   }
//
//   // 3. NAVIGATION LOGIC
//   void _handleSuggestionTap() {
//     if (_topSuggestion == null) return;
//     final option = _topSuggestion;
//
//     if (option is SubCategoryModel) {
//       Navigator.push(context, MaterialPageRoute(
//           builder: (_) => ServiceListPage(
//               subCategoryName: option.categoryName,
//               subCategoryId: option.id
//           )
//       ));
//     } else if (option is ClientModel) {
//       Navigator.push(context, MaterialPageRoute(
//           builder: (_) => Scaffold(
//             backgroundColor: Colors.white,
//             appBar: CustomAppBar(appBarHeight: ResponsiveHelper.getAppBarHeight(context)),
//             body: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 10, bottom: 40),
//                 child: ServiceDetailBlock(
//                   clientName: option,
//                   index: 0,
//                   totalCount: 1,
//                   pageController: PageController(),
//                 ),
//               ),
//             ),
//           )
//       ));
//     } else if (option is HealthcareCategoryModel) {
//       Navigator.push(context, MaterialPageRoute(
//           builder: (_) => DoctorListPage(categoryName: option.category, categoryId: option.id)
//       ));
//     } else if (option is DoctorModel) {
//       Navigator.push(context, MaterialPageRoute(
//           builder: (_) => Scaffold(
//             backgroundColor: Colors.white,
//             appBar: CustomAppBar(appBarHeight: ResponsiveHelper.getAppBarHeight(context)),
//             body: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 10, bottom: 40),
//                 child: DoctorDetailBlock(
//                   doctor: option,
//                   index: 0,
//                   totalCount: 1,
//                   pageController: PageController(),
//                 ),
//               ),
//             ),
//           )
//       ));
//     }
//
//     // Cleanup after navigation
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (mounted) {
//         _searchController.clear();
//         setState(() => _topSuggestion = null);
//         _focusNode.unfocus();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     ref.watch(allSearchDataProvider);
//
//     final wScale = widget.screenWidth / 390.0;
//
//     String getSuggestionName() {
//       String name = '';
//       if (_topSuggestion is SubCategoryModel) {
//         name = (_topSuggestion as SubCategoryModel).categoryName;
//       } else if (_topSuggestion is ClientModel) {
//         name = (_topSuggestion as ClientModel).clientName;
//       } else if (_topSuggestion is HealthcareCategoryModel) {
//         name = (_topSuggestion as HealthcareCategoryModel).category;
//       } else if (_topSuggestion is DoctorModel) {
//         name = (_topSuggestion as DoctorModel).name;
//       }
//
//       if (name.isEmpty) return '';
//       if (name.length > 25) return '${name.substring(0, 25)}...';
//       return name;
//     }
//
//     return AnimatedBuilder(
//         animation: _focusNode,
//         builder: (context, child) {
//           return Container(
//             height: 46 * wScale,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(25 * wScale),
//               border: Border.all(
//                 color: _focusNode.hasFocus ? Colors.black : Colors.black87,
//                 width: _focusNode.hasFocus ? 1.5 : 1.0,
//               ),
//             ),
//             child: Row(
//               children: [
//                 SizedBox(width: 14 * wScale),
//                 Icon(Icons.search, color: Colors.black87, size: 22 * wScale),
//                 SizedBox(width: 6 * wScale),
//                 Text("Search", style: TextStyle(fontSize: 16 * wScale, color: Colors.grey.shade900, fontWeight: FontWeight.w900)),
//                 SizedBox(width: 8 * wScale),
//                 Expanded(
//                   child: Stack(
//                     alignment: Alignment.centerLeft,
//                     children: [
//                       TextField(
//                         controller: _searchController,
//                         focusNode: _focusNode,
//                         style: TextStyle(fontSize: 16 * wScale, fontWeight: FontWeight.bold, color: Colors.black),
//                         onChanged: _findTopSuggestion,
//                         decoration: const InputDecoration(
//                           border: InputBorder.none,
//                           enabledBorder: InputBorder.none,
//                           focusedBorder: InputBorder.none,
//                           contentPadding: EdgeInsets.zero,
//                           isDense: true,
//                         ),
//                       ),
//                       if (_searchController.text.isNotEmpty)
//                         Row(
//                           children: [
//                             IgnorePointer(
//                               child: Text(
//                                 _searchController.text,
//                                 style: TextStyle(
//                                   fontSize: 16 * wScale,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.transparent,
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: _topSuggestion != null
//                                   ? GestureDetector(
//                                 onTap: _handleSuggestionTap,
//                                 child: Container(
//                                   color: Colors.transparent,
//                                   padding: EdgeInsets.only(left: 6 * wScale, right: 16 * wScale, top: 10 * wScale, bottom: 10 * wScale),
//                                   child: Text(
//                                     getSuggestionName(),
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(fontSize: 15 * wScale, fontWeight: FontWeight.bold, color: Colors.blue.shade600),
//                                   ),
//                                 ),
//                               )
//                                   : Container(
//                                 padding: EdgeInsets.only(left: 6 * wScale, top: 10 * wScale, bottom: 10 * wScale),
//                                 child: Text(
//                                   "  No Listing available yet",
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(fontSize: 14 * wScale, fontWeight: FontWeight.w600, color: Colors.red.shade400),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//     );
//   }
// }



import 'dart:async'; // 👈 Timer ke liye add kiya gaya
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnw/Models/client_model.dart';
import 'package:gnw/Models/doctor_model.dart';
import 'package:gnw/Models/category_model.dart';
import 'package:gnw/Models/healthcare_model.dart';
import 'package:gnw/Models/SubCategoryModel.dart';
import 'package:gnw/pages/doctor_details_page.dart';
import 'package:gnw/pages/other_Listing.dart';
import 'package:gnw/services/auth_provider.dart';

import '../utils/responsive_helper.dart';
import 'customAppBar.dart';

// 1. PROVIDER: Fetches all data simultaneously
final allSearchDataProvider = FutureProvider.autoDispose<Map<String, List<dynamic>>>((ref) async {
  final results = await Future.wait([
    AuthService.fetchDoctor(),
    AuthService.fetchCategories(),
    AuthService.fetchHealthcareCategories(),
    AuthService.fetchAllClients(),
    AuthService.fetchAllSubCategories(),
  ]);

  return {
    "doctors": results[0] as List<DoctorModel>,
    "categories": results[1] as List<CategoryModel>,
    "healthcare": results[2] as List<HealthcareCategoryModel>,
    "clients": results[3] as List<ClientModel>,
    "subCategories": results[4] as List<SubCategoryModel>,
  };
});

class FloatingSearchWidget extends ConsumerStatefulWidget {
  final double screenWidth;
  final double horizontalPadding;

  const FloatingSearchWidget({
    super.key,
    required this.screenWidth,
    required this.horizontalPadding,
  });

  @override
  ConsumerState<FloatingSearchWidget> createState() => _FloatingSearchWidgetState();
}

class _FloatingSearchWidgetState extends ConsumerState<FloatingSearchWidget> {

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Object? _topSuggestion;

  // 🚀 ANIMATION VARIABLES
  final List<String> _animatedHints = ['doctors...', 'food...', 'pets...', 'hospitals...', 'clinics...'];
  int _hintIndex = 0;
  int _charIndex = 0;
  String _currentHint = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTypingAnimation();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Memory leak se bachne ke liye
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // 🚀 TYPEWRITER LOGIC
  void _startTypingAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      // Agar user kuch type kar raha hai, toh animation rok do
      if (_searchController.text.isNotEmpty) {
        return;
      }

      final targetWord = _animatedHints[_hintIndex];

      if (_charIndex < targetWord.length) {
        if (mounted) {
          setState(() {
            _charIndex++;
            _currentHint = targetWord.substring(0, _charIndex);
          });
        }
      } else {
        // Word poora type hone ke baad thoda wait karein
        timer.cancel();
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _charIndex = 0;
              _currentHint = '';
              _hintIndex = (_hintIndex + 1) % _animatedHints.length;
            });
            _startTypingAnimation(); // Agle word ke liye loop restart
          }
        });
      }
    });
  }

  // 2. FILTERING LOGIC
  void _findTopSuggestion(String query) {
    if (query.isEmpty) {
      setState(() => _topSuggestion = null);
      return;
    }

    final queryLower = query.toLowerCase();
    final data = ref.read(allSearchDataProvider).value;
    if (data == null) return;

    // Filter Sub-Categories
    final subCats = (data["subCategories"] as List<SubCategoryModel>).where((sc) {
      return sc.categoryName.toLowerCase().contains(queryLower);
    }).toList();

    // Filter Clients
    final clients = (data["clients"] as List<ClientModel>).where((c) {
      final matchesQuery = c.clientName.toLowerCase().contains(queryLower) ||
          c.highlights.toLowerCase().contains(queryLower);
      return matchesQuery && c.isValid;
    }).toList();

    // Filter Doctors
    final doctors = (data["doctors"] as List<DoctorModel>).where((doc) {
      final matchesQuery = doc.name.toLowerCase().contains(queryLower) ||
          doc.address.toLowerCase().contains(queryLower);
      return matchesQuery && doc.isValid;
    }).toList();

    // Filter Healthcare Categories
    final healthcare = (data["healthcare"] as List<HealthcareCategoryModel>).where((hCat) {
      return hCat.category.toLowerCase().contains(queryLower);
    }).toList();

    // Combine all results
    final combinedResults = [...subCats, ...clients, ...healthcare, ...doctors];

    setState(() {
      _topSuggestion = combinedResults.isNotEmpty ? combinedResults.first : null;
    });
  }

  // 3. NAVIGATION LOGIC
  void _handleSuggestionTap() {
    if (_topSuggestion == null) return;
    final option = _topSuggestion;

    if (option is SubCategoryModel) {
      Navigator.push(context, MaterialPageRoute(
          builder: (_) => ServiceListPage(
              subCategoryName: option.categoryName,
              subCategoryId: option.id
          )
      ));
    } else if (option is ClientModel) {
      Navigator.push(context, MaterialPageRoute(
          builder: (_) => Scaffold(
            backgroundColor: Colors.white,
            appBar: CustomAppBar(appBarHeight: ResponsiveHelper.getAppBarHeight(context)),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 40),
                child: ServiceDetailBlock(
                  clientName: option,
                  index: 0,
                  totalCount: 1,
                  pageController: PageController(),
                ),
              ),
            ),
          )
      ));
    } else if (option is HealthcareCategoryModel) {
      Navigator.push(context, MaterialPageRoute(
          builder: (_) => DoctorListPage(categoryName: option.category, categoryId: option.id)
      ));
    } else if (option is DoctorModel) {
      Navigator.push(context, MaterialPageRoute(
          builder: (_) => Scaffold(
            backgroundColor: Colors.white,
            appBar: CustomAppBar(appBarHeight: ResponsiveHelper.getAppBarHeight(context)),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 40),
                child: DoctorDetailBlock(
                  doctor: option,
                  index: 0,
                  totalCount: 1,
                  pageController: PageController(),
                ),
              ),
            ),
          )
      ));
    }

    // Cleanup after navigation
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _searchController.clear();
        setState(() => _topSuggestion = null);
        _focusNode.unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(allSearchDataProvider);

    final wScale = widget.screenWidth / 390.0;

    String getSuggestionName() {
      String name = '';
      if (_topSuggestion is SubCategoryModel) {
        name = (_topSuggestion as SubCategoryModel).categoryName;
      } else if (_topSuggestion is ClientModel) {
        name = (_topSuggestion as ClientModel).clientName;
      } else if (_topSuggestion is HealthcareCategoryModel) {
        name = (_topSuggestion as HealthcareCategoryModel).category;
      } else if (_topSuggestion is DoctorModel) {
        name = (_topSuggestion as DoctorModel).name;
      }

      if (name.isEmpty) return '';
      if (name.length > 25) return '${name.substring(0, 25)}...';
      return name;
    }

    return AnimatedBuilder(
        animation: _focusNode,
        builder: (context, child) {
          return Container(
            height: 46 * wScale,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25 * wScale),
              border: Border.all(
                color: _focusNode.hasFocus ? Colors.black : Colors.black87,
                width: _focusNode.hasFocus ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              children: [
                SizedBox(width: 14 * wScale),
                Icon(Icons.search, color: Colors.black87, size: 22 * wScale),
                SizedBox(width: 6 * wScale),
                // Static "Search" Text
                Text("Search ", style: TextStyle(fontSize: 16 * wScale, color: Colors.grey.shade900, fontWeight: FontWeight.w900)),

                Expanded(
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        style: TextStyle(fontSize: 16 * wScale, fontWeight: FontWeight.bold, color: Colors.black),
                        onChanged: _findTopSuggestion,
                        decoration: InputDecoration(
                          hintText: _currentHint, // 🚀 ANIMATED TEXT YAHAN BIND HUA HAI
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500, // Hint ka color thoda light rakha hai
                            fontWeight: FontWeight.w600,
                            fontSize: 16 * wScale,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                      ),

                      // Dropdown Suggestions Logic
                      if (_searchController.text.isNotEmpty)
                        Row(
                          children: [
                            IgnorePointer(
                              child: Text(
                                _searchController.text,
                                style: TextStyle(
                                  fontSize: 16 * wScale,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                            Expanded(
                              child: _topSuggestion != null
                                  ? GestureDetector(
                                onTap: _handleSuggestionTap,
                                child: Container(
                                  color: Colors.transparent,
                                  padding: EdgeInsets.only(left: 6 * wScale, right: 16 * wScale, top: 10 * wScale, bottom: 10 * wScale),
                                  child: Text(
                                    getSuggestionName(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 15 * wScale, fontWeight: FontWeight.bold, color: Colors.blue.shade600),
                                  ),
                                ),
                              )
                                  : Container(
                                padding: EdgeInsets.only(left: 6 * wScale, top: 10 * wScale, bottom: 10 * wScale),
                                child: Text(
                                  "  No Listing available yet",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 14 * wScale, fontWeight: FontWeight.w600, color: Colors.red.shade400),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}