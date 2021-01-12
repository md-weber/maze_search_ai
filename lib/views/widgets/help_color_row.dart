import 'package:flutter/material.dart';

class HelpColorRow extends StatelessWidget {
  final Color color;
  final String helpText;

  const HelpColorRow({Key key, this.color, this.helpText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 50,
          width: 50,
          color: color,
        ),
        SizedBox(width: 16),
        Text(helpText)
      ],
    );
  }
}
