import 'package:flutter/cupertino.dart';
import 'package:maze_search_ai/views/home-view.dart';

class HomeViewProvider extends ChangeNotifier {
  CellState _activeTool;
  List<CellState> _cells = [];
  SearchAlgo _selectedSearchAlgo = SearchAlgo.dfs;

  HomeViewProvider() {
    for (var i = 0; i < 64; i++) {
      cells.add(CellState.path);
    }
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
    notifyListeners();
  }

  CellState get activeTool => this._activeTool;

  List<CellState> get cells => this._cells;

  SearchAlgo get selectedSearchAlgo => this._selectedSearchAlgo;
}
