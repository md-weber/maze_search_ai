import 'package:flutter/cupertino.dart';
import 'package:maze_search_ai/views/home-view.dart';

class HomeViewProvider extends ChangeNotifier {
  CellState _activeTool;
  List<CellState> _cells = [];
  bool _delayed = false;
  SearchAlgo _selectedSearchAlgo = SearchAlgo.dfs;
  num _resultSteps = 0;
  Stopwatch _stopwatch;
  Duration _elapsedTime = Duration();

  HomeViewProvider() {
    for (var i = 0; i < 64; i++) {
      cells.add(CellState.path);
    }
  }

  void startTimer() {
    _stopwatch = Stopwatch()..start();
  }

  void stopTimer() {
    _stopwatch..stop();
    _elapsedTime = _stopwatch.elapsed;
  }

  void updateResultSteps(num resultSteps) {
    _resultSteps = resultSteps;
    notifyListeners();
  }

  void updateActiveTool(CellState newTool) {
    this._activeTool = newTool;
    notifyListeners();
  }

  void updateCell(int index, CellState newState) {
    _cells[index] = newState;
    notifyListeners();
  }

  void updateSearchAlgo(SearchAlgo algorithm) {
    this._selectedSearchAlgo = algorithm;
    resetResults();
    notifyListeners();
  }

  void resetResults() {
    _resultSteps = 0;
    _elapsedTime = Duration();
    for (var cell in _cells) {
      if (cell == CellState.solution || cell == CellState.visited) {
        _cells[_cells.indexOf(cell)] = CellState.path;
      }
    }
  }

  void resetAll() {
    cells.clear();
    for (var i = 0; i < 64; i++) {
      cells.add(CellState.path);
    }

    _resultSteps = 0;
    _elapsedTime = Duration();

    notifyListeners();
  }

  void toggleDelayed(bool value) {
    _delayed = value;
    notifyListeners();
  }

  CellState get activeTool => _activeTool;

  List<CellState> get cells => _cells;

  SearchAlgo get selectedSearchAlgo => _selectedSearchAlgo;

  num get resultSteps => _resultSteps;

  Duration get elapsedTime => _elapsedTime;

  bool get delayed => _delayed;
}
