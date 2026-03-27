//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// // Your Models
// import 'package:gnw/Models/doctor_model.dart';
// import 'package:gnw/Models/category_model.dart';
// import 'package:gnw/Models/healthcare_model.dart';
//
// // Your Pages
// import 'package:gnw/pages/healthcare_page.dart';
// import 'package:gnw/pages/doctor_details_page.dart';
// import 'package:gnw/services/auth_provider.dart';
//
// // ============================================================================
// // PROVIDER: Fetches data for the search dropdown
// // ============================================================================
// final allSearchDataProvider = FutureProvider.autoDispose<Map<String, List<dynamic>>>((ref) async {
//   final results = await Future.wait([
//     AuthService.fetchDoctor(),
//     AuthService.fetchCategories(),
//     AuthService.fetchHealthcareCategories(),
//   ]);
//
//   return {
//     "doctors": results[0] as List<DoctorModel>,
//     "categories": results[1] as List<CategoryModel>,
//     "healthcare": results[2] as List<HealthcareCategoryModel>,
//   };
// });
//
//
// class FloatingSearchWidget extends ConsumerWidget {
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
//   Widget build(BuildContext context, WidgetRef ref) {
//
//     // Keep the data alive and ready
//     final searchDataAsync = ref.watch(allSearchDataProvider);
//
//     // 🚀 NEW: Responsive multiplier to make sizes perfect on all screens
//     final wScale = screenWidth / 390.0;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Autocomplete<Object>(
//
//       displayStringForOption: (Object option) {
//         return ''; // Keeps text box visually clean after selection
//       },
//
//       // 1. FILTERING LOGIC
//       optionsBuilder: (TextEditingValue textEditingValue) {
//         if (textEditingValue.text.isEmpty) {
//           return const Iterable<Object>.empty();
//         }
//
//         final query = textEditingValue.text.toLowerCase();
//         final data = searchDataAsync.value;
//
//         if (data == null) return const Iterable<Object>.empty();
//
//         final doctors = (data["doctors"] as List<DoctorModel>).where((doc) {
//           final nameStr = doc.name.toLowerCase();
//           final qualStr = doc.qualification.toLowerCase();
//           final addressStr = doc.address.toLowerCase();
//
//           return nameStr.contains(query) || qualStr.contains(query) || addressStr.contains(query);
//         }).toList();
//
//         final healthcare = (data["healthcare"] as List<HealthcareCategoryModel>).where((hCat) {
//           final catStr = hCat.category.toLowerCase();
//           return catStr.contains(query);
//         }).toList();
//
//         final combinedResults = [...healthcare, ...doctors];
//         return combinedResults.take(2);
//       },
//
//       // 2. WHAT HAPPENS WHEN THEY TAP A SUGGESTION
//       onSelected: (Object option) {
//         // 🚀 NEW: Clean up everything after search!
//         ref.invalidate(allSearchDataProvider); // Wipes the search history/cache
//         FocusManager.instance.primaryFocus?.unfocus(); // Drops the keyboard immediately
//
//         if (option is HealthcareCategoryModel) {
//           Navigator.push(
//               context, MaterialPageRoute(builder: (_) => DoctorListPage(
//               categoryName: option.category, categoryId: option.id)));
//         } else if (option is DoctorModel) {
//           Navigator.push(context, MaterialPageRoute(
//             builder: (_) => DoctorListPage(
//               categoryId: option.categoryIds.isNotEmpty ? option.categoryIds.first : 0,
//               categoryName: option.name,
//             ),
//           ));
//         }
//       },
//
//       // 3. THE VISUAL LOOK OF THE SEARCH BOX
//       fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
//         return AnimatedBuilder(
//             animation: focusNode,
//             builder: (context, child) {
//               return SizedBox(
//                 height: 44 * wScale, // 🚀 Reduced height and made responsive
//                 child: TextField(
//                   controller: textEditingController,
//                   focusNode: focusNode,
//                   style: TextStyle(fontSize: 16 * wScale, fontWeight: FontWeight.bold, color: Colors.black), // 🚀 Scaled down font
//                   decoration: InputDecoration(
//                     contentPadding: const EdgeInsets.symmetric(vertical: 0),
//
//                     prefixIcon: Padding(
//                       padding: EdgeInsets.only(left: 14.0 * wScale, right: 8.0 * wScale),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(Icons.search, color: Colors.black87, size: 22 * wScale), // 🚀 Scaled down icon
//                           SizedBox(width: 6 * wScale),
//                           Text(
//                             "Search",
//                             style: TextStyle(fontSize: 16 * wScale, color: Colors.grey.shade600, fontWeight: FontWeight.w600), // 🚀 Scaled down font
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(25 * wScale), borderSide: const BorderSide(color: Colors.black87)),
//                     enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25 * wScale), borderSide: const BorderSide(color: Colors.black87)),
//                     focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25 * wScale), borderSide: const BorderSide(color: Colors.black, width: 1.5)),
//                     filled: true,
//                     fillColor: Colors.white,
//                   ),
//                 ),
//               );
//             }
//         );
//       },
//
//       // 4. THE VISUAL LOOK OF THE FLOATING DROPDOWN MENU
//       optionsViewBuilder: (context, onSelected, options) {
//         return Align(
//           alignment: Alignment.topLeft,
//           child: Material(
//             color: Colors.white,
//             elevation: 8.0,
//             borderRadius: BorderRadius.circular(16 * wScale),
//             child: ConstrainedBox(
//               constraints: BoxConstraints(
//                 // 🚀 NEW: Ensures the suggestion card never gets too tall
//                 maxHeight: screenHeight * 0.35,
//                 maxWidth: screenWidth - (horizontalPadding * 2),
//               ),
//               child: ListView.builder(
//                 // 🚀 NEW: Reduced padding to make the card more compact
//                 padding: EdgeInsets.symmetric(vertical: 0 * wScale),
//                 shrinkWrap: true,
//                 itemCount: options.length,
//                 itemBuilder: (context, index) {
//                   final option = options.elementAt(index);
//
//                   if (option is HealthcareCategoryModel) {
//                     return ListTile(
//                       dense: true, // 🚀 NEW: Makes the ListTile row thinner
//                       contentPadding: EdgeInsets.symmetric(horizontal: 16 * wScale, vertical: 0),
//                       title: Text(
//                           option.category,
//                           maxLines: 1, // 🚀 NEW: 2-Line Problem Fixed!
//                           overflow: TextOverflow.ellipsis, // 🚀 Adds "..." at the end
//                           style: TextStyle(fontSize: 14 * wScale, fontWeight: FontWeight.w500) // 🚀 Responsive Font
//                       ),
//                       onTap: () => onSelected(option),
//                     );
//                   } else if (option is DoctorModel) {
//                     return ListTile(
//                       dense: true, // 🚀 NEW: Makes the ListTile row thinner
//                       contentPadding: EdgeInsets.symmetric(horizontal: 16 * wScale, vertical: 0),
//                       title: Text(
//                           option.name,
//                           maxLines: 1, // 🚀 NEW: 2-Line Problem Fixed!
//                           overflow: TextOverflow.ellipsis, // 🚀 Adds "..." at the end
//                           style: TextStyle(fontSize: 14 * wScale, fontWeight: FontWeight.w500) // 🚀 Responsive Font
//                       ),
//                       onTap: () => onSelected(option),
//                     );
//                   }
//                   return const SizedBox();
//                 },
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
//







//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// // Your Models
// import 'package:gnw/Models/doctor_model.dart';
// import 'package:gnw/Models/category_model.dart';
// import 'package:gnw/Models/healthcare_model.dart';
//
// // Your Pages
// import 'package:gnw/pages/healthcare_page.dart';
// import 'package:gnw/pages/doctor_details_page.dart';
// import 'package:gnw/services/auth_provider.dart';
//
// // ============================================================================
// // PROVIDER: Fetches data for the search dropdown
// // ============================================================================
// final allSearchDataProvider = FutureProvider.autoDispose<Map<String, List<dynamic>>>((ref) async {
//   final results = await Future.wait([
//     AuthService.fetchDoctor(),
//     AuthService.fetchCategories(),
//     AuthService.fetchHealthcareCategories(),
//   ]);
//
//   return {
//     "doctors": results[0] as List<DoctorModel>,
//     "categories": results[1] as List<CategoryModel>,
//     "healthcare": results[2] as List<HealthcareCategoryModel>,
//   };
// });
//
// // 🚀 Changed to Stateful so we can track the 1 top suggestion dynamically
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
//   // 🚀 This holds our single top result to display on the right side
//   Object? _topSuggestion;
//
//   // 1. FILTERING LOGIC (Runs every time a letter is typed)
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
//
//     final combinedResults = [...healthcare, ...doctors];
//
//     setState(() {
//       // 🚀 Take ONLY the very first match, or set to null if nothing matches
//       _topSuggestion = combinedResults.isNotEmpty ? combinedResults.first : null;
//     });
//   }
//
//   // 2. NAVIGATION & CLEANUP (Runs when the suggestion on the right is tapped)
//   void _handleSuggestionTap() {
//     if (_topSuggestion == null) return;
//
//     final option = _topSuggestion;
//
//     // 🚀 Navigate First
//     if (option is HealthcareCategoryModel) {
//       Navigator.push(context, MaterialPageRoute(
//           builder: (_) => DoctorListPage(categoryName: option.category, categoryId: option.id)
//       ));
//     } else if (option is DoctorModel) {
//       Navigator.push(context, MaterialPageRoute(
//           builder: (_) => DoctorListPage(
//             categoryId: option.categoryIds.isNotEmpty ? option.categoryIds.first : 0,
//             categoryName: option.name,
//           )
//       ));
//     }
//
//     // 🚀 Cleanup exactly 100ms later to prevent context crash
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
//     // Keep data alive
//     ref.watch(allSearchDataProvider);
//
//     final wScale = widget.screenWidth / 390.0;
//
//     // Helper to extract the name from our Object
//     String getSuggestionName() {
//       if (_topSuggestion is HealthcareCategoryModel) {
//         return (_topSuggestion as HealthcareCategoryModel).category;
//       } else if (_topSuggestion is DoctorModel) {
//         return (_topSuggestion as DoctorModel).name;
//       }
//       return '';
//     }
//
//     return AnimatedBuilder(
//         animation: _focusNode,
//         builder: (context, child) {
//           return SizedBox(
//             height: 44 * wScale,
//             child: TextField(
//               controller: _searchController,
//               focusNode: _focusNode,
//               style: TextStyle(fontSize: 16 * wScale, fontWeight: FontWeight.bold, color: Colors.black),
//               onChanged: _findTopSuggestion, // 🚀 Trigger search on typing
//
//               decoration: InputDecoration(
//                 contentPadding: const EdgeInsets.symmetric(vertical: 0),
//
//                 // LEFT SIDE: Static "Search" Icon & Text
//                 prefixIcon: Padding(
//                   padding: EdgeInsets.only(left: 14.0 * wScale, right: 8.0 * wScale),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(Icons.search, color: Colors.black87, size: 22 * wScale),
//                       SizedBox(width: 6 * wScale),
//                       Text(
//                         "Search",
//                         style: TextStyle(fontSize: 16 * wScale, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // ==============================================================
//                 // 🚀 RIGHT SIDE: THE INLINE SUGGESTION
//                 // ==============================================================
//
//                 suffixIcon: _topSuggestion != null
//                     ? Container(
//                   // Restrict width so a massive hospital name doesn't overlap typed text
//                   constraints: BoxConstraints(maxWidth: widget.screenWidth * 0.50),
//                   alignment: Alignment.centerRight,
//                   padding: EdgeInsets.only(right: 14.0 * wScale),
//                   child: GestureDetector(
//                     onTap: _handleSuggestionTap, // Tapping it triggers navigation
//                     child: Text(
//                       getSuggestionName(),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         fontSize: 14 * wScale,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blue.shade500, // Make it blue so user knows to tap it
//                       ),
//                     ),
//                   ),
//                 )
//                     : const SizedBox.shrink(), // Show nothing if no match
//
//                 // Normal Rounded Borders (No flat edges since there's no dropdown anymore!)
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(25 * wScale), borderSide: const BorderSide(color: Colors.black87)),
//                 enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25 * wScale), borderSide: const BorderSide(color: Colors.black87)),
//                 focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25 * wScale), borderSide: const BorderSide(color: Colors.black, width: 1.5)),
//                 filled: true,
//                 fillColor: Colors.white,
//               ),
//             ),
//           );
//         }
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Your Models
import 'package:gnw/Models/doctor_model.dart';
import 'package:gnw/Models/category_model.dart';
import 'package:gnw/Models/healthcare_model.dart';

// Your Pages
import 'package:gnw/pages/healthcare_page.dart';
import 'package:gnw/pages/doctor_details_page.dart';
import 'package:gnw/services/auth_provider.dart';

// ============================================================================
// PROVIDER: Fetches data for the search dropdown
// ============================================================================
final allSearchDataProvider = FutureProvider.autoDispose<Map<String, List<dynamic>>>((ref) async {
  final results = await Future.wait([
    AuthService.fetchDoctor(),
    AuthService.fetchCategories(),
    AuthService.fetchHealthcareCategories(),
  ]);

  return {
    "doctors": results[0] as List<DoctorModel>,
    "categories": results[1] as List<CategoryModel>,
    "healthcare": results[2] as List<HealthcareCategoryModel>,
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

  // 1. FILTERING LOGIC
  void _findTopSuggestion(String query) {
    if (query.isEmpty) {
      setState(() => _topSuggestion = null);
      return;
    }

    final queryLower = query.toLowerCase();
    final data = ref.read(allSearchDataProvider).value;

    if (data == null) return;

    final doctors = (data["doctors"] as List<DoctorModel>).where((doc) {
      return doc.name.toLowerCase().contains(queryLower) ||
          doc.qualification.toLowerCase().contains(queryLower) ||
          doc.address.toLowerCase().contains(queryLower);
    }).toList();

    final healthcare = (data["healthcare"] as List<HealthcareCategoryModel>).where((hCat) {
      return hCat.category.toLowerCase().contains(queryLower);
    }).toList();

    final combinedResults = [...healthcare, ...doctors];

    setState(() {
      _topSuggestion = combinedResults.isNotEmpty ? combinedResults.first : null;
    });
  }

  // 2. NAVIGATION & CLEANUP
  void _handleSuggestionTap() {
    if (_topSuggestion == null) return;

    final option = _topSuggestion;

    if (option is HealthcareCategoryModel) {
      Navigator.push(context, MaterialPageRoute(
          builder: (_) => DoctorListPage(categoryName: option.category, categoryId: option.id)
      ));

    } else if (option is DoctorModel) {
      Navigator.push(context, MaterialPageRoute(
          builder: (_) => Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(option.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 40),
                // 🚀 This uses your EXACT existing UI block from doctor_details_page.dart!
                child: DoctorDetailBlock(doctor: option),
              ),
            ),
          )
      ));
    }
    // } else if (option is DoctorModel) {
    //   Navigator.push(context, MaterialPageRoute(
    //       builder: (_) => DoctorListPage(
    //         categoryId: option.categoryIds.isNotEmpty ? option.categoryIds.first : 0,
    //         categoryName: option.name,
    //       )
    //   ));
    // }

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _searchController.clear();
        setState(() => _topSuggestion = null);
        _focusNode.unfocus();
        ref.invalidate(allSearchDataProvider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(allSearchDataProvider);

    final wScale = widget.screenWidth / 390.0;

    // Restricts the suggestion length to exactly 12 characters!
    String getSuggestionName() {
      String name = '';
      if (_topSuggestion is HealthcareCategoryModel) {
        name = (_topSuggestion as HealthcareCategoryModel).category;
      } else if (_topSuggestion is DoctorModel) {
        name = (_topSuggestion as DoctorModel).name;
      }

      if (name.isEmpty) return '';

      if (name.length > 25) {
        return '${name.substring(0, 25)}...';
      }
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

                // =======================================================
                // 1. THE STATIC PREFIX (Search Icon + Text)
                // =======================================================
                SizedBox(width: 14 * wScale),
                Icon(Icons.search, color: Colors.black87, size: 22 * wScale),
                SizedBox(width: 6 * wScale),
                Text("Search", style: TextStyle(fontSize: 16 * wScale, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
                SizedBox(width: 8 * wScale),

                // =======================================================
                // 2. THE TEXT AREA (Stacking the elements correctly!)
                // =======================================================
                Expanded(
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [

                      // 🚀 LAYER 1 (BOTTOM): THE REAL TEXT FIELD
                      // Since it's on the bottom, it won't block the blue text from being clicked.
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

                      // 🚀 LAYER 2 (TOP): THE GHOST TEXT & CLICKABLE SUGGESTION
                      if ( _searchController.text.isNotEmpty)
                        Row(
                          children: [

                            // A. INVISIBLE TYPED TEXT
                            // IgnorePointer ensures if you tap here, it passes the tap down to the TextField so you can keep typing.
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

                            // B. THE VISIBLE BLUE SUGGESTION
                            // Since this is on TOP of the Stack, it will successfully catch your taps!
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
                                  : Container( // 🚀 SHOWS RED "NO RESULTS" IF TOP SUGGESTION IS NULL
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