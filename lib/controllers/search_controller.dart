import 'package:maze_search_ai/controllers/utils.dart';
import 'package:maze_search_ai/providers/home_view_provider.dart';
import 'package:maze_search_ai/views/home_view.dart';
import 'package:tuple/tuple.dart';

class SearchController {
  List<Tuple2<int, int>> allWalls = [];
  List<Tuple2<int, int>> allPaths = [];

  Future<Tuple3<List<String>, List<Tuple2<int, int>>, num>> startSearch(
    List<List<CellState>> grid,
    HomeViewProvider provider, {
    SearchAlgo activeAlgorithm,
    bool delayed,
  }) async {
    getMazeInformation(grid, provider);

    // Here our search starts
    int exploredTiles = 0;

    final Node startNode = Node(provider.startPoint);
    StackFrontier frontier;

    if (activeAlgorithm == SearchAlgo.dfs) {
      frontier = StackFrontier();
    } else if (activeAlgorithm == SearchAlgo.bfs) {
      frontier = QueueFrontier();
    }

    frontier.add(startNode);

    final Set<Tuple2<int, int>> explored = {};

    while (provider.isSearchActive) {
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

      if (node.state == provider.endPoint) {
        final List<String> actions = [];
        final List<Tuple2<int, int>> cells = [];
        while (node.parent != null) {
          provider.updateCell(node.state, CellState.solution);
          actions.add(node.action);
          cells.add(node.state);
          node = node.parent;
        }
        provider.updateCell(cells.first, CellState.end);

        actions.reversed;
        cells.reversed;
        return Tuple3<List<String>, List<Tuple2<int, int>>, num>(
            actions, cells, exploredTiles);
      }

      explored.add(node.state);

      for (final entry
          in _neighbors(grid, node.state, provider.columns, provider.rows)
              .entries) {
        if (!explored.contains(entry.value) &&
            !frontier.containsState(entry.value)) {
          final childNode = Node(entry.value, action: entry.key, parent: node);
          frontier.add(childNode);
        }
      }
    }
    return null;
  }

  void getMazeInformation(
      List<List<CellState>> grid, HomeViewProvider provider) {
    if (provider.startPoint == null || provider.endPoint == null) {
      throw ArgumentError("It needs a start or end position");
    }

    for (var column = 0; column < grid.length; column++) {
      for (var row = 0; row < grid[column].length; row++) {
        switch (grid[column][row]) {
          case CellState.wall:
            allWalls.add(Tuple2(column, row));
            break;
          case CellState.path:
            allPaths.add(Tuple2(column, row));
            break;
          case CellState.start:
          case CellState.end:
          case CellState.visited:
          case CellState.solution:
        }
      }
    }
  }

  Map<String, Tuple2<int, int>> _neighbors(List<List<CellState>> grid,
      Tuple2<int, int> state, int columnAmount, int rowAmount) {
    final Map<String, Tuple2<int, int>> result = {
      "up": Tuple2(state.item1, state.item2 - 1),
      "down": Tuple2(state.item1, state.item2 + 1),
      "left": Tuple2(state.item1 - 1, state.item2),
      "right": Tuple2(state.item1 + 1, state.item2)
    };

    result.removeWhere((key, value) {
      return value.item1 == -1 ||
          value.item2 == -1 ||
          value.item1 > columnAmount - 1 ||
          value.item2 > rowAmount - 1 ||
          grid[value.item1][value.item2] == CellState.wall;
    });

    return result;
  }
}
