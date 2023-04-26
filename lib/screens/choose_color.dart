import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/api_service/cnfrmAndColor_api.dart';
import '../exports.dart';

class ChooseColor extends StatelessWidget {
  ChooseColor({Key? key}) : super(key: key);

  final confrmAndColorController = Get.put(CnfrmAndColorController());

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
    ));
  }

  AlertDialog buildAlertDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // contentPadding: EdgeInsets.only(top: 61, left: 50, right: 50, bottom: 50),
      content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            top(context),
            verticalHeight(height: 36),
            Text(
              "Choose Game Timing type",
              style: black50014,
            ),
            verticalHeight(height: 15),
            Row(
              children: [
                Text(
                  "Name",
                  style: black50015,
                ),
                horizontalWidth(width: 40),
                Text(
                  "Timing",
                  style: black50015,
                )
              ],
            ),
            verticalHeight(height: 4),
            table(),
            verticalHeight(height: 35),
            Align(
                alignment: Alignment.center,
                child: button(
                  context,
                  "Next",
                  green,
                ))
          ]),
    );
  }

  Widget top(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Choose Color",
          style: black50014,
        ),
        Obx(() => Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black)),
              height: 40,
              width: 170,
              child: Row(children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    confrmAndColorController.selectedColorIndex.value = 1;
                    confrmAndColorController.selectedColor("Black");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          confrmAndColorController.selectedColorIndex.value == 1
                              ? grey
                              : null,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Black",
                      style: black50016,
                    ),
                  ),
                )),
                Container(
                  height: double.infinity,
                  width: 1,
                  child: null,
                  color: Colors.black,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      confrmAndColorController.selectedColorIndex.value = 2;
                      confrmAndColorController.selectedColor("White");
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color:
                            confrmAndColorController.selectedColorIndex.value ==
                                    2
                                ? grey
                                : null,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: Text(
                        "White",
                        style: black50016,
                      ),
                    ),
                  ),
                )
              ]),
            )),
      ],
    );
  }

  Widget table() {
    return Table(
      defaultColumnWidth: FixedColumnWidth(70),
      border: TableBorder(
          horizontalInside: BorderSide(
              width: 1, color: Colors.grey, style: BorderStyle.solid)),
      children: const [
        TableRow(children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text("Bullet"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text("1min"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text("1/1"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text("2/1"),
          )
        ]),
        TableRow(children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text("Blitz"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text("3min"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text("3/2"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text("5min"),
          )
        ]),
        TableRow(children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text("Rapis"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text("10min"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text("15/10"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text("30min"),
          )
        ]),
      ],
    );
  }

  MaterialButton button(BuildContext context, String name, Color color) =>
      MaterialButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => StartGame()));
        },
        height: 40,
        minWidth: 110,
        color: color,
        child: Text(
          name,
          style: white50016,
        ),
      );
}
