import 'package:hive_flutter/hive_flutter.dart';

import '../../models/User.dart';

class HiveBoxes {
  static const userDetails = "user";

  static Box userDetailsBox() => Hive.box(userDetails);

  static init() async {
    await Hive.openBox(userDetails);
  }

  static clearAll() async {
    HiveBoxes.userDetailsBox().clear();
  }
}
class LocalDatabase {
  static getUser()=> User.fromJson(HiveBoxes.userDetailsBox().toMap());
  static String getUserName()=> HiveBoxes.userDetailsBox().toMap()[User.nameKey];
  static String getDataArray()=> HiveBoxes.userDetailsBox().toMap()[User.dataArrayKey];
  static Future<void> setUserDetails(User user)=> HiveBoxes.userDetailsBox().putAll(user.toJson());
}
