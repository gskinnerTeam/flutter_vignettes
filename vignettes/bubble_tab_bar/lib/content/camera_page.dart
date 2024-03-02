import 'package:flutter/material.dart';

class CameraPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double fabSize = 90;
    //Main list content
    return Container(
      alignment: Alignment.bottomCenter,
      color: Colors.black,
      padding: EdgeInsets.only(bottom: 32),
      // Create a floating action button (FAB), with a circle inside of it
      // To size a FAB, nest it in a Container, wrapped in a SizedBox
      child: Container(
        width: fabSize,
        height: fabSize,
        child: SizedBox(
          child: FloatingActionButton(
            onPressed: () {},
            //Create circle inside our FAB
            child: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white30,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
