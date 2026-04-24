//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gnw/Models/client_model.dart';
// import 'package:gnw/Models/doctor_model.dart';
// import 'package:gnw/Models/category_model.dart';
// import 'package:gnw/Models/healthcare_model.dart';
// import 'package:gnw/pages/healthcare_page.dart';
// import 'package:gnw/pages/doctor_details_page.dart';
// import 'package:gnw/services/auth_provider.dart';
//
// import '../Models/SubCategoryModel.dart';
// import '../pages/other_Listing.dart';
// import '../utils/responsive_helper.dart';
// import 'customAppBar.dart';
//
// final allSearchDataProvider = FutureProvider.autoDispose<Map<String, List<dynamic>>>((ref) async {
//   final results = await Future.wait([
//     AuthService.fetchDoctor(),
//     AuthService.fetchCategories(),
//     AuthService.fetchHealthcareCategories(),
//     AuthService.fetchAllClients(),
//   ]);
//
//   return {
//     "doctors": results[0] as List<DoctorModel>,
//     "categories": results[1] as List<CategoryModel>,
//     "healthcare": results[2] as List<HealthcareCategoryModel>,
//     "clients": results[3] as List<ClientModel>
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
//   // 1. FILTERING LOGIC
//   void _findTopSuggestion(String query) {
//     if (query.isEmpty) {
//       setState(() => _topSuggestion = null);
//       return;
//     }
//
//     final queryLower = query.toLowerCase();
//     final data = ref.read(allSearchDataProvider).value;
//
//     if (data == null) return;
//
//     final doctors = (data["doctors"] as List<DoctorModel>).where((doc) {
//       return doc.name.toLowerCase().contains(queryLower) ||
//           doc.qualification.toLowerCase().contains(queryLower) ||
//           doc.address.toLowerCase().contains(queryLower);
//     }).toList();
//
//     final healthcare = (data["healthcare"] as List<HealthcareCategoryModel>).where((hCat) {
//       return hCat.category.toLowerCase().contains(queryLower);
//     }).toList();
//     final categories = (data["categories"] as List<CategoryModel>).where((cat) {
//       return cat.categoryName.toLowerCase().contains(queryLower);
//     }).toList();
//
//     List<ClientModel> clients = [];
//
//     if(data.containsKey("clients")) {
//       clients = (data["clients"] as List<ClientModel>).where((client) {
//         return client.clientName.toLowerCase().contains(queryLower) ||
//             client.address.toLowerCase().contains(queryLower) ||
//             client.highlights.toLowerCase().contains(queryLower);
//       }).toList();
//     }
//
//     final combinedResults = [...healthcare, ...doctors, ...categories, ...clients, ];
//
//     setState(() {
//       _topSuggestion = combinedResults.isNotEmpty ? combinedResults.first : null;
//     });
//   }
//
//   // 2. NAVIGATION & CLEANUP
//   void _handleSuggestionTap() {
//     if (_topSuggestion == null) return;
//
//     final option = _topSuggestion;
//
//     if (option is HealthcareCategoryModel) {
//       Navigator.push(context, MaterialPageRoute(
//           builder: (_) => DoctorListPage(categoryName: option.category, categoryId: option.id)
//       ));
//
//     } else if (option is DoctorModel) {
//       Navigator.push(context, MaterialPageRoute(
//           builder: (_) => Scaffold(
//             backgroundColor: Colors.white,
//             appBar: CustomAppBar(
//                 appBarHeight: ResponsiveHelper.getAppBarHeight(context)),
//             body: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 10, bottom: 40),
//                 child: DoctorDetailBlock(
//                   doctor: option,
//                   index: 0,
//                   totalCount: 1,
//                   pageController: PageController(),
//                 ),              ),
//             ),
//           )
//       ));
//     }
//
//     else if (option is ClientModel) {
//       Navigator.push(context, MaterialPageRoute(
//           builder: (_) =>
//               Scaffold(
//                 backgroundColor: Colors.white,
//                 appBar: CustomAppBar(
//                     appBarHeight: ResponsiveHelper.getAppBarHeight(context)),
//                 body: SingleChildScrollView(
//                   physics: const BouncingScrollPhysics(),
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 10, bottom: 40),
//                     child: ServiceDetailBlock(
//                       clientName: option,
//                       index: 1,
//                       totalCount: 1,
//                       pageController: PageController(),
//                     ),
//                   ),
//                 ),
//               )
//       ));
//     }
//     // } else if (option is DoctorModel) {
//     //   Navigator.push(context, MaterialPageRoute(
//     //       builder: (_) => DoctorListPage(
//     //         categoryId: option.categoryIds.isNotEmpty ? option.categoryIds.first : 0,
//     //         categoryName: option.name,
//     //       )
//     //   ));
//     // }
//
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (mounted) {
//         _searchController.clear();
//         setState(() => _topSuggestion = null);
//         _focusNode.unfocus();
//         ref.invalidate(allSearchDataProvider);
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
//     // Restricts the suggestion length to exactly 12 characters!
//     String getSuggestionName() {
//       String name = '';
//       if (_topSuggestion is HealthcareCategoryModel) {
//         name = (_topSuggestion as HealthcareCategoryModel).category;
//       } else if (_topSuggestion is DoctorModel) {
//         name = (_topSuggestion as DoctorModel).name;
//       }
//       else if(_topSuggestion is ClientModel){
//         name = (_topSuggestion as ClientModel).clientName;
//       }
//       else if (_topSuggestion is SubCategoryModel){
//         name = (_topSuggestion as SubCategoryModel).categoryName;
//       }
//
//       if (name.isEmpty) return '';
//
//       if (name.length > 25) {
//         return '${name.substring(0, 25)}...';
//       }
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
//
//                 // =======================================================
//                 // 1. THE STATIC PREFIX (Search Icon + Text)
//                 // =======================================================
//                 SizedBox(width: 14 * wScale),
//                 Icon(Icons.search, color: Colors.black87, size: 22 * wScale),
//                 SizedBox(width: 6 * wScale),
//                 Text("Search", style: TextStyle(fontSize: 16 * wScale, color: Colors.grey.shade900, fontWeight: FontWeight.w900)),
//                 SizedBox(width: 8 * wScale),
//
//                 // =======================================================
//                 // 2. THE TEXT AREA (Stacking the elements correctly!)
//                 // =======================================================
//                 Expanded(
//                   child: Stack(
//                     alignment: Alignment.centerLeft,
//                     children: [
//
//                       // 🚀 LAYER 1 (BOTTOM): THE REAL TEXT FIELD
//                       // Since it's on the bottom, it won't block the blue text from being clicked.
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
//
//                       // 🚀 LAYER 2 (TOP): THE GHOST TEXT & CLICKABLE SUGGESTION
//                       if ( _searchController.text.isNotEmpty)
//                         Row(
//                           children: [
//
//                             // A. INVISIBLE TYPED TEXT
//                             // IgnorePointer ensures if you tap here, it passes the tap down to the TextField so you can keep typing.
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
//
//                             // B. THE VISIBLE BLUE SUGGESTION
//                             // Since this is on TOP of the Stack, it will successfully catch your taps!
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
//                                   : Container( // 🚀 SHOWS RED "NO RESULTS" IF TOP SUGGESTION IS NULL
//                                 padding: EdgeInsets.only(left: 6 * wScale, top: 10 * wScale, bottom: 10 * wScale),
//                                 child: Text(
//                                   "  No Listing available yet",
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(fontSize: 14 * wScale, fontWeight: FontWeight.w600, color: Colors.red.shade400),
//                                 ),
//                               ),
//                             ),
//
//                           ],
//                         ),
//
//                     ],
//                   ),
//                 ),
//
//               ],
//             ),
//           );
//         }
//     );
//   }
// }


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
      return c.clientName.toLowerCase().contains(queryLower) ||
          c.highlights.toLowerCase().contains(queryLower);
    }).toList();

    // Filter Doctors
    final doctors = (data["doctors"] as List<DoctorModel>).where((doc) {
      return doc.name.toLowerCase().contains(queryLower) ||
          doc.address.toLowerCase().contains(queryLower);
    }).toList();

    // Filter Healthcare Categories
    final healthcare = (data["healthcare"] as List<HealthcareCategoryModel>).where((hCat) {
      return hCat.category.toLowerCase().contains(queryLower);
    }).toList();

    // Combine all results prioritizing SubCategories and Clients first
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
                  clientName: option, // Ensure 'ServiceDetailBlock' in other_Listing.dart expects 'clientName'
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
    // Trigger data fetch silently
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
                Text("Search", style: TextStyle(fontSize: 16 * wScale, color: Colors.grey.shade900, fontWeight: FontWeight.w900)),
                SizedBox(width: 8 * wScale),
                Expanded(
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        style: TextStyle(fontSize: 16 * wScale, fontWeight: FontWeight.bold, color: Colors.black),
                        onChanged: _findTopSuggestion,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                      ),
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