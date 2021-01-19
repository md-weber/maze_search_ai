import 'package:flutter/material.dart';
import 'package:maze_search_ai/views/home_view.dart';

class Cell extends StatelessWidget {
  final VoidCallback onTap;
  final CellState type;

  const Cell({@required this.onTap, @required this.type});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          color: getCellColor(type),
        ),
      ),
    );
  }

  Color getCellColor(CellState type) {
    switch (type) {
      case CellState.wall:
        return Colors.black;
      case CellState.path:
        return Colors.white;
      case CellState.start:
        return Colors.green;
      case CellState.visited:
        return Colors.yellow;
      case CellState.solution:
        return Colors.blue;
      case CellState.end:
        return Colors.red;
      default:
        return Colors.white;
    }
  }
}
