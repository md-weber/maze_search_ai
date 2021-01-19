import 'package:flutter/cupertino.dart';
import 'package:maze_search_ai/controllers/search_controller.dart';
import 'package:maze_search_ai/views/home_view.dart';
import 'package:tuple/tuple.dart';

class HomeViewProvider extends ChangeNotifier {
  CellState _activeTool;

  List<List<CellState>> _grid = [];

  Tuple2<int, int> startPoint;
  Tuple2<int, int> endPoint;

  int _rows = 8;
  int _columns = 8;

  bool _delayed = false;
  SearchAlgo _selectedSearchAlgo = SearchAlgo.dfs;
  num _resultSteps = 0;
  Stopwatch _stopwatch;
  Duration _elapsedTime = const Duration();
  SearchController searchController;

  bool isSearchActive = false;

  HomeViewProvider({this.searchController}) {
    reCreateGrid();
  }

  void updateRows(int newRows) {
    _rows = newRows;
    reCreateGrid();
    notifyListeners();
  }

  void updateColumns(int newColumns) {
    _columns = newColumns;
    reCreateGrid();
    notifyListeners();
  }

  void startTimer() {
    _stopwatch = Stopwatch()..start();
  }

  void stopTimer() {
    _stopwatch.stop();
    _elapsedTime = _stopwatch.elapsed;
  }

  void updateResultSteps(num resultSteps) {
    _resultSteps = resultSteps;
    notifyListeners();
  }

  void updateActiveTool(CellState newTool) {
    _activeTool = newTool;
    notifyListeners();
  }

  void updateCell(Tuple2<int, int> cell, CellState newState) {
    _grid[cell.item1][cell.item2] = newState;
    notifyListeners();
  }

  void updateSearchAlgo(SearchAlgo algorithm) {
    _selectedSearchAlgo = algorithm;
    resetResults();
    notifyListeners();
  }

  void resetResults() {
    _resultSteps = 0;
    _elapsedTime = const Duration();

    for (var i = 0; i < grid.length; i++) {
      for (var j = 0; j < grid[i].length; j++) {
        final cell = grid[i][j];
        if (cell == CellState.solution || cell == CellState.visited) {
          grid[i][j] = CellState.path;
        }
      }
    }
  }

  void resetAll() {
    updateSearchActive(searchActive: false);
    reCreateGrid();

    endPoint = null;
    startPoint = null;

    _resultSteps = 0;
    _elapsedTime = const Duration();

    notifyListeners();
  }

  void toggleDelayed({bool isDelayed}) {
    _delayed = isDelayed;
    notifyListeners();
  }

  void reCreateGrid() {
    _grid = [];
    for (var columnIndex = 0; columnIndex < columns; columnIndex++) {
      _grid.add([]);
      for (var rowsIndex = 0; rowsIndex < rows; rowsIndex++) {
        _grid[columnIndex].add(CellState.path);
      }
    }
  }

  Future<void> startSearch() async {
    if (startPoint == null || endPoint == null) {
      // TODO: Fix in Issue 5
      return;
    }

    resetResults();
    startTimer();
    updateSearchActive(searchActive: true);

    await searchController.startSearch(
      _grid,
      this,
      activeAlgorithm: _selectedSearchAlgo,
      delayed: delayed,
    );

    stopTimer();
    updateSearchActive(searchActive: false);
  }

  CellState get activeTool => _activeTool;

  List<List<CellState>> get grid => _grid;

  SearchAlgo get selectedSearchAlgo => _selectedSearchAlgo;

  num get resultSteps => _resultSteps;

  Duration get elapsedTime => _elapsedTime;

  bool get delayed => _delayed;

  int get rows => _rows;

  int get columns => _columns;

  void updateSearchActive({bool searchActive}) {
    isSearchActive = searchActive;
    notifyListeners();
  }
}
