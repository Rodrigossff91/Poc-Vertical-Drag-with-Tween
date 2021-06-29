import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation<double>? _heightFactorAnimation;
  double heightFactors = 0.90;
  double expanded = 0.48;

  bool animationComplete = false;
  double screenHeight = 0;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    _heightFactorAnimation =
        Tween<double>(begin: heightFactors, end: expanded).animate(_controller);

    super.initState();
  }

  onBottomPartTap() {
    setState(() {
      if (animationComplete) {
        _controller.fling(velocity: 1);
      } else {
        _controller.fling(velocity: 1);
      }
      animationComplete = !animationComplete;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: AnimatedBuilder(
            animation: _controller,
            builder: (context, widget) {
              return getWidget();
            }));
  }

  _handleVerticalUpdate(DragUpdateDetails updateDatails) {
    double? fractionMoved = updateDatails.primaryDelta! / screenHeight;

    _controller.value = _controller.value - 5 * fractionMoved;
  }

  _handleVerticalEnd(DragEndDetails endDetails) {
    if (_controller.value >= 0.5) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  Widget getWidget() {
    return Stack(
      fit: StackFit.expand,
      children: [
        FractionallySizedBox(
          alignment: Alignment.topCenter,
          heightFactor: _heightFactorAnimation!.value,
          child: Container(),
        ),
        GestureDetector(
          onVerticalDragUpdate: _handleVerticalUpdate,
          onVerticalDragEnd: _handleVerticalEnd,
          onTap: onBottomPartTap,
          child: FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            heightFactor: 1.55 - _heightFactorAnimation!.value,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0))),
            ),
          ),
        ),
      ],
    );
  }
}
