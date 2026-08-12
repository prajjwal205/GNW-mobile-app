import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/search_provider.dart';
import '../utils/search_helper.dart';
import '../widget/search_dropdown_items.dart';

import '../Models/client_model.dart';
import '../Models/doctor_model.dart';
import '../Models/healthcare_model.dart';
import '../Models/SubCategoryModel.dart';
import '../pages/doctor_details_page.dart';
import '../pages/other_Listing.dart';
import '../utils/responsive_helper.dart';
import 'customAppBar.dart';

class FloatingSearchWidget extends ConsumerStatefulWidget {
  final double screenWidth;
  final double horizontalPadding;
  const FloatingSearchWidget({super.key, required this.screenWidth, required this.horizontalPadding});
  @override
  ConsumerState<FloatingSearchWidget> createState() => _FloatingSearchWidgetState();
}

class _FloatingSearchWidgetState extends ConsumerState<FloatingSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Object> _suggestions = [];

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  SubCategoryModel? _expandedSubCategory;
  HealthcareCategoryModel? _expandedHealthCategory;

  final List<String> _animatedHints = ['Doctors ', 'Food', 'Pets', 'Hospitals', 'Clinics', 'Shopping', 'Education','Homecare'];
  int _hintIndex = 0;
  int _charIndex = 0;
  String _currentHint = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTypingAnimation();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) _hideOverlay();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _hideOverlay();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startTypingAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (_searchController.text.isNotEmpty) return;
      final targetWord = _animatedHints[_hintIndex];
      if (_charIndex < targetWord.length) {
        if (mounted) {
          setState(() {
            _charIndex++;
            _currentHint = targetWord.substring(0, _charIndex);
          });
        }
      } else {
        timer.cancel();
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _charIndex = 0;
              _currentHint = '';
              _hintIndex = (_hintIndex + 1) % _animatedHints.length;
            });
            _startTypingAnimation();
          }
        });
      }
    });
  }

  void _showOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _findTopSuggestion(String query) {
    final queryLower = query.toLowerCase().trim();

    if (queryLower.isEmpty) {
      setState(() => _suggestions = []);
      _hideOverlay();
      return;
    }

    final data = ref.read(allSearchDataProvider).value;
    if (data == null) return;

    // 🚀 SearchHelper use ho raha hai!
    final subCats = (data["subCategories"] as List<SubCategoryModel>).where((sc) => SearchHelper.isMatch(sc.categoryName, queryLower)).toList();
    final clients = (data["clients"] as List<ClientModel>).where((c) => SearchHelper.isMatch(c.clientName, queryLower) && c.isValid).toList();
    final doctors = (data["doctors"] as List<DoctorModel>).where((doc) => SearchHelper.isMatch(doc.name, queryLower) && doc.isValid).toList();
    final healthcare = (data["healthcare"] as List<HealthcareCategoryModel>).where((hCat) => SearchHelper.isMatch(hCat.category, queryLower)).toList();

    final combinedResults = [...subCats, ...clients, ...healthcare, ...doctors];

    setState(() {
      _suggestions = combinedResults.take(6).toList();
    });

    if (_searchController.text.isNotEmpty && _focusNode.hasFocus) {
      _showOverlay();
    }
  }



  void _handleSuggestionTap(Object option) {
    _hideOverlay();

    // ==========================================
    // 🚀 1. AGAR DROPDOWN KE ANDAR SE CLICK HUA HAI
    // (Toh hum wahi list use karenge jo dropdown se aayi hai)
    // ==========================================
    if (option is Map && option["isFromDropdown"] == true) {
      final item = option["item"];
      final filteredList = option["list"]; // Ye already us subcategory ke items hain

      if (item is ClientModel) {
        final list = filteredList as List<ClientModel>;
        int initialIndex = list.indexOf(item);
        if (initialIndex == -1) initialIndex = 0;

        final pageController = PageController(initialPage: initialIndex);
        Navigator.push(context, MaterialPageRoute(builder: (_) => Scaffold(
            backgroundColor: Colors.white,
            appBar: CustomAppBar(appBarHeight: ResponsiveHelper.getAppBarHeight(context)),
            body: PageView.builder(
              controller: pageController,
              itemCount: list.length, // List length wahi hogi jo dropdown me thi
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 40),
                        child: ServiceDetailBlock(
                            clientName: list[index],
                            index: index,
                            totalCount: list.length,
                            pageController: pageController
                        )
                    )
                );
              },
            )
        )));
      }
      else if (item is DoctorModel) {
        final list = filteredList as List<DoctorModel>;
        int initialIndex = list.indexOf(item);
        if (initialIndex == -1) initialIndex = 0;

        final pageController = PageController(initialPage: initialIndex);
        Navigator.push(context, MaterialPageRoute(builder: (_) => Scaffold(
            backgroundColor: Colors.white,
            appBar: CustomAppBar(appBarHeight: ResponsiveHelper.getAppBarHeight(context)),
            body: PageView.builder(
              controller: pageController,
              itemCount: list.length, // List length wahi hogi jo dropdown me thi
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 40),
                        child: DoctorDetailBlock(
                            doctor: list[index],
                            index: index,
                            totalCount: list.length,
                            pageController: pageController
                        )
                    )
                );
              },
            )
        )));
      }
    }

    // ==========================================
    // 🚀 2. AGAR CATEGORY (HEADER) PAR CLICK HUA HAI
    // ==========================================
    else if (option is SubCategoryModel) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => ServiceListPage(subCategoryName: option.categoryName, subCategoryId: option.id)));
    }
    else if (option is HealthcareCategoryModel) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => DoctorListPage(categoryName: option.category, categoryId: option.id)));
    }

    // ==========================================
    // 🚀 3. AGAR DIRECT SEARCH BAR SE NAAM PAR CLICK HUA HAI
    // (Toh sirf 1 hi item khulega, slider nahi aayega)
    // ==========================================
    else if (option is ClientModel) {
      final pageController = PageController(initialPage: 0);
      Navigator.push(context, MaterialPageRoute(builder: (_) => Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(appBarHeight: ResponsiveHelper.getAppBarHeight(context)),
          body: PageView.builder(
            controller: pageController,
            itemCount: 1, // Hamesha sirf 1 dikhayega
            itemBuilder: (context, index) {
              return SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 40),
                      child: ServiceDetailBlock(
                          clientName: option,
                          index: 0,
                          totalCount: 1,
                          pageController: pageController
                      )
                  )
              );
            },
          )
      )));
    }
    else if (option is DoctorModel) {
      final pageController = PageController(initialPage: 0);
      Navigator.push(context, MaterialPageRoute(builder: (_) => Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(appBarHeight: ResponsiveHelper.getAppBarHeight(context)),
          body: PageView.builder(
            controller: pageController,
            itemCount: 1, // Hamesha sirf 1 dikhayega
            itemBuilder: (context, index) {
              return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 40),
                      child: DoctorDetailBlock(
                          doctor: option,
                          index: 0,
                          totalCount: 1,
                          pageController: pageController
                      )
                  )
              );
            },
          )
      )));
    }

    // Search bar clear karne ke liye
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _searchController.clear();
        setState(() => _suggestions = []);
        _focusNode.unfocus();
      }
    });
  }

  // void _handleSuggestionTap(Object option) {
  //   _hideOverlay();
  //
  //   final data = ref.read(allSearchDataProvider).value;
  //
  //   if (option is SubCategoryModel) {
  //     Navigator.push(context, MaterialPageRoute(builder: (_) => ServiceListPage(subCategoryName: option.categoryName, subCategoryId: option.id)));
  //   }
  //
  //   else if (option is ClientModel) {
  //     // 1. Get the raw list
  //     final rawClients = data?["clients"] as List<ClientModel>? ?? [option];
  //
  //     // 2. Filter the list to only include clients matching the tapped client's subcategory
  //     // IMPORTANT: Replace 'subCategoryId' with the actual variable name in your ClientModel
  //     final filteredClients = rawClients.where((client) {
  //       // This checks if the client shares AT LEAST ONE subcategory ID with the tapped option
  //       return client.subCategoryIds.any((id) => option.subCategoryIds.contains(id));
  //     }).toList();
  //
  //     // 3. Find the index inside the FILTERED list
  //     int initialIndex = filteredClients.indexOf(option);
  //     if (initialIndex == -1) initialIndex = 0;
  //
  //     final pageController = PageController(initialPage: initialIndex);
  //
  //     Navigator.push(context, MaterialPageRoute(builder: (_) => Scaffold(
  //         backgroundColor: Colors.white,
  //         appBar: CustomAppBar(appBarHeight: ResponsiveHelper.getAppBarHeight(context)),
  //         body: PageView.builder(
  //           controller: pageController,
  //           itemCount: filteredClients.length, // Use the filtered length
  //           itemBuilder: (context, index) {
  //             return SingleChildScrollView(
  //                 child: Padding(
  //                     padding: const EdgeInsets.only(top: 10, bottom: 40),
  //                     child: ServiceDetailBlock(
  //                         clientName: filteredClients[index], // Pass the filtered item
  //                         index: index,
  //                         totalCount: filteredClients.length, // Use the filtered total count
  //                         pageController: pageController
  //                     )
  //                 )
  //             );
  //           },
  //         )
  //     )));
  //   }
  //
  //   else if (option is HealthcareCategoryModel) {
  //     Navigator.push(context, MaterialPageRoute(builder: (_) => DoctorListPage(categoryName: option.category, categoryId: option.id)));
  //   }
  //
  //   else if (option is DoctorModel) {
  //     // 1. Get the raw list
  //     final rawDoctors = data?["doctors"] as List<DoctorModel>? ?? [option];
  //
  //     // 2. Filter the list to only include doctors matching the tapped doctor's category
  //     // IMPORTANT: Replace 'categoryId' with the actual variable name in your DoctorModel
  //     final filteredDoctors = rawDoctors.where((doc) {
  //       // This checks if the doctor shares AT LEAST ONE category ID with the tapped option
  //       return doc.categoryIds.any((id) => option.categoryIds.contains(id));
  //     }).toList();
  //
  //     // 3. Find the index inside the FILTERED list
  //     int initialIndex = filteredDoctors.indexOf(option);
  //     if (initialIndex == -1) initialIndex = 0;
  //
  //     final pageController = PageController(initialPage: initialIndex);
  //
  //     Navigator.push(context, MaterialPageRoute(builder: (_) => Scaffold(
  //         backgroundColor: Colors.white,
  //         appBar: CustomAppBar(appBarHeight: ResponsiveHelper.getAppBarHeight(context)),
  //         body: PageView.builder(
  //           controller: pageController,
  //           itemCount: filteredDoctors.length, // Use the filtered length
  //           itemBuilder: (context, index) {
  //             return SingleChildScrollView(
  //                 physics: const BouncingScrollPhysics(),
  //                 child: Padding(
  //                     padding: const EdgeInsets.only(top: 10, bottom: 40),
  //                     child: DoctorDetailBlock(
  //                         doctor: filteredDoctors[index], // Pass the filtered item
  //                         index: index,
  //                         totalCount: filteredDoctors.length, // Use the filtered total count
  //                         pageController: pageController
  //                     )
  //                 )
  //             );
  //           },
  //         )
  //     )));
  //   }
  //
  //   Future.delayed(const Duration(milliseconds: 100), () {
  //     if (mounted) {
  //       _searchController.clear();
  //       setState(() => _suggestions = []);
  //       _focusNode.unfocus();
  //     }
  //   });
  // }
  OverlayEntry _createOverlayEntry() {
    final wScale = widget.screenWidth / 390.0;
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: 240 * wScale,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(size.width - (240 * wScale), 52 * wScale),
          child: Material(
            elevation: 8,
            color: Colors.white,
            shadowColor: Colors.black26,
            borderRadius: BorderRadius.circular(16 * wScale),
            child: _suggestions.isNotEmpty
                ? ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
              child: ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 8 * wScale),
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: _suggestions.length,
                separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade100),
                itemBuilder: (context, index) {
                  final option = _suggestions[index];

                  if (option is SubCategoryModel) {
                    final isExpanded = _expandedSubCategory?.id == option.id;
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            _expandedSubCategory = isExpanded ? null : option;
                            _expandedHealthCategory = null;
                            _overlayEntry?.markNeedsBuild();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14 * wScale, vertical: 12 * wScale),
                            child: Row(
                              children: [
                                Icon(Icons.category, size: 16 * wScale, color: Colors.orange),
                                SizedBox(width: 8 * wScale),
                                Expanded(
                                  child: Text(option.categoryName,
                                      maxLines: 1, overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 14 * wScale,
                                          fontWeight: FontWeight.bold, color: Colors.blue.shade700)),
                                ),
                                Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 18 * wScale, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                        // 🚀 Bahar ki file se Widget call ho raha hai!
                        if (isExpanded) SubCategoryClientsList(subCategory: option, wScale: wScale, onTap: _handleSuggestionTap),
                      ],
                    );
                  }

                  if (option is HealthcareCategoryModel) {
                    final isExpanded = _expandedHealthCategory?.id == option.id;
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            _expandedHealthCategory = isExpanded ? null : option;
                            _expandedSubCategory = null;
                            _overlayEntry?.markNeedsBuild();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14 * wScale, vertical: 12 * wScale),
                            child: Row(
                              children: [
                                // Icon(Icons.medical_services_outlined, size: 16 * wScale, color: Colors.redAccent),
                                SizedBox(width: 8 * wScale),
                                Expanded(
                                  child: Text(option.category, maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 14 * wScale,
                                          fontWeight: FontWeight.bold, color: Colors.blue.shade700)),
                                ),
                                Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 18 * wScale, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                        // 🚀 Bahar ki file se Widget call ho raha hai!
                        if (isExpanded) HealthcareDoctorsList(healthCat: option, wScale: wScale, onTap: _handleSuggestionTap),
                      ],
                    );
                  }

                  return InkWell(
                    onTap: () => _handleSuggestionTap(option),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14 * wScale, vertical: 12 * wScale),
                      child: Row(
                        children: [
                          SizedBox(width: 8 * wScale),
                          Expanded(
                            // 🚀 SearchHelper use ho raha hai!
                            child: Text(SearchHelper.getSuggestionName(option), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14 * wScale, fontWeight: FontWeight.w600, color: Colors.black87)),
                          ),
                          Icon(Icons.arrow_forward_ios, size: 12 * wScale, color: Colors.grey.shade300),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
                : Padding(
              padding: EdgeInsets.all(16 * wScale),
              child: Text("No Listing available yet", style: TextStyle(fontSize: 13 * wScale, fontWeight: FontWeight.w600, color: Colors.red.shade400)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(allSearchDataProvider);
    final wScale = widget.screenWidth / 390.0;

    return AnimatedBuilder(
        animation: _focusNode,
        builder: (context, child) {
          return CompositedTransformTarget(
            link: _layerLink,
            child: Container(
              height: 46 * wScale,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25 * wScale),
                border: Border.all(color: _focusNode.hasFocus ? Colors.black : Colors.black87, width: _focusNode.hasFocus ? 1.5 : 1.0),
              ),
              child: Row(
                children: [
                  SizedBox(width: 14 * wScale),
                  Icon(Icons.search, color: Colors.black87, size: 22 * wScale),
                  SizedBox(width: 6 * wScale),
                  Text("Search ", style: TextStyle(fontSize: 16 * wScale, color: Colors.grey.shade900, fontWeight: FontWeight.w900)),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      style: TextStyle(fontSize: 16 * wScale, fontWeight: FontWeight.bold, color: Colors.black),
                      onChanged: _findTopSuggestion,
                      decoration: InputDecoration(
                        hintText: _currentHint,
                        hintStyle: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w600, fontSize: 16 * wScale),
                        border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: 2 * wScale),
                        isDense: true,
                      ),
                    ),
                  ),
                  SizedBox(width: 14 * wScale),
                ],
              ),
            ),
          );
        }
    );
  }
}