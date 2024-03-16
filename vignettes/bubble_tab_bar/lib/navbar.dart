import 'clipped_view.dart';
import 'navbar_button.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final ValueChanged<int> itemTapped;
  final int currentIndex;
  final List<NavBarItemData> items;

  const NavBar({required this.items, required this.itemTapped, this.currentIndex = 0});

  NavBarItemData? get selectedItem => currentIndex >= 0 && currentIndex < items.length ? items[currentIndex] : null;

  @override
  Widget build(BuildContext context) {
    //For each item in our list of data, create a NavBtn widget
    List<Widget> buttonWidgets = items.map((data) {
      //Create a button, and add the onTap listener
      return NavbarButton(data, data == selectedItem, onTap: () {
        //Get the index for the clicked data
        var index = items.indexOf(data);
        //Notify any listeners that we've been tapped, we rely on a parent widget to change our selectedIndex and redraw
        itemTapped(index);
      });
    }).toList();

    //Create a container with a row, and add our btn widgets into the row
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        //Add some drop-shadow to our navbar, use 2 for a slightly nicer effect
        boxShadow: [
          BoxShadow(blurRadius: 16, color: Colors.black12),
          BoxShadow(blurRadius: 24, color: Colors.black12),
        ],
      ),
      alignment: Alignment.center,
      height: 80,
      //Clip the row of widgets, to suppress any overflow errors that might occur during animation
      child: ClippedView(
        child: Row(
          //Center buttons horizontally
          mainAxisAlignment: MainAxisAlignment.center,
          // Inject a bunch of btn instances into our row
          children: buttonWidgets,
        ),
      ),
    );
  }
}

class NavBarItemData {
  final String title;
  final IconData icon;
  final Color selectedColor;
  final double width;

  NavBarItemData(this.title, this.icon, this.width, this.selectedColor);
}
