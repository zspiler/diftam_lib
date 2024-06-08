import 'policy.dart';
import 'node.dart';
import 'edge.dart';

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
  final Set<Node> visited = {};
  final List<Node> path = [];
  final List<List<Node>> cycles = [];

  void dfs(Node node) {
    visited.add(node);
    path.add(node);

    for (var neighbour in policy.getOutNeighbours(node, edgeType)) {
      if (path.contains(neighbour)) {
        final cycle =
            path.sublist(path.indexOf(neighbour)); // neighbour already in path! Cycle is from previous occurance to end..
        cycles.add(cycle);
      } else if (!visited.contains(neighbour)) {
        dfs(neighbour);
      }
    }

    path.remove(node);
  }

  for (var node in policy.nodes) {
    if (!visited.contains(node)) {
      dfs(node);
    }
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
