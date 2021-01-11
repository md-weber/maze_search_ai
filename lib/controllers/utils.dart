class Node {
  final num state;
  final String action;
  final Node parent;

  Node(this.state, {this.action, this.parent});
}

class StackFrontier {
  List<Node> _frontier = [];

  void add(Node node) {
    _frontier.add(node);
  }

  bool containsState(num state) {
    Node node = _frontier.firstWhere(
      (node) => node.state == state,
      orElse: () => null,
    );
    return node != null;
  }

  bool empty() {
    return _frontier.isEmpty;
  }

  Node remove() {
    if (this.empty()) {
      throw Exception("empty frontier");
    } else {
      return _frontier.removeLast();
    }
  }
}

class QueueFrontier extends StackFrontier {
  @override
  Node remove() {
    if (this.empty()) {
      throw Exception("empty frontier");
    } else {
      return _frontier.removeAt(0);
    }
  }
}
