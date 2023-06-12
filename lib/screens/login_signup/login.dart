import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controller/api_service/login_signup_api.dart';
import '../../controller/loading_cont/laoding_controller.dart';
import '../../controller/notification/push_notification.dart';
import '../../exports.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isChecked = false;
  late StreamSubscription subscription;
  late ConnectivityResult result;
  var isConnected = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final loadingController = Get.put(LoadingController());
  bool hidePassword = true;
  final loginSignupController = Get.put(LoginAndSignUp());
  final pushNotificationController = Get.put(PushNotification());


  checkInternet() async {
    result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      isConnected = true;
    } else {
      isConnected = false;
      showDialogBox();
    }
    setState(() {});
  }

  startStream() {
    subscription = Connectivity().onConnectivityChanged.listen((event) async {
      checkInternet();
    });
  }

  @override
  void initState() {
    pushNotificationController.getToken();
    startStream();
    super.initState();
  }



  login() async {
    if (_formKey.currentState!.validate()) {
      loadingController.isLoading(true);
      try {
        await loginSignupController.login();
        if (loginSignupController.currentUserDetail != null) {
          pushNotificationController.saveToken();
          Get.offAll(HomeScreen());
        }
      } catch (e) {
        var m = e as Map;
        Get.showSnackbar(GetSnackBar(
          message: m["message"],
          duration: Duration(seconds: 2),
        ));
      }
      loadingController.isLoading(false);
      // if (loginSignupController.userDetails == null) {
      //   Get.showSnackbar(GetSnackBar(
      //     duration: Duration(seconds: 2),
      //     message: loginSignupController.message.value,
      //   ));
      //   return;
      // }
      // Get.offAll(() => HomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: null,

      ///
      child: Obx(() => Stack(
            children: [
              Scaffold(
                resizeToAvoidBottomInset: false,
                body: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(45.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "LOGIN",
                            style: black60030,
                          ),
                          verticalHeight(height: 10),
                          Text(
                            "Welcome Back",
                            style: black60012,
                          ),
                          verticalHeight(height: 50),
                          buildMiddle(),
                          verticalHeight(height: 55),
                          loginButton(),
                          verticalHeight(height: 20),
                          buildLastPart(context)
                        ]),
                  ),
                ),
              ),
              if (loadingController.loading)
                Material(
                  color: Colors.transparent,
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.black45,
                    child: Center(
                        child: Container(
                          height: 80,
                          width: 80,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black,
                          ),
                          child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,children: const [
                            Text("Loading",style: TextStyle(color: Colors.white),),
                            Padding(
                              padding: EdgeInsets.only(top: 13),
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(

                                  color: green,
                                ),
                              ),
                            ),
                          ]),
                        )),
                  ),
                )
            ],
          )),
    );
  }

  MaterialButton loginButton() {
    return MaterialButton(
      onPressed: login,
      color: green,
      minWidth: double.infinity,
      height: 50.h,
      child: Text(
        "Log in",
        style: white50024,
      ),
    );
  }

  Column buildLastPart(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            "or",
            style: black40016,
          ),
        ),
        // verticalHeight(height: 20),
        // Align(
        //   alignment: Alignment.center,
        //   child: RichText(
        //       text: TextSpan(children: [
        //     TextSpan(text: "Log in with", style: black40016),
        //     TextSpan(text: " Google", style: black50016)
        //   ])),
        // ),
        verticalHeight(height: 30.h),
        Align(
          alignment: Alignment.center,
          child: RichText(
              text: TextSpan(children: [
            TextSpan(text: "Don't have an account ?", style: black30012),
            TextSpan(
                text: " Sign Up",
                style: black60012,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    loginSignupController.textEditingControllers();
                    Get.to(()=>SignUp());
                  })
          ])),
        ),
      ],
    );
  }

  Column buildMiddle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Email",
          style: black50016,
        ),
        verticalHeight(height: 5.h),
        TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return "Please enter some Value";
            } else if (!RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value)) {
              return "Enter proper email";
            }
            return null;
          },
          controller: loginSignupController.emailC.value,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
              hintText: "Email",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15.r))),
        ),
        verticalHeight(height: 20.h),
        Text(
          "Password",
          style: black50016,
        ),
        verticalHeight(height: 5.h),
        TextFormField(
          obscureText: hidePassword,
          controller: loginSignupController.passwordC.value,
          validator: (value) {
            if (value!.isEmpty) {
              return "Please enter password";
            } else if (value.length < 6) {
              return "enter more than 6";
            }
            return null;
          },
          decoration: InputDecoration(
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                  icon: hidePassword
                      ? Icon(Icons.visibility_off)
                      : Icon(
                          Icons.remove_red_eye,
                          color: green,
                        )),
              contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
              hintText: "Password",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15.r))),
        ),
        // Row(
        //   children: [
        //     Obx(() => Checkbox(
        //         value: loginSignupController.rememberMe,
        //         shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(5)),
        //         onChanged: (value) {
        //           loginSignupController.toggleRememberMe(value!);
        //         })),
        //     Text("Remember"),
        //   ],
        // ),
      ],
    );
  }

  showDialogBox() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("No Internet"),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  checkInternet();
                },
                child: Text("Retry"),
              ),
            ],
          );
        });
  }
}
