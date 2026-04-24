import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnw/services/auth_provider.dart';
import '../Models/client_model.dart'; // ✅ Path check kar lena
import '../widget/customAppBar.dart';
import '../utils/responsive_helper.dart';
import '../widget/doctor_image_header.dart';
import '../widget/doctor_contact_info.dart';
import '../widget/doctor_call_button.dart';

// 1. Provider ab ClientModel ki list return karega
final serviceListProvider = FutureProvider.family.autoDispose<List<ClientModel>, int>((ref, subCategoryId) async {

  final clientList = await AuthService.ClientData(subCategoryId);

  // 🚀 Sort the list alphabetically (Case-insensitive)
  // NOTE: Replace `.name`   with the actual property name inside your ClientModel
  // (It might be .clientName, .businessName, or .title depending on your model)
  clientList.sort((a, b) => a.clientName.toLowerCase().compareTo(b.clientName.toLowerCase()));

  return clientList;
  // 🚀 Tumhare AuthService ka naya function call ho raha hai
  // return await AuthService.ClientData(subCategoryId);
});

class ServiceListPage extends ConsumerStatefulWidget {
  final String subCategoryName;
  final int subCategoryId;

  const ServiceListPage({
    super.key,
    required this.subCategoryName,
    required this.subCategoryId,
  });

  @override
  ConsumerState<ServiceListPage> createState() => _ServiceListPageState();
}

class _ServiceListPageState extends ConsumerState<ServiceListPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serviceAsync = ref.watch(serviceListProvider(widget.subCategoryId));

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(appBarHeight: ResponsiveHelper.getAppBarHeight(context)),
        body: serviceAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFFFA726))),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (serviceList) {
            if (serviceList.isEmpty) {
              return Center(
                  child: Text(
                      "No listings available for ${widget.subCategoryName}",
                      style: const TextStyle(fontSize: 15, color: Colors.red)
                  )
              );
            }

            return PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: serviceList.length,
              itemBuilder: (context, index) {
                final clientData = serviceList[index];
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 40),
                    child: ServiceDetailBlock(
                      clientName: clientData,
                      index: index,
                      totalCount: serviceList.length,
                      pageController: _pageController,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ServiceDetailBlock extends StatelessWidget {
  final ClientModel clientName; // ✅ Model Type use kiya
  final int index;
  final int totalCount;
  final PageController pageController;

  const ServiceDetailBlock({
    super.key,
    required this.clientName,
    required this.index,
    required this.totalCount,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    double wScale = MediaQuery.of(context).size.width / 390.0;
    double spaceMed = 12 * wScale;
    double spaceLarge = 16 * wScale;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🚀 1. Image Header
        DoctorImageHeader(
          doctor: clientName,
          index: index,
          totalCount: totalCount,
          pageController: pageController,
          wScale: wScale,
        ),

        // 🚀 2. Contact Info ()
        DoctorContactInfo(doctor: clientName, wScale: wScale),
        SizedBox(height: spaceMed * 0.4),

        // 🚀 3. Call Button
        DoctorCallButton(doctor: clientName, wScale: wScale),
        SizedBox(height: spaceMed * 0.6),

        // 🚀 4. Highlights Section
        Container(
          margin: EdgeInsets.symmetric(horizontal: spaceLarge),
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 6 * wScale),
          decoration: BoxDecoration(
              color: const Color(0xFFFFA726),
              borderRadius: BorderRadius.circular(30 * wScale)
          ),
          alignment: Alignment.center,
          child: Text("HIGHLIGHTS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13 * wScale)),
        ),

        Padding(
          padding: EdgeInsets.only(left: spaceLarge, right: spaceLarge, top: 10 * wScale, bottom: spaceLarge),
          child: Text(
            // ✅ Naya JSON field 'highlights' use ho raha hai
            clientName.highlights.isNotEmpty ? clientName.highlights : "No details available.",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 13 * wScale, height: 1.2, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}