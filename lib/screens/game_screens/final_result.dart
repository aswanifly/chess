import 'package:chess/exports.dart';
import 'package:chess/screens/game_screens/opponent_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FinalResult extends StatelessWidget {
  const FinalResult({Key? key}) : super(key: key);

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
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: SizedBox(
                      child: Column(
                    children: [
                      // Divider(),
                      Text(
                        "WON",
                        style: green50024,
                      ),
                      resultCard(context, "Ram", "assets/svg/blackKing.svg",
                          "assets/svg/7309681.jpg"),
                      verticalHeight(height: 30),
                      resultCard(context, "Krishna", "assets/svg/whiteKing.svg",
                          "assets/svg/7309667.jpg")
                    ],
                  )),
                )
              ]),
        ),
      ),
    );
  }

  SizedBox resultCard(
      BuildContext context, String name, String kingImage, String image) {
    return SizedBox(
      child: Column(children: [
        Row(
          children: [
            CircleAvatar(
              // backgroundColor: grey,
              backgroundImage: AssetImage(image),
            ),
            horizontalWidth(width: 15),
            Text(
              name,
              style: black50020,
            ),
            horizontalWidth(width: 18),
            SvgPicture.asset(
              kingImage,
              height: 20,
              width: 18,
            ),
          ],
        ),
        verticalHeight(height: 22),
        Align(
          alignment: Alignment.centerLeft,
          child: MaterialButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => OpponentProfile()));
            },
            color: violet,
            padding: EdgeInsets.symmetric(horizontal: 60),
            child: Icon(
              Icons.play_arrow,
              color: Colors.white,
            ),
          ),
        ),
      ]),
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
              horizontalWidth(width: 50),
              Text(
                "Final Result",
                style: black50020,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
