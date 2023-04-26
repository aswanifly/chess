import 'package:flutter/material.dart';

class WaveLoader extends StatelessWidget {
  const WaveLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Wave(index: 20, color: Colors.amber),
            Wave(index: 17, color: Colors.orange),
            Wave(index: 14, color: Colors.pink),
            Wave(index: 11, color: Colors.red),
            Wave(index: 8, color: Colors.purple),
            Wave(index: 5, color: Colors.amber),
            Wave(index: 2, color: Colors.orange),
            Wave(index: 2, color: Colors.pink),
            Wave(index: 5, color: Colors.red),
            Wave(index: 8, color: Colors.purple),
            Wave(index: 11, color: Colors.amber),
            Wave(index: 14, color: Colors.orange),
            Wave(index: 17, color: Colors.pink),
            Wave(index: 20, color: Colors.red),
            Wave(index: 23, color: Colors.purple),
          ]),
        ),
      ),
    );
  }
}

class Wave extends StatefulWidget {
  final int index;
  final Color color;

  const Wave({Key? key, required this.index, required this.color})
      : super(key: key);

  @override
  State<Wave> createState() => _WaveState();
}

class _WaveState extends State<Wave> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));

    _scaleAnimation = Tween<double>(begin: 2.0, end: 40.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    Future.delayed(Duration(milliseconds: widget.index * 80), () {
      _animationController.forward();
    });

    _animationController.addListener(() {
      if (_animationController.isCompleted) {
        _animationController.reverse();
      } else if (_animationController.isDismissed) {
        _animationController.forward();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Container(
              height: _scaleAnimation.value,
              width: 5.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: widget.color,
              ),
            );
          }),
    );
  }
}
