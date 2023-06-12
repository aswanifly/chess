//ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/api_service/confirm_controller.dart';

class TimeTile extends StatelessWidget {
  final String title;
  final String secondPartOne;
  final String secondPartTwo;
  final String secondPartThree;
  final VoidCallback callback;
  final int index;

  TimeTile(
      {Key? key,
      required this.title,
      required this.secondPartOne,
      required this.secondPartTwo,
      required this.secondPartThree,
      required this.callback,
      required this.index})
      : super(key: key);

  ConfirmController confirmController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Obx(() => Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
          height: 30.h,
          width: double.infinity,
          color: confirmController.selectedTimingTile.value == index
              ? Colors.grey.shade300
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Text(title)),
              Expanded(
                flex: 2,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("$secondPartOne min"),
                      Text(secondPartTwo),
                      Text(secondPartThree)
                    ]),
              ),
            ],
          ))),
    );
  }
}
