import 'package:maze_search_ai/providers/home_view_provider.dart';
import 'package:maze_search_ai/views/home_view.dart';
import 'package:tuple/tuple.dart';

abstract class SearchController {
  Future<Tuple3<List<String>, List<num>, num>> startSearch(
    List<CellState> cells,
    HomeViewProvider provider, {
    bool deepFirstSearch,
    bool delayed,
  });

  Tuple3<List<String>, List<num>, num> startBFS(List<CellState> cells);

  Tuple3<List<String>, List<num>, num> startGBS(List<CellState> cells);

  Tuple3<List<String>, List<num>, num> startA(List<CellState> cells);
}
