import 'node.dart';
import 'edge.dart';

class Policy {
  late String name;
  late final List<Node> nodes;
  late final List<Edge> edges;

  Policy({required this.name, List<Node>? nodes, List<Edge>? edges})
      : nodes = nodes ?? [],
        edges = edges ?? [];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nodes': nodes.map((node) => node.toJson()).toList(),
      'edges': edges.map((edge) => edge.toJson()).toList(),
    };
  }

  Policy.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nodes = json['nodes'].map<Node>((node) {
      if (node['type'] == NodeType.tag.value) {
        return TagNode.fromJson(node);
      }

      if (node['type'] == NodeType.entry.value) {
        return EntryNode.fromJson(node);
      }

      if (node['type'] == NodeType.exit.value) {
        return ExitNode.fromJson(node);
      }
      throw ArgumentError('Unknown node type: ${node['type']}');
    }).toList();
    edges = json['edges'].map<Edge>((edge) => Edge.fromJson(edge, nodes)).toList();
  }

  static List<String> validateEdges(List<Edge> edges) {
    final List<String> errors = [];

    final numOfEdgesPerEntryNode = edges.fold<Map<EntryNode, int>>({}, (map, edge) {
      if (edge.source is EntryNode) {
        final entryNode = edge.source as EntryNode;
        map[entryNode] = (map[entryNode] ?? 0) + 1;
      }
      return map;
    });

    if (numOfEdgesPerEntryNode.values.any((numOfEdges) => numOfEdges > 1)) {
      errors.add("An 'Entry' node can only have one outgoing edge!");
    }

    return errors;
  }

  List<Node> getOutNeighbours(Node node, [EdgeType? edgeType]) {
    return edges
        .where((edge) => (edgeType == null || edge.type == edgeType) && edge.source == node)
        .map((edge) => edge.target)
        .toList();
  }

  List<Node> getInNeighbours(Node node, [EdgeType? edgeType]) {
    return edges
        .where((edge) => (edgeType == null || edge.type == edgeType) && edge.target == node)
        .map((edge) => edge.source)
        .toList();
  }

  List<Node> getNeighbours(Node node, [EdgeType? edgeType]) {
    return [
      ...getOutNeighbours(node, edgeType),
      ...getInNeighbours(node, edgeType),
    ];
  }
}
