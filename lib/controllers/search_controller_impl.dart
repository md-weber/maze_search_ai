import 'package:maze_search_ai/controllers/search_controller.dart';
import 'package:maze_search_ai/controllers/utils.dart';
import 'package:maze_search_ai/providers/home_view_provider.dart';
import 'package:maze_search_ai/views/home_view.dart';
import 'package:tuple/tuple.dart';

class SearchControllerImplementation implements SearchController {
  int start;
  int end;
  List<num> allWalls = [];
  List<num> allPaths = [];

  @override
  Tuple3<List<String>, List<num>, num> startA(List<CellState> cells) {
    // TODO: implement startA
    throw UnimplementedError();
  }

  @override
  Tuple3<List<String>, List<num>, num> startBFS(List<CellState> cells) {
    // TODO: implement startBFS
    throw UnimplementedError();
  }

  @override
  Future<Tuple3<List<String>, List<num>, num>> startSearch(
    List<CellState> cells,
    HomeViewProvider provider, {
    bool deepFirstSearch,
    bool delayed,
  }) async {
    getMazeInformation(cells);

    // Here our search starts
    num exploredTiles = 0;

    final Node startNode = Node(start);
    final StackFrontier frontier =
        deepFirstSearch ? StackFrontier() : QueueFrontier();
    frontier.add(startNode);

    final Set<num> explored = {};

    while (true) {
      if (frontier.isFrontierEmpty()) {
        throw Exception("There is no solution");
      }

      Node node = frontier.remove();

      // Showing the visited tiles - ignoring the first
      if (exploredTiles != 0) {
        provider.updateCell(node.state, CellState.visited);
        if (delayed) {
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }

      exploredTiles++;
      provider.updateResultSteps(exploredTiles);

      if (node.state == end) {
        final List<String> actions = [];
        final List<int> cells = [];
        while (node.parent != null) {
          provider.updateCell(node.state, CellState.solution);
          actions.add(node.action);
          cells.add(node.state);
          node = node.parent;
        }
        provider.updateCell(cells.first, CellState.end);

        actions.reversed;
        cells.reversed;
        return Tuple3<List<String>, List<num>, num>(
            actions, cells, exploredTiles);
      }

      explored.add(node.state);

      for (final entry in _neighbors(cells, node.state).entries) {
        if (!explored.contains(entry.value) &&
            !frontier.containsState(entry.value)) {
          final childNode = Node(entry.value, action: entry.key, parent: node);
          frontier.add(childNode);
        }
      }
    }
  }

  void getMazeInformation(List<CellState> cells) {
    start = cells.indexOf(CellState.start);
    end = cells.indexOf(CellState.end);

    if (start == -1 || end == -1) {
      throw ArgumentError("It needs a start or end position");
    }

    cells.asMap().forEach((index, element) {
      switch (element) {
        case CellState.wall:
          allWalls.add(index);
          break;
        case CellState.path:
          allPaths.add(index);
          break;
        case CellState.start:
        case CellState.end:
          break;
        case CellState.visited:
        case CellState.solution:
      }
    });
  }

  @override
  Tuple3<List<String>, List<num>, num> startGBS(List<CellState> cells) {
    // TODO: implement startGBS
    throw UnimplementedError();
  }

  // TODO: Change to a more dynamic way
  Map<String, int> _neighbors(List<CellState> cells, int state) {
    final Map<String, int> result = {
      "up": state - 8,
      "down": state + 8,
      "left": state % 8 == 0 ? -1 : state - 1,
      "right": state % 8 == 7 ? -1 : state + 1
    };

    result.removeWhere((key, value) {
      return value < 0 || value > 63 || cells[value] == CellState.wall;
    });

    return result;
  }
}
