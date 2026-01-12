import 'package:flutter/material.dart';
import '../widget/customAppBar.dart';
import '../services/user_service.dart';
import '../utils/responsive_helper.dart';

class FoodPage extends StatelessWidget {
  const FoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context, UserService.userName, ResponsiveHelper.getAppBarHeight(context)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveHelper.getPadding(context),
          child: Column(
            children: [
              // Big Food Icon Box
              Container(
                height: ResponsiveHelper.getContainerHeight(context, baseHeight: 140),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B2B36),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant,
                      color: Colors.white, 
                      size: ResponsiveHelper.getIconSize(context, baseSize: 70)
                    ),
                    SizedBox(height: ResponsiveHelper.getSpacing(context, baseSpacing: 6)),
                    Text(
                      "Food & Dining",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.getFontSize(context, baseSize: 18),
                        fontWeight: FontWeight.bold
                      )
                    ),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveHelper.getSpacing(context, baseSpacing: 15)),
              
              // Placeholder content
              Container(
                padding: ResponsiveHelper.getPadding(context),
                child: Text(
                  "Food page content will be implemented here",
                  style: TextStyle(fontSize: ResponsiveHelper.getFontSize(context, baseSize: 16)),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
