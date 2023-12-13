import 'package:face_detection/utils/log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/text_constant.dart';
import '../../routes/app_routes.dart';
import '../../services/shared_preference_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      SharedPreferenceService preferenceService =
          Get.find<SharedPreferenceService>();
      if (preferenceService.getBool(TextConst.isFirstTimeUser) ?? true) {
        Log.logger.v("First time user");
        Get.offAndToNamed(AppRoute.login);
      } else {
        Log.logger.v("Next time user");
        Get.offAndToNamed(AppRoute.dashboard);
      }
    });

    return Material(

      child: Center(
          child: SizedBox(
        width: 200,
        height: 200,
        child: Image.asset(
          'assets/images/f_detection.png',
        ),
      )),
    );
  }
}
