import 'package:tuple/tuple.dart';

class Node {
  final Tuple2<int, int> state;
  final String action;
  final Node parent;

  Node(this.state, {this.action, this.parent});
}

class StackFrontier {
  final List<Node> _frontier = [];

  void add(Node node) {
    _frontier.add(node);
  }

  bool containsState(Tuple2<int, int> state) {
    final Node node = _frontier.firstWhere(
      (node) => node.state == state,
      orElse: () => null,
    );
    return node != null;
  }

  bool isFrontierEmpty() {
    return _frontier.isEmpty;
  }

  Node remove() {
    if (isFrontierEmpty()) {
      throw Exception("empty frontier");
    } else {
      return _frontier.removeLast();
    }
  }
}

class QueueFrontier extends StackFrontier {
  @override
  Node remove() {
    if (isFrontierEmpty()) {
      throw Exception("empty frontier");
    } else {
      return _frontier.removeAt(0);
    }
  }
}

class GBFSFrontier extends StackFrontier {
  final Tuple2<int, int> end;

  GBFSFrontier(this.end);

  @override
  Node remove() {
    _frontier.sort((Node a, Node b) {
      final aColumnDeltaToEnd = a.state.item1 - end.item1;
      final bColumnDeltaToEnd = b.state.item1 - end.item1;
      final aRowDeltaToEnd = a.state.item2 - end.item2;
      final bRowDeltaToEnd = b.state.item2 - end.item2;

      final aManhattanNumber = aColumnDeltaToEnd.abs() + aRowDeltaToEnd.abs();
      final bManhattanNumber = bColumnDeltaToEnd.abs() + bRowDeltaToEnd.abs();

      return bManhattanNumber.compareTo(aManhattanNumber);
    });

    return _frontier.removeLast();
  }
}
