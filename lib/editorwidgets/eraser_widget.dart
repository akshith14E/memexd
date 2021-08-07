import 'package:flutter/material.dart';
import 'package:memexd/constants/color_constants.dart';


var eraserSize = 50.0;
var eraserOpacity = 100.0;

class EraserWidget extends StatefulWidget {
  const EraserWidget({Key? key}) : super(key: key);

  @override
  _EraserWidgetState createState() => _EraserWidgetState();
}

class _EraserWidgetState extends State<EraserWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      height: MediaQuery.of(context).size.height * 0.35,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(35), topLeft: Radius.circular(35)),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(10,-10),
                blurRadius: 15.0,
                spreadRadius: 0.5
            )]
      ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Text('Opacity'),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Slider(
                    activeColor: kPrimaryColor,
                    value: eraserOpacity,
                    onChanged: (value) { setState(() {
                      eraserOpacity = value;
                    });},
                    min: 0,
                    max: 100,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Text('Eraser Size'),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Slider(
                    activeColor: kPrimaryColor,
                    value: eraserSize,
                    onChanged: (size) {setState(() {
                      eraserSize = size;
                    });},
                    min: 0,
                    max: 100,
                  ),
                )
              ],
            ),
          ],
        ),
    );
  }
}