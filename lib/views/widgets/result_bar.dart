import 'package:flutter/material.dart';
import 'package:maze_search_ai/providers/home_view_provider.dart';
import 'package:maze_search_ai/views/home-view.dart';
import 'package:provider/provider.dart';

class ResultBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Steps taken to find the path: ${context.watch<HomeViewProvider>().resultSteps.toString()}",
          ),
          Text(
            "Used search algorithm: ${getSelectedSearchAlgo(context)}",
          ),
        ],
      ),
    );
  }

  String getSelectedSearchAlgo(BuildContext context) {
    switch (context.watch<HomeViewProvider>().selectedSearchAlgo) {
      case SearchAlgo.dfs:
        return "Depth-First Search";
      case SearchAlgo.bfs:
        return "Breadth-First Search";
      case SearchAlgo.a:
        return "A*";
      case SearchAlgo.gbs:
        return "Greedy-Best Search";
    }
  }
}
