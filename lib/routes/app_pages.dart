import 'package:face_detection/screens/home/home_page.dart';
import 'package:face_detection/screens/register/register_page.dart';
import 'package:get/get.dart';

import '../screens/dashboard/dashboard_page.dart';
import '../screens/login/LoginPage.dart';
import '../screens/splash/splash_screen.dart';
import '../utils/db/db_utils.dart';
import 'app_routes.dart';

class AppPages {
  static List<GetPage> routes = [
    GetPage(
      name: AppRoute.splashScreen,
      page: () => const SplashScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoute.login,
      page: () => const LoginPage(),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoute.signup,
      page: () => const RegisterPage(),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoute.home,
      page: () => const HomePage(),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoute.dashboard,
      page: () => const DashboardPage(),
      transition: Transition.fade,
    ),
  ];
}
