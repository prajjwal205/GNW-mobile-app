import 'package:flutter/material.dart';
import 'package:gnw/pages/healthcare_page.dart';
import 'package:gnw/pages/food_page.dart';
import 'package:gnw/widget/customAppBar.dart';
import 'package:gnw/services/user_service.dart';
import 'utils/responsive_helper.dart';

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

        return Scaffold(
          appBar: buildCustomAppBar(context, snapshot.data!, ResponsiveHelper.getAppBarHeight(context)),
          // body:SafeArea(
          //   child:SingleChildScrollView(
          //     child: Column(
          //       children: [
          //         const SizedBox(height: 5,),
          //         // Sponsor Banner
          //         Container(
          //           height: ResponsiveHelper.screenHeight(context) * 0.18,
          //           width: ResponsiveHelper.screenWidth(context) * 0.90,
          //           margin: ResponsiveHelper.getMargin(context),
          //           decoration: BoxDecoration(
          //             color: Colors.grey[300],
          //             borderRadius: BorderRadius.circular(15),
          //           ),
          //           child: Center(
          //             child: Text(
          //               "SPONSOR\n BANNER",
          //               style: TextStyle(
          //                   fontSize: ResponsiveHelper.getFontSize(context, baseSize: 18),
          //                   fontWeight: FontWeight.bold
          //               ),
          //             ),
          //           ),
          //         ),
          //
          //         // Search Bar
          //         Padding(
          //           padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.getSpacing(context, baseSpacing: 10)),
          //           child: TextField(
          //             decoration: InputDecoration(
          //               hint: RichText(text: TextSpan(style: TextStyle(color: Colors.black),
          //                   children:[
          //                     TextSpan(text: "Search"),
          //                     TextSpan(text: " Ayurveda",style: TextStyle(fontWeight: FontWeight.bold))
          //                   ]
          //               ),
          //               ),
          //               prefixIcon: const Icon(Icons.search),
          //               border: OutlineInputBorder(
          //                 borderRadius: BorderRadius.circular(25),
          //               ),
          //               contentPadding: const EdgeInsets.symmetric(vertical: 0),
          //             ),
          //           ),
          //         ),
          //         SizedBox(height: ResponsiveHelper.getSpacing(context, baseSpacing: 10)),
          //
          //
          //         // Grid Menu
          //         Padding(
          //           padding: ResponsiveHelper.getMargin(context),
          //           child: GridView.count(
          //             shrinkWrap: true,
          //             physics: const NeverScrollableScrollPhysics(),
          //             crossAxisCount: 4,
          //             crossAxisSpacing: 12,
          //             mainAxisSpacing: 16,
          //             children: [
          //               _imageGridItem('lib/images/MEDICARE.png', "Healthcare", () {
          //                 Navigator.push(context, MaterialPageRoute(builder: (_) => HealthcarePage()));
          //               }),
          //
          //               _imageGridItem('lib/images/FOODIE.png', "Food", () {
          //                 Navigator.push(context, MaterialPageRoute(builder: (_) => const FoodPage()));
          //               }),
          //               _imageGridItem('lib/images/SHOPPING.png', "Shopping", () {
          //                 ScaffoldMessenger.of(context).showSnackBar(
          //                   const SnackBar(content: Text(' page not implemented.')),
          //                 );
          //               }),
          //               _imageGridItem('lib/images/MAKEOVER.png', "Makeovers", () {
          //                 ScaffoldMessenger.of(context).showSnackBar(
          //                   const SnackBar(content: Text('Makeovers page not implemented.')),
          //                 ); }),
          //               _imageGridItem('lib/images/EVENTS.png', "Events", () {
          //                 ScaffoldMessenger.of(context).showSnackBar(
          //                   const SnackBar(content: Text('Events page not implemented.')),
          //                 ); }),
          //               _imageGridItem('lib/images/TRAVEL.png', "Travel", () {
          //                 ScaffoldMessenger.of(context).showSnackBar(
          //                   const SnackBar(content: Text('Events page not implemented.')),
          //                 );                      }),
          //               _imageGridItem('lib/images/HOMECARE_2.png', "Homecare", () {
          //                 ScaffoldMessenger.of(context).showSnackBar(
          //                   const SnackBar(content: Text('Events page not implemented.')),
          //                 );                      }),
          //               _imageGridItem('lib/images/REAL_ESTATE.png', "Property", () {
          //                 ScaffoldMessenger.of(context).showSnackBar(
          //                   const SnackBar(content: Text('Events page not implemented.')),
          //                 );                      }),
          //               _imageGridItem('lib/images/ASTROLOGY.png', "Astrology", () {
          //                 ScaffoldMessenger.of(context).showSnackBar(
          //                   const SnackBar(content: Text('Events page not implemented.')),
          //                 );                      }),
          //               _imageGridItem('lib/images/EDUCATION.png', "Education", () {
          //                 ScaffoldMessenger.of(context).showSnackBar(
          //                   const SnackBar(content: Text('Events page not implemented.')),
          //                 );                      }),
          //               _imageGridItem('lib/images/FITNESS.png', "FitLife", () {
          //                 ScaffoldMessenger.of(context).showSnackBar(
          //                   const SnackBar(content: Text('Events page not implemented.')),
          //                 );                      }),
          //               _imageGridItem('lib/images/PETS.png', "Pets", () {
          //                 ScaffoldMessenger.of(context).showSnackBar(
          //                   const SnackBar(content: Text('Events page not implemented.')),
          //                 );                      }),
          //               _imageGridItem('lib/images/RELOCATION.png', "Relocation", () {
          //                 ScaffoldMessenger.of(context).showSnackBar(
          //                   const SnackBar(content: Text('Events page not implemented.')),
          //                 );                      }),
          //               _imageGridItem('lib/images/FINANCE.png', "Finance", () {
          //                 ScaffoldMessenger.of(context).showSnackBar(
          //                   const SnackBar(content: Text('Events page not implemented.')),
          //                 );                      }),
          //               _imageGridItem('lib/images/SECURITY.png', "Security", () {
          //                 ScaffoldMessenger.of(context).showSnackBar(
          //                   const SnackBar(content: Text('Events page not implemented.')),
          //                 );                      }),
          //               _imageGridItem('lib/images/SERVICES.png', "Services", () {
          //                 ScaffoldMessenger.of(context).showSnackBar(
          //                   const SnackBar(content: Text('Events page not implemented.')),
          //                 );                      }),
          //             ],
          //           ),
          //         ),
          //         // Deal of the Day
          //         Container(
          //           height: ResponsiveHelper.getContainerHeight(context, baseHeight: 80),
          //           margin: ResponsiveHelper.getMargin(context),
          //           decoration: BoxDecoration(
          //             color: Colors.grey[300],
          //             borderRadius: BorderRadius.circular(10),
          //           ),
          //           child: Center(
          //             child: Text(
          //               "DEAL OF THE DAY",
          //               style: TextStyle(
          //                   fontSize: ResponsiveHelper.getFontSize(context, baseSize: 18),
          //                   fontWeight: FontWeight.bold
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        );
      },
    );
  }
  // Grid Item Widget
  // For PNG
  Widget _imageGridItem(String assetPath, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: ResponsiveHelper.getIconSize(context, baseSize: 60),
            width: ResponsiveHelper.getIconSize(context, baseSize: 60),
            decoration: BoxDecoration(
              color: const Color(0xFF1B2B36), // Dark navy/black background
              borderRadius: BorderRadius.circular(8), // Rounded corners
            ),
            padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, baseSpacing: 10)),
            child: Image.asset(
              assetPath,
              fit: BoxFit.contain,
              // color: Colors.white, // Make icon white
            ),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, baseSpacing: 5)),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveHelper.getFontSize(context, baseSize: 12),
              color: Colors.black, // Label color
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
