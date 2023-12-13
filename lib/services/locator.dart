import 'package:get_it/get_it.dart';

import '../screens/dashboard/ml_service.dart';
import 'camera.service.dart';
import 'face_detector_service.dart';

final locator = GetIt.instance;

void setupServices() {
  locator.registerLazySingleton<CameraService>(() => CameraService());
  locator.registerLazySingleton<FaceDetectorService>(() => FaceDetectorService());
  locator.registerLazySingleton<MLService>(() => MLService());
}
