import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gnw/services/auth_provider.dart';

// Import your models and pages
import 'package:gnw/Models/doctor_model.dart';
import 'package:gnw/Models/category_model.dart';
import 'package:gnw/Models/healthcare_model.dart';
import 'package:gnw/pages/client_list_page.dart';
import 'package:gnw/pages/healthcare_page.dart';

import 'doctor_details_page.dart';

// ============================================================================
// 1. PROVIDERS FOR LIVE SEARCH
// ============================================================================

// Holds the current text typed in the search bar
final searchQueryProvider = StateProvider.autoDispose<String>((ref) => "");

// Fetches ALL data exactly ONCE when the search page opens to prevent server spam
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


// ============================================================================
// 2. LIVE SEARCH UI PAGE
// ============================================================================
class LiveSearchPage extends ConsumerWidget {
  const LiveSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the typed query and the data
    final query = ref.watch(searchQueryProvider).toLowerCase();
    final dataAsync = ref.watch(allSearchDataProvider);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: Colors.white,

        // --- LINKEDIN STYLE APP BAR ---
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          iconTheme: const IconThemeData(color: Colors.black),
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CupertinoSearchTextField(
              autofocus: true, // Keyboard pops up instantly!
              placeholder: "Search",
              onChanged: (value) {
                // Instantly update the search state as user types
                ref.read(searchQueryProvider.notifier).state = value;
              },
            ),
          ),
        ),

        // --- BODY: LIVE SUGGESTIONS ---
        body: dataAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: Colors.red)),
          error: (err, stack) => Center(child: Text("Error: $err")),
          data: (data) {
            // If user hasn't typed anything yet, show a clean prompt
            if (query.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search, size: 80, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text("Type a name or category to search", style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
                  ],
                ),
              );
            }

            // Filter the lists locally (Blazing fast!)
            final doctors = (data["doctors"] as List<DoctorModel>).where((doc) =>
            doc.name.toLowerCase().contains(query) ||
                doc.address.toLowerCase().contains(query) ||
                doc.qualification.toLowerCase().contains(query)
            ).toList();

            final categories = (data["categories"] as List<CategoryModel>).where((cat) =>
                cat.categoryName.toLowerCase().contains(query)
            ).toList();

            final healthcare = (data["healthcare"] as List<HealthcareCategoryModel>).where((hCat) =>
                hCat.category.toLowerCase().contains(query)
            ).toList();

            if (doctors.isEmpty && categories.isEmpty && healthcare.isEmpty) {
              return const Center(child: Text("No suggestions found", style: TextStyle(color: Colors.grey)));
            }

            return ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag, // Hides keyboard when scrolling
              children: [

                // 1. HEALTHCARE SUGGESTIONS
                if (healthcare.isNotEmpty) ...[
                  _buildSectionHeader("Healthcare Categories"),
                  ...healthcare.map((hCat) => ListTile(
                    leading: Image.asset('lib/images/MEDICARE.png',
                    height: 30,
                      width:30,
                      fit: BoxFit.contain,
                      color: Colors.black,
                    ),
                    title: Text(hCat.category, style: const TextStyle(fontWeight: FontWeight.w600)),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const HealthcarePage()));
                    },
                  )),
                ],

                // 2. GENERAL CATEGORY SUGGESTIONS
                // if (categories.isNotEmpty) ...[
                //   _buildSectionHeader("Services"),
                //   ...categories.map((cat) => ListTile(
                //     leading: const Icon(Icons.category, color: Colors.blue),
                //     title: Text(cat.categoryName, style: const TextStyle(fontWeight: FontWeight.w600)),
                //     onTap: () {
                //       Navigator.push(context, MaterialPageRoute(
                //         builder: (_) => ClientListPage(categoryId: cat.id, categoryName: cat.categoryName),
                //       ));
                //     },
                //   )),
                // ],

                // 3. DOCTOR SUGGESTIONS
                if (doctors.isNotEmpty) ...[
                  _buildSectionHeader("Doctors & Hospitals"),
                  ...doctors.map((doc) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.shade50,
                      child: const Icon(Icons.local_hospital, color: Colors.green),
                    ),
                    title: Text(doc.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text("${doc.qualification}", maxLines: 1, overflow: TextOverflow.ellipsis),
                    onTap: () {
                      // Routes directly to the standard Doctor List page!
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => DoctorListPage(
                          categoryId: doc.categoryIds.isNotEmpty ? doc.categoryIds.first : 0,
                          categoryName: doc.name,
                        ),
                      ));
                    },
                  )),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade600, letterSpacing: 1.2),
      ),
    );
  }
}