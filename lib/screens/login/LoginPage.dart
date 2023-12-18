import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/color_const.dart';
import '../../routes/app_routes.dart';
import '../../theme/text_style.dart';
import '../../utils/db/db_utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 100.0),
              child: Center(
                child: SizedBox(
                    width: 200,
                    height: 150,
                    // child: Image.asset('assets/icons/png/ic_launcher.png')),
                    child: CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/f_detection.png'))),
              ),
            ),
            const Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id'),
              ),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            TextButton(
              onPressed: () {
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: const Text(
                'Forgot Password',
                style: TextStyle(color: ColorConst.primary, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: ColorConst.primary,
                  borderRadius: BorderRadius.circular(8)),
              child: TextButton(
                onPressed: () {
                  Get.toNamed(AppRoute.dashboard,arguments: {"user":LocalDatabase.getUser()});
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            GestureDetector(
                onTap: () => Get.toNamed(AppRoute.signup),
                child: Text(
                  'New User? Create Account',
                  style: AppTextStyle.boldBlackGrey18.copyWith(fontSize: 14),
                ))
          ],
        ),
      ),
    );
  }
}
