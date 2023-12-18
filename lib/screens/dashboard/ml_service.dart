import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:face_detection/models/User.dart';
import 'package:face_detection/utils/db/db_utils.dart';
import 'package:face_detection/utils/log.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as imglib;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../services/image_converter.dart';

class MLService {
  late Interpreter interpreter;
  List? predictedArray;

  Future<int> predict(
      CameraImage image, Face face, bool loginUser, String? userName) async {
    List inputList = _preProcessImage(image, face);
    inputList = inputList.reshape([1, 112, 112, 3]);
    List outputList = List.generate(1, (index) => List.filled(192, 0));
    await initializeInterpreter();
    interpreter.run(inputList, outputList);
    outputList = outputList.reshape([192]);
    predictedArray = List.from(outputList);
    User? user = LocalDatabase.getUser();
    List userArray = user!.dataArray??[];
    if (!loginUser || userArray.isEmpty) {
      Log.logger.v("Logger predict 1111 => Not login user");
      LocalDatabase.setUserDetails(
          User(userName: userName, dataArray: predictedArray));
      return 0;
    } else{
        Log.logger.v("Logger predict 1111 => Login user");
        int minDist = 999;
        double threshold = 1.5;
        var dist = euclideanDistance(predictedArray!, userArray);
        Log.logger.v("Logger predict 1111");
        if (dist < threshold && dist < minDist) {
          Log.logger.v("Logger predict 2222");
          return 1;
        } else {
          Log.logger.v("Logger predict 3333");
          return 2;
        }

    }
  }

  euclideanDistance(List list1, List list2) {
    double sum = 0;
    for (int index = 0; index < list1.length; index++) {
      sum += pow((list1[index] - list2[index]), 2);
    }
    // return pow(sum, 0.5);
    return sqrt(sum);
  }

  initializeInterpreter() async {
    Delegate? delegate;
    try {
      if (Platform.isAndroid) {
        Log.logger.v("Logger initializeInterpreter 111");
        delegate = GpuDelegateV2(
            options: GpuDelegateOptionsV2(
          isPrecisionLossAllowed: false,
          inferencePreference: TfLiteGpuInferenceUsage.fastSingleAnswer,
          inferencePriority1: TfLiteGpuInferencePriority.minLatency,
          inferencePriority2: TfLiteGpuInferencePriority.auto,
          inferencePriority3: TfLiteGpuInferencePriority.auto,
        ));
      } else if (Platform.isIOS) {
        delegate = GpuDelegate(
            options: GpuDelegateOptions(
                allowPrecisionLoss: true,
                waitType: TFLGpuDelegateWaitType.active));
      }
      Log.logger.v("Logger initializeInterpreter 222");
      var interpreterOption = InterpreterOptions()..addDelegate(delegate!);
      interpreter = await Interpreter.fromAsset("mobilefacenet.tflite",
          options: interpreterOption);

      Log.logger.v("Logger initializeInterpreter 333");
    } catch (e) {
      Log.logger.e("Failed to load model....");
    }
  }

  List _preProcessImage(CameraImage cameraImage, Face face) {
    Log.logger.v("Logger _preProcessImage 111");
    imglib.Image croppedImage = _cropFace(cameraImage, face);
    imglib.Image img = imglib.copyResizeCropSquare(croppedImage, 112);
    Float32List imageAsList = imageToByteListFloat32(img);
    Log.logger.v("_preProcessImage 222");
    return imageAsList;
  }

  imglib.Image _cropFace(CameraImage image, Face faceDetected) {
    Log.logger.v("Logger _cropFace 111");
    imglib.Image convertedImage = _convertCameraImage(image);
    double x = faceDetected.boundingBox.left - 10.0;
    double y = faceDetected.boundingBox.top - 10.0;
    double w = faceDetected.boundingBox.width + 10.0;
    double h = faceDetected.boundingBox.height + 10.0;
    Log.logger.v("Logger _cropFace 222");
    return imglib.copyCrop(
        convertedImage, x.round(), y.round(), w.round(), h.round());
  }

  imglib.Image _convertCameraImage(CameraImage image) {
    Log.logger.v("Logger _convertCameraImage 111");
    var img = convertToImage(image);
    var img1 = imglib.copyRotate(img, -90);
    Log.logger.v("Logger _convertCameraImage 222");
    return img1;
  }

  Float32List imageToByteListFloat32(imglib.Image image) {
    var convertedBytes = Float32List(1 * 112 * 112 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (var i = 0; i < 112; i++) {
      for (var j = 0; j < 112; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (imglib.getRed(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getGreen(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getBlue(pixel) - 128) / 128;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }
}
