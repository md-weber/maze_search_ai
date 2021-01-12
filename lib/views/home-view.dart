import 'package:flutter/material.dart';
import 'package:maze_search_ai/controllers/search_controller.dart';
import 'package:maze_search_ai/controllers/search_controller_impl.dart';
import 'package:maze_search_ai/providers/home_view_provider.dart';
import 'package:maze_search_ai/views/widgets/cell.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

enum CellState { wall, path, start, end, visited, solution }
enum SearchAlgo { dfs, bfs, a, gbs }

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeViewProvider = context.watch<HomeViewProvider>();
    final activeTool = homeViewProvider.activeTool;
    final cells = homeViewProvider.cells;
    final selectedSearchAlgo = homeViewProvider.selectedSearchAlgo;
    return Scaffold(
        appBar: AppBar(
          title: Text("Maze optimal path"),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 100,
              child: Row(
                children: [
                  IconButton(
                      icon: Icon(Icons.wallet_membership),
                      onPressed: () {
                        context
                            .read<HomeViewProvider>()
                            .updateActiveTool(CellState.wall);
                      }),
                  IconButton(
                      icon: Icon(Icons.circle),
                      onPressed: () {
                        context
                            .read<HomeViewProvider>()
                            .updateActiveTool(CellState.path);
                      }),
                  IconButton(
                      icon: Icon(Icons.play_arrow),
                      onPressed: () {
                        context
                            .read<HomeViewProvider>()
                            .updateActiveTool(CellState.start);
                      }),
                  IconButton(
                      icon: Icon(Icons.recommend),
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
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8),
                  itemCount: cells.length,
                  itemBuilder: (context, index) {
                    return Cell(
                      type: cells[index],
                      onTap: () {
                        if (activeTool == CellState.start ||
                            activeTool == CellState.end)
                          cleanOldStartingPoint(cells, activeTool);

                        context
                            .read<HomeViewProvider>()
                            .updateCell(index, activeTool);
                      },
                    );
                  },
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: Row(
                children: [
                  DropdownButton(
                    items: [
                      DropdownMenuItem(
                        child: Text("Depth-First Search"),
                        value: SearchAlgo.dfs,
                      ),
                      DropdownMenuItem(
                        child: Text("Breadth-First Search"),
                        value: SearchAlgo.bfs,
                      ),
                      DropdownMenuItem(
                        child: Text("Greedy-Best Search"),
                        value: SearchAlgo.gbs,
                      ),
                      DropdownMenuItem(
                        child: Text("A*"),
                        value: SearchAlgo.a,
                      )
                    ],
                    value: selectedSearchAlgo,
                    onChanged: (SearchAlgo value) {
                      context.read<HomeViewProvider>().updateSearchAlgo(value);
                    },
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      SearchController searchController =
                          SearchControllerImplementation();

                      switch (selectedSearchAlgo) {
                        case SearchAlgo.dfs:
                          Tuple3 dfsResult = await searchController.startSearch(
                              cells, context.read<HomeViewProvider>(), true);
                          print("Steps to solve: ${dfsResult.item3}");
                          print("Actions: ${dfsResult.item1}");
                          break;
                        case SearchAlgo.bfs:
                          Tuple3 dfsResult = await searchController.startSearch(
                              cells, context.read<HomeViewProvider>(), false);
                          print("Steps to solve: ${dfsResult.item3}");
                          print("Actions: ${dfsResult.item1}");
                          break;
                        case SearchAlgo.a:
                          searchController.startA(cells);
                          break;
                        case SearchAlgo.gbs:
                          searchController.startGBS(cells);
                          break;
                      }
                    },
                    child: Text("Start Search"),
                  )
                ],
              ),
            ))
          ],
        ));
  }

  void cleanOldStartingPoint(List<CellState> cells, CellState activeTool) {
    var oldStartingPoint = cells.indexOf(activeTool);

    if (oldStartingPoint > 0) {
      cells[oldStartingPoint] = CellState.path;
    }
  }
}
