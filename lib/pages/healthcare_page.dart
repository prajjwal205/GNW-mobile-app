import 'package:flutter/material.dart';
import '../widget/customAppBar.dart';
import '../services/user_service.dart';
import '../utils/responsive_helper.dart';

class HealthcarePage extends StatelessWidget {
  const HealthcarePage({super.key});

  // Each category button
  Widget _buildCategoryButton(
      BuildContext context,
      {required String title,
        required IconData icon,
        required Color color,
        required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.all(ResponsiveHelper.getSpacing(context, baseSpacing: 6)),
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveHelper.getSpacing(context, baseSpacing: 12), 
            horizontal: ResponsiveHelper.getSpacing(context, baseSpacing: 8)
          ),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon, 
                color: Colors.white, 
                size: ResponsiveHelper.getIconSize(context, baseSize: 18)
              ),
              SizedBox(width: ResponsiveHelper.getSpacing(context, baseSpacing: 6)),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.getFontSize(context, baseSize: 14),
                    fontWeight: FontWeight.w600
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context, UserService.userName, ResponsiveHelper.getAppBarHeight(context)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveHelper.getPadding(context),
          child: Column(
            children: [
              // Big Healthcare Icon Box
              Container(
                height: ResponsiveHelper.getContainerHeight(context, baseHeight: 140),
                width: 130,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B2B36),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: ResponsiveHelper.getIconSize(context, baseSize: 70),
                         child: Image.asset(
                        "lib/images/MEDICARE.png", // <-- your PNG file path
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.getSpacing(context, baseSpacing: 6)),
                    Text(
                      "Healthcare",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.getFontSize(context, baseSize: 18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

              ),
              SizedBox(height: ResponsiveHelper.getSpacing(context, baseSpacing: 15)),

              // Buttons in Grid (2 per row)
              Column(
                children: [
                                     Row(
                     children: [
                       _buildCategoryButton(
                           context,
                           title: "General Physician",
                           icon: Icons.medical_services,
                           color: Colors.lightBlue,
                           onTap: () {
                             ScaffoldMessenger.of(context).showSnackBar(
                                 const SnackBar(content: Text("General Physician Clicked")));
                           }),
                       _buildCategoryButton(
                           context,
                           title: "Pediatrician",
                           icon: Icons.child_care,
                           color: Colors.purpleAccent,
                           onTap: () {}),
                     ],
                   ),
                                     Row(
                     children: [
                       _buildCategoryButton(
                           context,
                           title: "Gynecologist",
                           icon: Icons.female,
                           color: Colors.pink,
                           onTap: () {}),
                       _buildCategoryButton(
                           context,
                           title: "Cardiologist",
                           icon: Icons.favorite,
                           color: Colors.red,
                           onTap: () {}),
                     ],
                   ),
                  Row(
                    children: [
                                             _buildCategoryButton(
                           context,
                           title: "Orthopedic",
                          icon: Icons.accessibility_new,
                          color: Colors.orange,
                          onTap: () {}),
                                             _buildCategoryButton(
                           context,
                           title: "Dermatologist",
                          icon: Icons.eco,
                          color: Colors.green,
                          onTap: () {}),
                    ],
                  ),
                  Row(
                    children: [
                                             _buildCategoryButton(
                           context,
                           title: "ENT Specialist",
                          icon: Icons.hearing,
                          color: Colors.teal,
                          onTap: () {}),
                                             _buildCategoryButton(
                           context,
                           title: "Neurologist",
                          icon: Icons.psychology,
                          color: Colors.deepPurple,
                          onTap: () {}),
                    ],
                  ),
                  Row(
                    children: [
                                             _buildCategoryButton(
                           context,
                           title: "Psychologist",
                          icon: Icons.self_improvement,
                          color: Colors.purple,
                          onTap: () {}),
                                             _buildCategoryButton(
                           context,
                           title: "Diagnostics",
                          icon: Icons.science,
                          color: Colors.deepOrange,
                          onTap: () {}),
                    ],
                  ),
                  Row(
                    children: [
                                             _buildCategoryButton(
                           context,
                           title: "Pharmacy",
                          icon: Icons.local_pharmacy,
                          color: Colors.teal,
                          onTap: () {}),
                                             _buildCategoryButton(
                           context,
                           title: "Dentist",
                          icon: Icons.medical_services_outlined,
                          color: Colors.cyan,
                          onTap: () {}),
                    ],
                  ),
                  Row(
                    children: [
                                             _buildCategoryButton(
                           context,
                           title: "Physiotherapy",
                          icon: Icons.fitness_center,
                          color: Colors.green,
                          onTap: () {}),
                                             _buildCategoryButton(
                           context,
                           title: "Eye Care",
                          icon: Icons.remove_red_eye,
                          color: Colors.blue,
                          onTap: () {}),
                    ],
                  ),
                  Row(
                    children: [
                                             _buildCategoryButton(
                           context,
                           title: "Ayurveda",
                          icon: Icons.spa,
                          color: Colors.pinkAccent,
                          onTap: () {}),
                                             _buildCategoryButton(
                           context,
                           title: "Homeopathy",
                          icon: Icons.medication,
                          color: Colors.redAccent,
                          onTap: () {}),
                    ],
                  ),
                  Row(
                    children: [
                                             _buildCategoryButton(
                           context,
                           title: "Yoga & Meditation",
                          icon: Icons.self_improvement,
                          color: Colors.pink,
                          onTap: () {}),
                                             _buildCategoryButton(
                           context,
                           title: "Dieticians",
                          icon: Icons.apple,
                          color: Colors.orange,
                          onTap: () {}),
                    ],
                  ),
                                     Row(
                     children: [
                                               _buildCategoryButton(
                            context,
                            title: "Weight Loss",
                           icon: Icons.air,
                           color: Colors.green,
                           onTap: () {}),
                                               _buildCategoryButton(
                            context,
                            title: "Ambulance",
                           icon: Icons.local_hospital,
                           color: Colors.teal,
                           onTap: () {}),
                     ],
                   ),
                   Row(
                     children: [
                                               _buildCategoryButton(
                            context,
                            title: "Blood Bank",
                           icon: Icons.bloodtype,
                           color: Colors.red,
                           onTap: () {}),
                                               _buildCategoryButton(
                            context,
                            title: "Elderly Care",
                           icon: Icons.elderly,
                           color: Colors.purple,
                           onTap: () {}),
                     ],
                   ),
                   Row(
                     children: [
                                               _buildCategoryButton(
                            context,
                            title: "Urology",
                           icon: Icons.medical_information,
                           color: Colors.blue,
                           onTap: () {}),
                                               _buildCategoryButton(
                            context,
                            title: "Neurology",
                           icon: Icons.psychology,
                           color: Colors.indigo,
                           onTap: () {}),
                     ],
                   ),
                   Row(
                     children: [
                                               _buildCategoryButton(
                            context,
                            title: "Nursing Staff",
                           icon: Icons.medical_services,
                           color: Colors.pink,
                           onTap: () {}),
                                               _buildCategoryButton(
                            context,
                            title: "IVF",
                           icon: Icons.family_restroom,
                           color: Colors.cyan,
                           onTap: () {}),
                     ],
                   ),
                   Row(
                     children: [
                                               _buildCategoryButton(
                            context,
                            title: "Oncology",
                           icon: Icons.science,
                           color: Colors.deepOrange,
                           onTap: () {}),
                                               _buildCategoryButton(
                            context,
                            title: "Nephrology",
                           icon: Icons.water_drop,
                           color: Colors.blueGrey,
                           onTap: () {}),
                     ],
                   ),
                   Row(
                     children: [
                                               _buildCategoryButton(
                            context,
                            title: "Vaccination",
                           icon: Icons.vaccines,
                           color: Colors.lightGreen,
                           onTap: () {}),
                                               _buildCategoryButton(
                            context,
                            title: "Medical Devices",
                           icon: Icons.devices,
                           color: Colors.grey,
                           onTap: () {}),
                     ],
                   ),
                   Row(
                     children: [
                                               _buildCategoryButton(
                            context,
                            title: "Emergency Care",
                           icon: Icons.emergency,
                           color: Colors.redAccent,
                           onTap: () {}),
                                               _buildCategoryButton(
                            context,
                            title: "Rehabilitation",
                           icon: Icons.accessibility,
                           color: Colors.orangeAccent,
                           onTap: () {}),
                     ],
                   ),
                   Row(
                     children: [
                                               _buildCategoryButton(
                            context,
                            title: "Mental Health",
                           icon: Icons.psychology_alt,
                           color: Colors.deepPurple,
                           onTap: () {}),
                                               _buildCategoryButton(
                            context,
                            title: "Alternative Medicine",
                           icon: Icons.healing,
                           color: Colors.tealAccent,
                           onTap: () {}),
                     ],
                   ),
                   Row(
                     children: [
                                               _buildCategoryButton(
                            context,
                            title: "Laboratory",
                           icon: Icons.science_outlined,
                           color: Colors.amber,
                           onTap: () {}),
                                               _buildCategoryButton(
                            context,
                            title: "Radiology",
                           icon: Icons.radio,
                           color: Colors.lightBlueAccent,
                           onTap: () {}),
                     ],
                   ),
                   Row(
                     children: [
                                               _buildCategoryButton(
                            context,
                            title: "Surgery",
                           icon: Icons.medical_information_outlined,
                           color: Colors.red,
                           onTap: () {}),
                                               _buildCategoryButton(
                            context,
                            title: "Palliative Care",
                           icon: Icons.favorite_border,
                           color: Colors.pinkAccent,
                           onTap: () {}),
                     ],
                   ),
                   Row(
                     children: [
                                               _buildCategoryButton(
                            context,
                            title: "Geriatrics",
                           icon: Icons.elderly_woman,
                           color: Colors.brown,
                           onTap: () {}),
                                               _buildCategoryButton(
                            context,
                            title: "Pediatric Surgery",
                           icon: Icons.child_care_outlined,
                           color: Colors.lightGreenAccent,
                           onTap: () {}),
                     ],
                   ),
                   Row(
                     children: [
                                               _buildCategoryButton(
                            context,
                            title: "Infectious Disease",
                           icon: Icons.bug_report,
                           color: Colors.orange,
                           onTap: () {}),
                                               _buildCategoryButton(
                            context,
                            title: "Endocrinology",
                           icon: Icons.monitor_heart,
                           color: Colors.purpleAccent,
                           onTap: () {}),
                     ],
                   ),
                   Row(
                     children: [
                                               _buildCategoryButton(
                            context,
                            title: "Gastroenterology",
                                                        icon: Icons.medical_information,
                           color: Colors.greenAccent,
                           onTap: () {}),
                                               _buildCategoryButton(
                            context,
                            title: "Pulmonology",
                           icon: Icons.air,
                           color: Colors.cyanAccent,
                           onTap: () {}),
                     ],
                   ),
                   Row(
                     children: [
                                               _buildCategoryButton(
                            context,
                            title: "Rheumatology",
                           icon: Icons.accessibility_new_outlined,
                           color: Colors.deepOrangeAccent,
                           onTap: () {}),
                                               _buildCategoryButton(
                            context,
                            title: "Hematology",
                           icon: Icons.bloodtype_outlined,
                           color: Colors.redAccent,
                           onTap: () {}),
                     ],
                   ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
