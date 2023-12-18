import 'package:camera/camera.dart';
import 'package:face_detection/routes/app_routes.dart';
import 'package:face_detection/screens/dashboard/ml_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/User.dart';
import '../../utils/log.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with WidgetsBindingObserver {
  final User? user = Get.arguments["user"] as User;
  TextEditingController txtController = TextEditingController();
  List<CameraDescription>? cameras;
  int _cameraIndex = 0;
  CameraController? controller;
  bool _isRearCameraSelected = false;
  bool _isCameraInitialized = false;
  bool _isCameraPermissionGranted = false;
  FaceDetector? _faceDetector;
  MLService _mlService = new MLService();
  List<Face> faceList = [];
  bool flash = false;

  @override
  void onInit() {
    // user = Get.arguments["user"] as User;
  }

  @override
  void initState() {
    // Hide the status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    getPermissionStatus();
    initCamera();
    _faceDetector = GoogleMlKit.vision.faceDetector(
        FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate));
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    txtController?.dispose();
    super.dispose();
  }

  Future<void> initCamera() async {
    try {
      Log.logger.d('Logger.. Init camera');
      WidgetsFlutterBinding.ensureInitialized();
      cameras = await availableCameras();
    } on CameraException catch (e) {
      Log.logger.e('Logger.. Error in fetching the cameras: $e');
    }
  }

  // Predict face from camera image
  Future<void> _predictFacesFromImage(
      {required CameraImage cameraImage}) async {
    await detectFacesFromCameraImage(cameraImage);
    if (faceList.isNotEmpty) {
      Log.logger.v("Logger _predictFacesFromImage =>  faceList.isNotEmpty... ");
      /*User? _user = await _mlService.predict(
          cameraImage,
          faceList[0],
          widget.user != null,
          widget.user != null ? widget.user!.userName! : txtController.text);*/
      User? _user = await _mlService.predict(cameraImage, faceList[0],
          user != null, (user!.dataArray??[]).isEmpty ? txtController.text : user!.userName);
      if ((user!.dataArray??[]).isEmpty && _user==null) {
        Get.back();
        Log.logger.d("Logger.. User Registerd....");
      } else {
        Log.logger.v("Logger.. User login... ");
        //Navigate to home screen with user data
        Get.offAndToNamed(AppRoute.home, arguments: {"user": user});
      }
    }
    if (mounted) {
      Log.logger.d("Logger..Mounted....");
      setState(() {});
      await takePicture();
    }
  }

  //Image rotation
  InputImageRotation rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 0:
        return InputImageRotation.rotation0deg;
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  //Detect faces from image
  Future<void> detectFacesFromCameraImage(CameraImage cameraImage) async {
    Log.logger.d("Logger.. detectFacesFromCameraImage");
    final _orientations = {
      DeviceOrientation.portraitUp: 0,
      DeviceOrientation.landscapeLeft: 90,
      DeviceOrientation.portraitDown: 180,
      DeviceOrientation.landscapeRight: 270,
    };
    final camera = cameras![_cameraIndex];
    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;
    var rotationCompensation =
        _orientations[controller!.value.deviceOrientation];
    if (rotationCompensation == null) return null;
    if (camera.lensDirection == CameraLensDirection.front) {
      // front-facing
      rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
    } else {
      // back-facing
      rotationCompensation =
          (sensorOrientation - rotationCompensation + 360) % 360;
    }
    rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    // print('rotationCompensation: $rotationCompensation');
    InputImageData inputImageData = InputImageData(
        size: Size(cameraImage.width.toDouble(), cameraImage.height.toDouble()),
        imageRotation: rotation!,
        inputImageFormat: InputImageFormat.yuv420,
        planeData: cameraImage.planes.map(
          (Plane plane) {
            return InputImagePlaneMetadata(
                bytesPerRow: plane.bytesPerRow,
                height: plane.height,
                width: plane.width);
          },
        ).toList());
    Log.logger.d("Logger.. detectFacesFromCameraImage ${inputImageData}");
    InputImage visionImage = InputImage.fromBytes(
        bytes: cameraImage.planes[0].bytes, inputImageData: inputImageData);
    Log.logger.d("Logger.. detectFacesFromCameraImage ${visionImage.bytes}");
    var result = await _faceDetector!.processImage(visionImage);
    Log.logger.d("Logger.. Image result isEmpty ${result.isEmpty}");
    if (result.isNotEmpty) {
      faceList = result;
    }
  }

  void getPermissionStatus() async {
    await Permission.camera.request();
    var status = await Permission.camera.status;
    if (status.isGranted) {
      Log.logger.d('Logger.. Camera Permission: GRANTED');
      setState(() {
        _isCameraPermissionGranted = true;
      });
      // Set and initialize the new camera
      onNewCameraSelected(cameras![_cameraIndex]);
      //refreshAlreadyCapturedImages();
    } else {
      Log.logger.d('Logger.. Camera Permission: DENIED');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera with same properties
      onNewCameraSelected(cameraController.description);
    }
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    // Instantiating the camera controller
    // final resolutionPresets = ResolutionPreset.values;
    // ResolutionPreset currentResolutionPreset = ResolutionPreset.high;
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.nv21,
      enableAudio: false,
    );

    // Dispose the previous controller
    await previousCameraController?.dispose();

    // Replace with the new controller
    if (mounted) {
      setState(() {
        controller = cameraController;
        controller!.startImageStream((image) => {});
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    // Initialize controller
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      Log.logger.e('Logger.. Error initializing camera: $e');
    }

    // Update the Boolean
    if (mounted) {
      setState(() {
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      Log.logger.v("Logger.. Taking picture ");
      return null;
    }
    try {
      XFile file = await cameraController.takePicture();
      Log.logger.v("Logger.. Image file is at " + file.path);
      return file;
    } on CameraException catch (e) {
      Log.logger.e('Logger.. Error occured while taking picture: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.brown,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isCameraPermissionGranted
                ? getCameraPreview()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(),
                      const Text(
                        'Permission denied',
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          getPermissionStatus();
                        },
                        child: const Text('Give permission'),
                      ),
                    ],
                  ),
            TextField(
              controller: txtController,
              decoration:
                  const InputDecoration(fillColor: Colors.white, filled: true),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _isCameraInitialized = false;
                    });
                    _cameraIndex = _isRearCameraSelected ? 0 : 1;
                    onNewCameraSelected(
                      cameras![_cameraIndex],
                    );
                    setState(() {
                      _isRearCameraSelected = !_isRearCameraSelected;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.circle,
                        color: Colors.black38,
                        size: 60,
                      ),
                      Icon(
                        _isRearCameraSelected
                            ? Icons.camera_front
                            : Icons.camera_rear,
                        color: Colors.white,
                        size: 30,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    bool canProcess = false;
                    Log.logger.v("Logger.. Camera button tap");
                    controller!.startImageStream((image) async {
                      Log.logger.v("Logger.. startImageStream");
                      if (canProcess) {
                        Log.logger.v("Logger.. Can process ... $canProcess");
                        return;
                      }
                      canProcess = true;

                      _predictFacesFromImage(cameraImage: image).then((value) {
                        Log.logger
                            .v("Logger.. _predictFacesFromImage.then ... ");
                        canProcess = false;
                      });
                      return null;
                    });
                    /*XFile? rawImage = await takePicture();
                    File imageFile = File(rawImage!.path);

                    int currentUnix = DateTime.now().millisecondsSinceEpoch;
                    final directory = await getApplicationDocumentsDirectory();
                    String fileFormat = imageFile.path.split('.').last;

                    await imageFile.copy(
                      '${directory.path}/$currentUnix.$fileFormat',
                    );*/
                  },
                  child: const Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(Icons.circle, color: Colors.white38, size: 80),
                      Icon(Icons.circle, color: Colors.white, size: 65),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(flash ? Icons.flash_on : Icons.flash_off),
                  color: Colors.white,
                  iconSize: 28,
                  onPressed: () {
                    setState(() {
                      flash = !flash;
                    });
                    flash
                        ? controller!.setFlashMode(FlashMode.torch)
                        : controller!.setFlashMode(FlashMode.off);
                  },
                ),
              ],
            )
          ],
        ));
  }

  Widget getCameraPreview() {
    return _isCameraInitialized
        ? AspectRatio(
            aspectRatio: 1 / controller!.value.aspectRatio,
            child: controller!.buildPreview(),
          )
        : Container();
  }
}
