import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'core/routes/routes.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Simple Login',
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
      initialRoute: Routes.SPLASH,
    );
  }
}
