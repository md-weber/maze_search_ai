import 'package:flutter/cupertino.dart';
import 'package:maze_search_ai/views/home-view.dart';

class HomeViewProvider extends ChangeNotifier {
  CellState _activeTool;
  List<CellState> _cells = [];
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
    notifyListeners();
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

  CellState get activeTool => _activeTool;

  List<CellState> get cells => _cells;

  SearchAlgo get selectedSearchAlgo => _selectedSearchAlgo;

  num get resultSteps => _resultSteps;

  Duration get elapsedTime => _elapsedTime;
}
