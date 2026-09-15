import 'package:flutter/material.dart';
import 'package:gelir_gider_app/core/app_bindings.dart';
import 'package:gelir_gider_app/modules/home/home_page.dart';
import 'package:gelir_gider_app/routes/app_pages.dart';
import 'package:get/get.dart';

import 'themes/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.INITIAL,
      darkTheme: AppTheme.darkTheme,
      theme: AppTheme.lightTheme,
      initialBinding: AppBindings(),
      
      
    );
  }
}

