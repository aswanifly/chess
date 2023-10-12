import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/api_service/login_signup_api.dart';
import '../../controller/loading_cont/laoding_controller.dart';
import '../../exports.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // bool isChecked = false;
  bool hidePassword = true;
  final loginSignupController = Get.put(LoginAndSignUpController());

  final loadingController = Get.put(LoadingController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  signUp() async {
    if (_formKey.currentState!.validate() && loginSignupController.tAndc) {
      loadingController.isLoading(true);
      try {
        await loginSignupController.signUp();
        if (loginSignupController.message.isNotEmpty) {
          Get.back();
          Get.showSnackbar(GetSnackBar(
            duration: Duration(seconds: 2),
            message: loginSignupController.message.value,
          ));
        }
      } catch (e) {
        var m = e as Map;
        Get.showSnackbar(GetSnackBar(
          duration: Duration(seconds: 2),
          message: "${e["message"]}",
        ));
      }
      loadingController.isLoading(false);
    }
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        return Stack(
          children: [
            Scaffold(
              // resizeToAvoidBottomInset: false,
              body: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(45.0),
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sign Up",
                            style: black60030,
                          ),
                          verticalHeight(height: 50.h),
                          Text(
                            "Email",
                            style: black50016,
                          ),
                          verticalHeight(height: 5.h),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter email";
                              } else if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                                return "enter proper email";
                              }
                              return null;
                            },
                            controller: loginSignupController.emailC.value,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15.w, vertical: 5.h),
                                hintText: "Email",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.r))),
                          ),
                          verticalHeight(height: 20.h),
                          Text(
                            "Username",
                            style: black50016,
                          ),
                          verticalHeight(height: 5.h),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your name";
                              }
                              return null;
                            },
                            controller: loginSignupController.nameC.value,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15.w, vertical: 5.h),
                                hintText: "Username",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.r))),
                          ),
                          verticalHeight(height: 20.h),
                          Text(
                            "Password",
                            style: black50016,
                          ),
                          verticalHeight(height: 5.h),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter password";
                              } else if (value.length < 6) {
                                return "Password must be more than 6";
                              }
                              return null;
                            },
                            obscureText: hidePassword,
                            controller: loginSignupController.passwordC.value,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hidePassword = !hidePassword;
                                      });
                                    },
                                    icon: hidePassword
                                        ? Icon(Icons.visibility_off)
                                        : Icon(Icons.visibility)),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15.w, vertical: 5.h),
                                hintText: "Password",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.r))),
                          ),
                          Row(
                            children: [
                              Checkbox(
                                  value: loginSignupController.tAndc,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.r)),
                                  onChanged: (value) {
                                    loginSignupController.tAndC(value!);
                                  }),
                              Text.rich(TextSpan(children: [
                                TextSpan(
                                    text: "I agree to the ", style: black30012),
                                TextSpan(
                                    text: "Terms and Conditions",
                                    style: black60012)
                              ])),
                            ],
                          ),
                          verticalHeight(height: 55.h),
                          MaterialButton(
                            onPressed: signUp,
                            color: green,
                            minWidth: double.infinity,
                            height: 50.h,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r)),
                            child: Text(
                              "Sign up",
                              style: white50024,
                            ),
                          ),
                          // verticalHeight(height: 20.h),
                          // Align(
                          //   alignment: Alignment.center,
                          //   child: Text(
                          //     "or",
                          //     style: black40016,
                          //   ),
                          // ),
                          // verticalHeight(height: 20.h),
                          // Align(
                          //   alignment: Alignment.center,
                          //   child: RichText(
                          //       text: TextSpan(children: [
                          //     TextSpan(text: "Log in with", style: black40016),
                          //     TextSpan(text: " Google", style: black50016)
                          //   ])),
                          // ),
                        ]),
                  ),
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
                        height: 80.h,
                        width: 80.w,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: Colors.black,
                        ),
                        child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,children:  [
                          Text("Loading",style: TextStyle(color: Colors.white),),
                          Padding(
                            padding: EdgeInsets.only(top: 13),
                            child: SizedBox(
                              height: 20.h,
                              width: 20.w,
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
        );
      }),
    );
  }
}
