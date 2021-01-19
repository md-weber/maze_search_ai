import 'package:flutter/material.dart';
import 'package:maze_search_ai/views/widgets/help_color_row.dart';

class HelpDialog extends StatelessWidget {
  const HelpDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Help"),
      content: Column(
        children: const [
          Text(
              "This application should help you to understand the search algorithms of the CS50 course of Harvard at edX. This course is for free 'Introduction to AI in Python'"),
          SizedBox(height: 15),
          HelpColorRow(color: Colors.green, helpText: "Start Point"),
          SizedBox(height: 15),
          HelpColorRow(color: Colors.red, helpText: "End Point"),
          SizedBox(height: 15),
          HelpColorRow(color: Colors.yellow, helpText: "Visited Tile"),
          SizedBox(height: 15),
          HelpColorRow(color: Colors.blue, helpText: "Path Solution"),
          SizedBox(height: 15),
          HelpColorRow(
              color: Colors.black, helpText: "A wall the path cannot cross")
        ],
      ),
    );
  }
}
