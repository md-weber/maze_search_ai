import 'package:tuple/tuple.dart';

class Node {
  final Tuple2<int, int> state;
  final String action;
  final Node parent;
  final int manhattanNumber;
  final int cost;

  Node(this.state, {this.action, this.parent, this.manhattanNumber, this.cost});
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
      return b.manhattanNumber.compareTo(a.manhattanNumber);
    });
    return _frontier.removeLast();
  }
}

class AStarFrontier extends StackFrontier {
  final Tuple2<int, int> end;

  AStarFrontier(this.end);

  @override
  Node remove() {
    _frontier.sort((Node a, Node b) {
      final aOverall = a.manhattanNumber + a.cost;
      final bOverall = b.manhattanNumber + b.cost;

      return bOverall.compareTo(aOverall);
    });
    return _frontier.removeLast();
  }
}

int calculateManhattanNumber(
  Tuple2<int, int> point,
  Tuple2<int, int> endPoint,
) {
  final aColumnDeltaToEnd = point.item1 - endPoint.item1;
  final aRowDeltaToEnd = point.item2 - endPoint.item2;
  return aColumnDeltaToEnd.abs() + aRowDeltaToEnd.abs();
}
