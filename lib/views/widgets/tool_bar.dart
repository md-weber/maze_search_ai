import 'package:flutter/material.dart';
import 'package:maze_search_ai/providers/home_view_provider.dart';
import 'package:maze_search_ai/views/home-view.dart';
import 'package:provider/provider.dart';

class ToolBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          IconButton(
              icon: Icon(Icons.wallet_membership),
              tooltip: "Wall",
              onPressed: () {
                context
                    .read<HomeViewProvider>()
                    .updateActiveTool(CellState.wall);
              }),
          IconButton(
              icon: Icon(Icons.circle),
              tooltip: "Path",
              onPressed: () {
                context
                    .read<HomeViewProvider>()
                    .updateActiveTool(CellState.path);
              }),
          IconButton(
              icon: Icon(Icons.play_arrow),
              tooltip: "Start point",
              onPressed: () {
                context
                    .read<HomeViewProvider>()
                    .updateActiveTool(CellState.start);
              }),
          IconButton(
              icon: Icon(Icons.recommend),
              tooltip: "End point",
              onPressed: () {
                context
                    .read<HomeViewProvider>()
                    .updateActiveTool(CellState.end);
              }),
          const Spacer(),
          IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                context.read<HomeViewProvider>().resetAll();
              }),
        ],
      ),
    );
  }
}
