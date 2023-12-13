
import 'package:face_detection/screens/login/login_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/network_service.dart';
import '../services/shared_preference_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    //Controller binding
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    // Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
    // Get.lazyPut<HomeController>(() => HomeController(), fenix: true);


    //Repo binding
    //Get.lazyPut<ProductRepo>(() => ProductRepo(), fenix: true);
    //Utils binding
    Get.putAsync<SharedPreferences>(() async {
      return await SharedPreferences.getInstance();
    }, permanent: true);
    Get.lazyPut(() => SharedPreferences.getInstance(), fenix: true);

    //Services binding
    Get.lazyPut<SharedPreferenceService>(
        () => SharedPreferenceService(Get.find<SharedPreferences>()),
        fenix: true);
    Get.lazyPut<NetworkService>(
        () => NetworkService(Get.find<SharedPreferenceService>()),
        fenix: true);
  }
}
