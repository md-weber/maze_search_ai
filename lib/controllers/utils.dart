class Node {
  final int state;
  final String action;
  final Node parent;

  Node(this.state, {this.action, this.parent});
}

class StackFrontier {
  final List<Node> _frontier = [];

  void add(Node node) {
    _frontier.add(node);
  }

  bool containsState(int state) {
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
