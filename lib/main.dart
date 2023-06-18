import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

// https://bartvwezel.nl/flutter/drawing-and-rotating-arcs-in-flutter/

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double baseAngle = 0;
  double lastBaseAngle = 0;
  Offset? lastPosition;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent),
            borderRadius: const BorderRadius.all(Radius.circular(8.0))),
        child: CustomPaint(
          painter: ArcPainter(
              MediaQuery.of(context).size.width / 2,
              baseAngle,
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height),
          child: GestureDetector(
            onVerticalDragStart: (value) {
              setInitialState(value);
            },
            onVerticalDragUpdate: (value) {
              updateAngle(value);
            },
            onHorizontalDragStart: (value) {
              setInitialState(value);
            },
            onHorizontalDragUpdate: (value) {
              updateAngle(value);
            },
          ),
        ),
      ),
    );
  }

  void updateAngle(DragUpdateDetails value) {
    print(
        "MediaQuery.of(context).size.height: ${(MediaQuery.of(context).size.height) / 2}");
    print(
        "MediaQuery.of(context).size.width: ${(MediaQuery.of(context).size.width) / 2}");
    print("localPosition.dy:${value.localPosition.dy}");
    print("localPosition.dx:${value.localPosition.dx}");

    double result = math.atan2(
            value.localPosition.dy - (MediaQuery.of(context).size.height) / 2,
            value.localPosition.dx - (MediaQuery.of(context).size.width) / 2) -
        math.atan2(lastPosition!.dy - (MediaQuery.of(context).size.height) / 2,
            lastPosition!.dx - (MediaQuery.of(context).size.width) / 2);
    setState(() {
      baseAngle = lastBaseAngle + result;
    });
  }

  void setInitialState(DragStartDetails value) {
    lastPosition = value.localPosition;
    lastBaseAngle = baseAngle;
  }
}

class ArcPainter extends CustomPainter {
  final double radius;
  final double width;
  final double height;
  double baseAngle;
  final Paint red = createPaintForColor(Colors.red);
  final Paint blue = createPaintForColor(Colors.blue);
  final Paint green = createPaintForColor(Colors.green);
  final Paint purple = createPaintForColor(Colors.purple);
  final Paint yellow = createPaintForColor(Colors.yellow);
  final Paint black = createPaintForColor(Colors.black);
  final Paint orange = createPaintForColor(Colors.orange);
  final Paint greenAccent = createPaintForColor(Colors.greenAccent);
  final List<Paint> colors = [];

  ArcPainter(this.radius, this.baseAngle, this.width, this.height);

  @override
  void paint(Canvas canvas, Size size) {
    if (kDebugMode) {}
    Rect rect =
        Rect.fromCircle(center: Offset(width / 2, height / 2), radius: radius);
    colors.add(red);
    colors.add(blue);
    colors.add(green);
    colors.add(purple);
    colors.add(yellow);
    colors.add(black);
    colors.add(orange);
    colors.add(greenAccent);
    for (int i = 0; i < 8; i++) {
      canvas.drawArc(rect, baseAngle, sweepAngle(), true, colors[i]);
      baseAngle += sweepAngle();
    }

  }

  @override
  bool shouldRepaint(ArcPainter oldDelegate) {
    return oldDelegate.baseAngle != baseAngle;
  }

  double sweepAngle() => 2 * math.pi / 8;
}

Paint createPaintForColor(Color color) {
  return Paint()
    ..color = color
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.fill
    ..strokeWidth = 15;
}
