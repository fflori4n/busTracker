import 'dart:async';

import 'package:flutter/material.dart';

class SideNav extends StatefulWidget {
  @override
  SideNavState createState() => SideNavState();
}

class SideNavState extends State<SideNav>{
  final bool isSideBarOpen = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: isSideBarOpen ? 500 : 0,
      child: Row(
        children: <Widget>[
          Container(
            /*color: Colors.black12,
            child: Expanded(
              child: Column(
                children: <Widget>[
                  Text('opt1'),
                  Text('opt2'),
                  Text('opt3'),
                ],
              ),
            ),*/
          ),
          Container(
            width: 5,
            color: Colors.green,
          ),
          Container(
            width: 10,
          ),
        ],
      ),
    );
  }


}