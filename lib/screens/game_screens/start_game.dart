import 'package:chess/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StartGame extends StatefulWidget {
  const StartGame({Key? key}) : super(key: key);

  @override
  State<StartGame> createState() => _StartGameState();
}

class _StartGameState extends State<StartGame> {
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
            GameBoard(),
          ]),
        ),
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
                "John",
                style: black50015,
              ),
              Spacer(),
              Text(
                "vs",
                style: black50015,
              ),
              Spacer(),
              Text(
                "Virat",
                style: black50015,
              ),
              horizontalWidth(width: 8),
              CircleAvatar(
                backgroundImage: AssetImage("assets/svg/7309667.jpg"),
                // backgroundColor: Colors.grey,
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
}
