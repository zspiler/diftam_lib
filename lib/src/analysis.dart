import 'policy.dart';

typedef GraphComponent = List<TagNode>;

List<GraphComponent> findComponents(Policy policy, EdgeType edgeType) {
  final Set<Node> visited = {};

  void dfs(TagNode node, List<TagNode> component) {
    if (visited.contains(node)) {
      return;
    }
    visited.add(node);
    component.add(node);
    for (var neighbour in policy.getNeighbours(node, edgeType).whereType<TagNode>()) {
      dfs(neighbour, component);
    }
  }

  final List<List<TagNode>> components = [];
  for (var node in policy.nodes.whereType<TagNode>()) {
    if (!visited.contains(node)) {
      List<TagNode> component = [];
      dfs(node, component);
      components.add(component);
    }
  }

  return components;
}

List<List<Node>> findCycles(Policy policy, EdgeType edgeType) {
  final List<List<Node>> cycles = [];
  final Map<Node, Node> parentMap = {};
  final Set<Node> visited = {};
  final Set<Node> finished = {};

  void dfs(Node node, List<Node> path) {
    if (visited.contains(node)) {
      if (!finished.contains(node)) {
        Node? current = node;
        List<Node> cycle = [current];

        while (true) {
          current = parentMap[current] != current ? parentMap[current] : null;
          if (current == null || current == node) {
            break;
          }
          cycle.add(current);
        }

        cycle.add(node);
        cycles.add(cycle.reversed.toList());
      }
      return;
    }

    if (finished.contains(node)) {
      return;
    }

    visited.add(node);
    path.add(node);

    for (var neighbour in policy.getOutNeighbours(node, edgeType)) {
      parentMap[neighbour] = node;
      dfs(neighbour, List<Node>.from(path));
    }

    path.remove(node);
    finished.add(node);
  }

  for (var node in policy.nodes) {
    dfs(node, []);
  }

  return cycles;
}

List<TagNode> findLoneTags(Policy policy) {
  final Set<Node> visited = {};

  void dfs(Node node) {
    if (visited.contains(node)) {
      return;
    }

    visited.add(node);

    for (var neighbour in policy.getOutNeighbours(node)) {
      dfs(neighbour);
    }
  }

  for (var node in policy.nodes) {
    if (node is EntryNode) {
      dfs(node);
    }
  }

  return policy.nodes.whereType<TagNode>().where((tag) => !visited.contains(tag)).toList();
}
