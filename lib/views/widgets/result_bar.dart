import 'package:flutter/material.dart';
import 'package:maze_search_ai/providers/home_view_provider.dart';
import 'package:maze_search_ai/views/home_view.dart';
import 'package:provider/provider.dart';

class ResultBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeViewProvider = context.watch<HomeViewProvider>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Used search algorithm: ${getSelectedSearchAlgo(context)}",
          ),
          const SizedBox(height: 8),
          Text(
            "Steps taken to find the path: ${homeViewProvider.resultSteps.toString()}",
          ),
          const SizedBox(height: 8),
          Text(
            "Search duration: ${homeViewProvider.elapsedTime.inMicroseconds.toString()} μs",
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
      case SearchAlgo.gbfs:
        return "Greedy-Best Search";
      default:
        return "";
    }
  }
}
