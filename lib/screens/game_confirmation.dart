import 'package:chess/controller/loading_cont/laoding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/api_service/cnfrmAndColor_api.dart';
import '../controller/api_service/login_signup_api.dart';
import '../exports.dart';
import '../models/all_users_details.dart';

class GameConfirmation extends StatelessWidget {
  final AllUsersDetails allUsersDetails;

  GameConfirmation({Key? key, required this.allUsersDetails}) : super(key: key);

  final loginSignCont = Get.put(LoginAndSignUp());
  final loadingController = Get.put(LoadingController());
  final gameConfirmationCont = Get.put(CnfrmAndColorController());

  acceptRequest() async {
    loadingController.isLoading(true);
    var data = await gameConfirmationCont.confirmRequest(allUsersDetails.userId!);
    loadingController.isLoading(false);
    print(data);
    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (_) => ChooseColor()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Stack(children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black45,
              child: null,
            ),
            buildAlertDialog(context),
          ]),
        ),
      ),
    );
  }

  AlertDialog buildAlertDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: EdgeInsets.only(top: 61, left: 50, right: 50, bottom: 50),
      content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                dpAndName(loginSignCont.userDetails!.userName,
                    "assets/svg/7309681.jpg"),
                dpAndName(allUsersDetails.userName!, "assets/svg/7309667.jpg")
              ],
            ),
            verticalHeight(height: 25),
            Text(
              "Accepted invitation of ${allUsersDetails.userName}",
              style: black50014,
            ),
            verticalHeight(height: 30),
            Row(
              children: [
                button("Cancel", red, () => Navigator.of(context).pop()),
                horizontalWidth(width: 15),
                Obx(
                  () => button(
                      loadingController.loading ? "Loading" : "Accept", green,
                      // acceptRequest,
                      () {
                    Get.to(ChooseColor());
                  }),
                ),
              ],
            )
          ]),
    );
  }

  MaterialButton button(String name, Color color, Function()? ontap) =>
      MaterialButton(
        onPressed: ontap,
        height: 40,
        minWidth: 90,
        color: color,
        child: Text(
          name,
          style: white50016,
        ),
      );

  Column dpAndName(String userName, String image) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.black45,
          radius: 40,
          backgroundImage: AssetImage(image),
        ),
        verticalHeight(height: 20),
        Text(
          userName,
          style: black50016,
        ),
      ],
    );
  }
}
