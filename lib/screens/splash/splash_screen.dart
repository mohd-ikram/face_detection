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

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 4),
    vsync: this,
  )..repeat(reverse: true);

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticOut,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      SharedPreferenceService preferenceService =
          Get.find<SharedPreferenceService>();
      if (preferenceService.getBool(TextConst.isFirstTimeUser) ?? true) {
        Get.offAndToNamed(AppRoute.login);
      } else {
        Get.offAndToNamed(AppRoute.dashboard);
      }
    });

    return Material(
      /*child: RotationTransition(
        turns: _animation,
        child: Center(
          child: Text('Face Detection', style: AppTextStyle.boldWhite28.copyWith(color: ColorConst.primary)),
        ),
      ),*/
      child: Center(
          child: SizedBox(
        width: 200,
        height: 200,
        child: Image.asset('assets/images/f_detection.png',),
      )),
    );
  }
}
