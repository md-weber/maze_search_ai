import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maze_search_ai/constants.dart';
import 'package:maze_search_ai/providers/home_view_provider.dart';
import 'package:maze_search_ai/views/widgets/cell.dart';
import 'package:maze_search_ai/views/widgets/grid_settings_widget.dart';
import 'package:maze_search_ai/views/widgets/help_dialog.dart';
import 'package:maze_search_ai/views/widgets/result_bar.dart';
import 'package:maze_search_ai/views/widgets/tool_bar.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

enum CellState { wall, path, start, end, visited, solution }
enum SearchAlgo { dfs, bfs, a, gbs }

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeViewProvider = context.watch<HomeViewProvider>();
    final activeTool = homeViewProvider.activeTool;
    final selectedSearchAlgo = homeViewProvider.selectedSearchAlgo;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Maze optimal path"),
        actions: [
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const HelpDialog(),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          ToolBar(),
          ResultBar(),
          GridSettingsWidget(),
          Expanded(
            flex: 8,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: homeViewProvider.columns <= 0
                        ? 1
                        : homeViewProvider.columns,
                  ),
                  itemCount: homeViewProvider.columns * homeViewProvider.rows,
                  itemBuilder: (context, index) {
                    final col = (index % homeViewProvider.columns).toInt();
                    final row = index ~/ homeViewProvider.columns;

                    return Cell(
                      type: homeViewProvider.grid[col][row],
                      onTap: () {
                        if (activeTool == CellState.end) {
                          clearPoint(
                            homeViewProvider.endPoint,
                            context.read<HomeViewProvider>(),
                          );

                          homeViewProvider.endPoint =
                              Tuple2.fromList([col, row]);
                        }

                        if (activeTool == CellState.start) {
                          clearPoint(
                            homeViewProvider.startPoint,
                            context.read<HomeViewProvider>(),
                          );

                          homeViewProvider.startPoint =
                              Tuple2.fromList([col, row]);
                        }

                        context
                            .read<HomeViewProvider>()
                            .updateCell(Tuple2(col, row), activeTool);
                      },
                    );
                  },
                )),
          ),
          Padding(
            padding: boxPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton(
                  items: const [
                    DropdownMenuItem(
                      value: SearchAlgo.dfs,
                      child: Text("Depth-First Search"),
                    ),
                    DropdownMenuItem(
                      value: SearchAlgo.bfs,
                      child: Text("Breadth-First Search"),
                    ),
                    DropdownMenuItem(
                      value: SearchAlgo.gbs,
                      child: Text("Greedy-Best Search"),
                    ),
                    DropdownMenuItem(
                      value: SearchAlgo.a,
                      child: Text("A*"),
                    )
                  ],
                  value: selectedSearchAlgo,
                  onChanged: (SearchAlgo value) {
                    context.read<HomeViewProvider>().updateSearchAlgo(value);
                    context
                        .read<HomeViewProvider>()
                        .updateSearchActive(searchActive: false);
                  },
                ),
                SizedBox(
                  width: 150,
                  child: CheckboxListTile(
                      title: const Text("delayed"),
                      value: homeViewProvider.delayed,
                      onChanged: (value) {
                        homeViewProvider.toggleDelayed(isDelayed: value);
                      }),
                ),
              ],
            ),
          ),
          Padding(
            padding: boxPadding,
            child: Row(
              children: [
                const Spacer(),
                Tooltip(
                  message: getTooltip(homeViewProvider),
                  child: ElevatedButton(
                    onPressed: homeViewProvider.checkForEndAndStartPoint
                        ? () async {
                            homeViewProvider.isSearchActive
                                ? context
                                    .read<HomeViewProvider>()
                                    .updateSearchActive(searchActive: false)
                                : await context
                                    .read<HomeViewProvider>()
                                    .startSearch();
                          }
                        : null,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                        (Set<MaterialState> states) {
                          return homeViewProvider.isSearchActive
                              ? const Color(0xFFFF0000)
                              : ThemeData().primaryColor;
                        },
                      ),
                    ),
                    child: Text(
                      homeViewProvider.isSearchActive
                          ? "Cancel Search"
                          : "Start Search",
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  String getTooltip(HomeViewProvider homeViewProvider) {
    if (homeViewProvider.isSearchActive) {
      return "";
    } else if (homeViewProvider.checkForEndAndStartPoint) {
      return "Start";
    } else {
      return "Add a missing Start or Endpoint";
    }
  }

  void clearPoint(Tuple2<int, int> point, HomeViewProvider homeViewProvider) {
    if (point != null) {
      homeViewProvider.updateCell(point, CellState.path);
    }
  }
}
