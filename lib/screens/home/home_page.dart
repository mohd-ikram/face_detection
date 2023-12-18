import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/User.dart';
import '../../theme/text_style.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = Get.arguments["user"] as User;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 100.0),
            child: Center(
                child: Text(
              'Welcom ${user!.userName}',
              style: AppTextStyle.boldBlackGrey18.copyWith(fontSize: 14),
            )),
          ),
        ],
      ),
    );
  }
}
