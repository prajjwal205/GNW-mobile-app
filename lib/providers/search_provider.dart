// File: lib/providers/search_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Models/client_model.dart';
import '../Models/doctor_model.dart';
import '../Models/category_model.dart';
import '../Models/healthcare_model.dart';
import '../Models/SubCategoryModel.dart';
import '../services/auth_provider.dart';

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