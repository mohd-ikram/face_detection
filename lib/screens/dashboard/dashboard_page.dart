import 'dart:io';

import 'package:camera/camera.dart';
import 'package:face_detection/screens/dashboard/ml_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/User.dart';
import '../../utils/log.dart';

class DashboardPage extends StatefulWidget {
  final User? user;

  const DashboardPage({Key? key, this.user}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with WidgetsBindingObserver {
  TextEditingController txtController = TextEditingController();
  List<CameraDescription>? cameras;
  CameraController? controller;
  bool _isRearCameraSelected = false;
  bool _isCameraInitialized = false;
  bool _isCameraPermissionGranted = false;
  FaceDetector? _faceDetector;
  MLService _mlService = new MLService();
  List<Face> faceList = [];
  bool flash = false;

  @override
  void initState() {
    // Hide the status bar
    SystemChrome.setEnabledSystemUIOverlays([]);
    getPermissionStatus();
    initCamera();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> initCamera() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      cameras = await availableCameras();

      _faceDetector = GoogleMlKit.vision.faceDetector(
          FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate));
    } on CameraException catch (e) {
      Log.logger.e('Error in fetching the cameras: $e');
    }
  }

  // Predict face from camera image
  Future<void> _predictFacesFromImage(
      {required CameraImage cameraImage}) async {
    if (faceList.isNotEmpty) {
      User? user = await _mlService.predict(
          cameraImage,
          faceList[0],
          widget.user != null,
          widget.user != null ? widget.user!.userName! : txtController.text);
      if (widget.user == null) {
        Navigator.pop(context);
        Log.logger.d("User Registed....");
      } else {
        //Navigate to home screen with user data
      }
    }
    if (mounted) {
      setState(() {});
      await takePicture();
    }
  }

  //Image rotation
  InputImageRotation rotationIntToImageRotation(int rotation) {
    switch (rotation) {
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
    InputImageData inputImageData = InputImageData(
        size: Size(cameraImage.width.toDouble(), cameraImage.height.toDouble()),
        imageRotation: rotationIntToImageRotation(
            controller!.description.sensorOrientation),
        inputImageFormat: InputImageFormat.bgra8888,
        planeData: cameraImage.planes.map(
          (Plane plane) {
            return InputImagePlaneMetadata(
                bytesPerRow: plane.bytesPerRow,
                height: plane.height,
                width: plane.width);
          },
        ).toList());
    InputImage visionImage = InputImage.fromBytes(
        bytes: cameraImage.planes[0].bytes, inputImageData: inputImageData);
    var result = await _faceDetector!.processImage(visionImage);
    if (result.isNotEmpty) {
      faceList = result;
    }
  }

  void getPermissionStatus() async {
    await Permission.camera.request();
    var status = await Permission.camera.status;
    if (status.isGranted) {
      Log.logger.d('Camera Permission: GRANTED');
      setState(() {
        _isCameraPermissionGranted = true;
      });
      // Set and initialize the new camera
      onNewCameraSelected(cameras![0]);
      //refreshAlreadyCapturedImages();
    } else {
      Log.logger.d('Camera Permission: DENIED');
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
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
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
      Log.logger.e('Error initializing camera: $e');
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
      Log.logger.v("Taking picture ");
      return null;
    }
    try {
      XFile file = await cameraController.takePicture();
      Log.logger.v("Image file is at "+file.path);
      return file;
    } on CameraException catch (e) {
      Log.logger.e('Error occured while taking picture: $e');
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
                    onNewCameraSelected(
                      cameras![_isRearCameraSelected ? 0 : 1],
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
                    /*bool canProcess = false;
                    controller!.startImageStream((image) async {
                      if (canProcess) return;
                      _predictFacesFromImage(cameraImage: image).then((value) {
                        canProcess = false;
                      });
                      return null;
                    });*/
                    XFile? rawImage = await takePicture();
                    File imageFile = File(rawImage!.path);

                    int currentUnix = DateTime.now().millisecondsSinceEpoch;
                    final directory = await getApplicationDocumentsDirectory();
                    String fileFormat = imageFile.path.split('.').last;

                    await imageFile.copy(
                      '${directory.path}/$currentUnix.$fileFormat',
                    );
                  },
                  child: Stack(
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
