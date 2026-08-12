// File: lib/utils/search_helper.dart
import '../Models/client_model.dart';
import '../Models/doctor_model.dart';
import '../Models/healthcare_model.dart';
import '../Models/SubCategoryModel.dart';

class SearchHelper {
  // 🚀 STRICT MATCHER (Amazon Style)
  static bool isMatch(String text, String query) {
    if (text.isEmpty) return false;
    return text.toLowerCase().startsWith(query);
  }

  // 🚀 Helper method for name extraction
  static String getSuggestionName(Object option) {
    if (option is SubCategoryModel) return option.categoryName;
    if (option is ClientModel) return option.clientName;
    if (option is HealthcareCategoryModel) return option.category;
    if (option is DoctorModel) return option.name;
    return '';
  }
}