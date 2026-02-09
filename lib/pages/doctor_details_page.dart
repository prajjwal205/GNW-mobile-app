import 'package:flutter/material.dart';
import 'package:gnw/Models/doctor_model.dart';
import 'package:gnw/providers/auth_provider.dart';
import '../widget/customAppBar.dart';
import '../utils/responsive_helper.dart';

class DoctorDetailsPage extends StatefulWidget {
  final String categoryName;
  final int categoryId;

  const DoctorDetailsPage({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  @override
  State<DoctorDetailsPage> createState() => _DoctorDetailsPageState();
}

class _DoctorDetailsPageState extends State<DoctorDetailsPage> {
  late Future<String> _userNameFuture;
  bool isLoading = true;
  List<DoctorModel> doctorList = [];

  @override
  void initState() {
    super.initState();
    _userNameFuture = AuthService.fetchUserName();
    loadDoctors();
  }

  Future<void> loadDoctors() async {
    final allDoctors = await AuthService.fetchDoctor();

    final filteredDoctors = allDoctors
        .where((doc) => doc.subCategoryId == widget.categoryId)
        .toList();

    setState(() {
      doctorList = filteredDoctors;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _userNameFuture,
      builder: (context, snapshot) {
        String userName = snapshot.data ?? "User";

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),

          // ✅ Custom AppBar
          appBar: buildCustomAppBar(
            context,
            userName,
            ResponsiveHelper.getAppBarHeight(context),
          ),

          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Doctors in ${widget.categoryName}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : doctorList.isEmpty
                    ? const Center(child: Text("No Doctors Found"))
                    : ListView.builder(
                  itemCount: doctorList.length,
                  itemBuilder: (context, index) {
                    final doctor = doctorList[index];

                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              // ✅ Doctor Name
                              Text(
                                doctor.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // ✅ Doctor ID + Category ID
                              Text("Doctor ID: ${doctor.id}"),
                              Text("SubCategory ID: ${doctor.subCategoryId}"),

                              const Divider(height: 20),

                              // ✅ Qualification
                              Text(
                                "Qualification: ${doctor.Qualification}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 6),

                              // ✅ Experience
                              Text(
                                "Experience: ${doctor.Experience} Years",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 6),

                              // ✅ Phone
                              Text(
                                "Phone: ${doctor.Phonenumber}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 6),

                              // ✅ Email
                              Text(
                                "Email: ${doctor.email}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 6),

                              // ✅ Location
                              Text(
                                "Location: ${doctor.location}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 10),

                              // ✅ About Doctor
                              const Text(
                                "About Doctor:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                doctor.AboutDoctor,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                              ),

                              const SizedBox(height: 15),

                              // ✅ Doctor Image
                              if (doctor.doctorImage != null)
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Doctor Image:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(12),
                                      child: Image.network(
                                        doctor.doctorImage!,
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Text("Image not loading");
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                  ],
                                ),

                              // ✅ Clinic Image
                              if (doctor.clinicImage != null)
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Clinic Image:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(12),
                                      child: Image.network(
                                        doctor.clinicImage!,
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Text("Image not loading");
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                  ],
                                ),

                              // ✅ Active Status
                              Row(
                                children: [
                                  const Text(
                                    "Status: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    doctor.IsActive ? "Active" : "Inactive",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: doctor.IsActive
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
