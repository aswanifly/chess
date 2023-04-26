import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../controller/api_service/game_board_controller.dart';
import '../../exports.dart';

class MovementTracker extends StatelessWidget {
  MovementTracker({Key? key}) : super(key: key);

  final gameBoardController = Get.put(GameBoardController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(children: [
          topBar(context),
          Divider(
            height: 0,
            thickness: 1,
            indent: 0,
          ),
          gameSection(context),
          verticalHeight(height: 10),
          allMovementList(),
          verticalHeight(height: 50),
          Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customButton("Cancel", red, () {
                  print("object");
                }),
                horizontalWidth(width: 20),
                customButton("Confirm", green, () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => FinalResult()));
                }),
              ],
            ),
          )
        ]),
      ),
    ));
  }

  Widget allMovementList() {
    return Expanded(
      child: Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          color: grey,
          width: double.infinity,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: gameBoardController.moveList.length,
              itemBuilder: (_, i) {
                return Container(
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Color(0xffB0B0B0)))),
                  child: ListTile(
                    leading: SizedBox(
                      width: 160,
                      child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                        Text(
                          "${i + 1}. ${gameBoardController.moveList[i].playerMove}",
                          style: black40020,
                        ),
                        Text(
                          gameBoardController.moveList[i].moveTime,
                          style: black40018,
                        )
                      ]),
                    ),
                    trailing: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.delete,
                          size: 18,
                        )),
                  ),
                );
              })),
    );
  }

  Widget gameSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Time",
            style: black40020,
          ),
          Container(
            height: 40,
            width: 140,
            decoration: BoxDecoration(
              color: violet,
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.center,
            child: Text(gameBoardController.endTime.value,style: white50016),
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.share,
                color: Colors.black,
              ))
        ],
      ),
    );
  }

  Padding topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.arrow_back)),
              horizontalWidth(width: 10),
              CircleAvatar(
                // backgroundColor: Colors.grey,
                backgroundImage: AssetImage("assets/svg/7309681.jpg"),
              ),
              horizontalWidth(width: 8),
              Text(
                "Ram",
                style: black50015,
              ),
              Spacer(),
              Text(
                "vs",
                style: black50015,
              ),
              Spacer(),
              Text(
                "Krishna",
                style: black50015,
              ),
              horizontalWidth(width: 8),
              CircleAvatar(
                // backgroundColor: Colors.grey,
                backgroundImage: AssetImage("assets/svg/7309667.jpg"),
              ),
            ],
          ),
          verticalHeight(height: 8),
          Row(
            children: [
              SvgPicture.asset("assets/svg/blackKing.svg"),
              horizontalWidth(width: 13),
              Text(
                "12 points",
                style: violet50013,
              ),
              Spacer(),
              SvgPicture.asset("assets/svg/whiteKing.svg"),
              horizontalWidth(width: 13),
              Text(
                "10 points",
                style: violet50013,
              ),
            ],
          ),
        ],
      ),
    );
  }

  MaterialButton customButton(String name, Color color, Function()? ontap) =>
      MaterialButton(
        onPressed: ontap,
        height: 40,
        minWidth: 110,
        color: color,
        child: Text(
          name,
          style: white50016,
        ),
      );
}
