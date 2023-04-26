import 'dart:async';

import 'package:chess/controller/loading_cont/laoding_controller.dart';
import 'package:chess/models/user_detail_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controller/api_service/home_controller.dart';
import '../../controller/api_service/login_signup_api.dart';
import '../../controller/notification/push_notification.dart';
import '../../exports.dart';
import '../../models/all_users_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool selected = false;
  int? currentIndex;
  final homeController = Get.put(HomeController());
  final loginAndSignUp = Get.put(LoginAndSignUp());
  final loadingCont = Get.put(LoadingController());
  final pushNotification = Get.put(PushNotification());
  bool _isloading = false;
  final searchController = TextEditingController();
  List<AllUsersDetails> searchUser = [];


  getAllUsers() async {
    setState(() {
      _isloading = true;
    });
    await homeController.getAllUsers(loginAndSignUp.userDetails!.token);
    setState(() {
      _isloading = false;
    });
  }

  void runFilter(String query) {
    List<AllUsersDetails> results = [];
    if (query.isEmpty) {
      results = homeController.allUsers;
    } else {
      results = homeController.allUsers
          .where((e) => e.userName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {
      searchUser = results;
    });
  }


  @override
  void initState() {
    getAllUsers();
    pushNotification.saveToken();
    pushNotification.initInfo();
    searchUser = homeController.allUsers;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Do you want to go exit?'),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('No'),
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
      child: SafeArea(
        child: _isloading
            ? const Center(
                child: CircularProgressIndicator(
                  color: green,
                ),
              )
            : Scaffold(
                body: SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        profileAndName(),
                        verticalHeight(height: 23),
                        Text(
                          "Choose Player",
                          style: black50020,
                        ),
                        verticalHeight(height: 13),
                        TextField(
                          controller: searchController,
                          onChanged: (value) => runFilter(value),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {}, icon: Icon(Icons.search)),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              hintText: "Search name",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                        ),
                        Expanded(
                            child: ListView.builder(
                                itemCount: searchUser.length,
                                itemBuilder: (_, i) {
                                  AllUsersDetails allUsersDetails = searchUser[i];
                                  return buildPlayerCard(allUsersDetails, i);
                                })),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget buildPlayerCard(AllUsersDetails allUsersDetails, int i) {
    // print(userDetails.id);
    // print(homeController.friendRequestList);
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListTile(
        onTap: () {
          setState(() {
            currentIndex = i;
          });
        },
        selected: currentIndex == i ? !selected : selected,
        selectedColor: Colors.black,
        selectedTileColor: lightGrey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        leading: CircleAvatar(
          radius: 25,
          // backgroundColor: green,
          backgroundImage: AssetImage("assets/svg/7309681.jpg"),
        ),
        title: Text(allUsersDetails.userName!),
        trailing: Obx(
          () => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              homeController.friendRequestList.contains(allUsersDetails.userId!)
                  ? SizedBox()
                  : GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text("Send Request"),
                              actions: [
                                MaterialButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    }),
                                MaterialButton(
                                    child: Text("Send"),
                                    onPressed: () {
                                      homeController
                                          .sendFriendRequest(allUsersDetails.userId!)
                                          .then((value) {
                                        Navigator.of(context).pop();
                                        Get.showSnackbar(GetSnackBar(
                                          duration: Duration(seconds: 1),
                                          message: homeController.message.value,
                                        ));
                                      });
                                      print(allUsersDetails.userId!);
                                    }),
                              ],
                            );
                          },
                        );
                      },
                      child: SizedBox(
                          height: 20,
                          width: 18,
                          child: SvgPicture.asset(
                            "assets/svg/blackKing.svg",
                            fit: BoxFit.cover,
                          )),
                    ),
              horizontalWidth(width: 15),
              homeController.friendRequestList.contains(allUsersDetails.userId!)
                  ? Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => GameConfirmation(
                                        allUsersDetails: allUsersDetails,
                                      )));
                            },
                            icon: Icon(Icons.check_circle_outline,
                                color: Colors.black)),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.cancel_outlined,
                              color: Colors.black,
                            ))
                      ],
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileAndName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: green,
          radius: 40,
          backgroundImage: AssetImage("assets/svg/7309667.jpg"),
          // child: Image.asset("assets/svg/7309667.jpg"),
        ),
        horizontalWidth(width: 40),
        Text(
          "Welcome ${loginAndSignUp.userDetails!.userName}",
          style: black50024,
        )
      ],
    );
  }
}
