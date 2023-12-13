import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:face_detection/models/User.dart';
import 'package:face_detection/utils/db/db_utils.dart';
import 'package:face_detection/utils/log.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as imglib;
import 'package:tflite_flutter/tflite_flutter.dart' as imglib;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../services/image_converter.dart';

class MLService {
  late Interpreter interpreter;
  List? predictedArray;

  Future<User?> predict(
      CameraImage image, Face face, bool loginUser, String userName) async {
    List inputList = _preProcessImage(image, face);
    inputList = inputList.reshape([1, 112, 112, 3]);
    List outputList = List.generate(1, (index) => List.filled(192, 0));
    await initializeInterpreter();
    interpreter.run(inputList, outputList);
    outputList = outputList.reshape([192]);
    predictedArray = List.from(outputList);
    if (!loginUser) {
      LocalDatabase.setUserDetails(
          User(userName: userName, dataArray: predictedArray));
      return null;
    } else {
      User? user = LocalDatabase.getUser();
      List userArray = user!.dataArray!;
      int minDist = 999;
      double threshold = 1.5;
      var dist = euclideanDistance(predictedArray!, userArray);
      if (dist < threshold && dist < minDist) {
        return user;
      } else
        return null;
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
      var interpreterOption = InterpreterOptions()..addDelegate(delegate!);
      interpreter = await Interpreter.fromAsset("mobilefacenet.tflite",
          options: interpreterOption);
    } catch (e) {
      Log.logger.e("Failed to load model....");
    }
  }

  List _preProcessImage(CameraImage cameraImage, Face face) {
    imglib.Image croppedImage = _cropFace(cameraImage, face);
    imglib.Image img = imglib.copyResizeCropSquare(croppedImage, 112);
    Float32List imageAsList = _imageToByteListFloat32(img);
    return imageAsList;
  }

  imglib.Image _cropFace(CameraImage image, Face faceDetected) {
    imglib.Image convertedImage = _convertCameraImage(image);
    double x = faceDetected.boundingBox.left - 10.0;
    double y = faceDetected.boundingBox.top - 10.0;
    double w = faceDetected.boundingBox.width + 10.0;
    double h = faceDetected.boundingBox.height + 10.0;
    return imglib.copyCrop(
        convertedImage, x.round(), y.round(), w.round(), h.round());
  }

  imglib.Image _convertCameraImage(CameraImage image) {
    var img = convertToImage(image);
    var img1 = imglib.copyRotate(img, -90);
    return img1;
  }

  Float32List _imageToByteListFloat32(imglib.Image image) {
    var convertedBytes = Float32List(1 * 112 * 112 * 3);
    return convertedBytes.buffer.asFloat32List();
  }
}
