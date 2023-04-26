import 'package:flutter/material.dart';

import '../../exports.dart';

class OpponentProfile extends StatelessWidget {
  const OpponentProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                topBar(context),
                Divider(
                  thickness: 1,
                  color: Color(0xff545454),
                ),
                buildShowResult(),
                verticalHeight(height: 30),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Game History",
                        style: black50016,
                      ),
                      Text(
                        "Played with you 2 times",
                        style: black50012,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: SizedBox(
                    height: 80,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          CircleAvatar(
                            // backgroundColor: grey,
                            backgroundImage:
                                AssetImage("assets/svg/7309681.jpg"),
                          ),
                          horizontalWidth(width: 10),
                          Text(
                            "Name",
                            style: black50016,
                          ),
                          Spacer(),
                          Text(
                            "Won",
                            style: green50016,
                          ),
                          horizontalWidth(width: 10),
                          Icon(
                            Icons.check_circle_outline,
                            color: green,
                          )
                        ]),
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Row buildShowResult() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      winDrawLostButton("Wins : 5"),
      winDrawLostButton("Draws : 1"),
      winDrawLostButton("Lost : 2"),
    ]);
  }

  Container winDrawLostButton(String buttonName) {
    return Container(
      height: 35,
      width: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(color: violet),
          borderRadius: BorderRadius.circular(10)),
      child: Text(
        buttonName,
        style: black50014,
      ),
    );
  }

  Padding topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
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
                backgroundImage: AssetImage("assets/svg/7309667.jpg"),
              ),
              horizontalWidth(width: 10),
              Text(
                "Krishna",
                style: black50020,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
