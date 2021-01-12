import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maze_search_ai/controllers/search_controller.dart';
import 'package:maze_search_ai/controllers/search_controller_impl.dart';
import 'package:maze_search_ai/providers/home_view_provider.dart';
import 'package:maze_search_ai/views/widgets/cell.dart';
import 'package:maze_search_ai/views/widgets/help_dialog.dart';
import 'package:maze_search_ai/views/widgets/result_bar.dart';
import 'package:maze_search_ai/views/widgets/tool_bar.dart';
import 'package:provider/provider.dart';

enum CellState { wall, path, start, end, visited, solution }
enum SearchAlgo { dfs, bfs, a, gbs }

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeViewProvider = context.watch<HomeViewProvider>();
    final delayed = homeViewProvider.delayed;
    final activeTool = homeViewProvider.activeTool;
    final cells = homeViewProvider.cells;
    final selectedSearchAlgo = homeViewProvider.selectedSearchAlgo;
    return Scaffold(
      appBar: AppBar(
        title: Text("Maze optimal path"),
        actions: [
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => HelpDialog(),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          ToolBar(),
          ResultBar(),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  SizedBox(
                    width: 150,
                    child: CheckboxListTile(
                        title: Text("delayed"),
                        value: homeViewProvider.delayed,
                        onChanged: (value) {
                          homeViewProvider.toggleDelayed(value);
                        }),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      SearchController searchController =
                          SearchControllerImplementation();
                      var homeViewProvider = context.read<HomeViewProvider>();
                      homeViewProvider.resetResults();

                      homeViewProvider.startTimer();

                      switch (selectedSearchAlgo) {
                        case SearchAlgo.dfs:
                          await searchController.startSearch(
                              cells, homeViewProvider,
                              deepFirstSearch: true, delayed: delayed);
                          break;
                        case SearchAlgo.bfs:
                          await searchController.startSearch(
                              cells, homeViewProvider,
                              deepFirstSearch: false, delayed: delayed);
                          break;
                        case SearchAlgo.a:
                          searchController.startA(cells);
                          break;
                        case SearchAlgo.gbs:
                          searchController.startGBS(cells);
                          break;
                      }
                      homeViewProvider.stopTimer();
                    },
                    child: Text("Start Search"),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void cleanOldStartingPoint(List<CellState> cells, CellState activeTool) {
    var oldStartingPoint = cells.indexOf(activeTool);

    if (oldStartingPoint > 0) {
      cells[oldStartingPoint] = CellState.path;
    }
  }
}
