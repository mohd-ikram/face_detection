import 'package:face_detection/utils/db/db_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:material_color_generator/material_color_generator.dart';

import 'bindings/app_binding.dart';
import 'constant/color_const.dart';
import 'constant/text_constant.dart';
import 'localization/app_locale.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

Future<void> main() async{
  await Hive.initFlutter();
  await HiveBoxes.init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: TextConst.appName,
      // theme: AppTheme.light,
      theme: ThemeData(
        primarySwatch: generateMaterialColor(color: ColorConst.primary,),
      ),
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialBinding: AppBindings(),
      getPages: AppPages.routes,
      initialRoute: AppRoute.splashScreen,
      translations: AppLocale(),
      locale: const Locale('en', 'US'),
    );
  }
}
