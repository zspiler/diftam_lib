import 'policy.dart';

typedef _CombinedNode = ({Node parent1, Node parent2, NodeType type});
typedef _CombinedEdge = ({_CombinedNode source, _CombinedNode destination, EdgeType type});

/*
Tensor product
vertices (g, h) and (g', h') are adjacent in G x H if
  g is adjacent to g' in G, AND
  h is adjacent to h' in H.
 */
Policy tensorProduct(Policy policy1, Policy policy2) {
  List<_CombinedEdge> combineEdges(Policy policy1, Policy policy2, List<_CombinedNode> combinedNodes) {
    List<_CombinedEdge> newEdges = [];
    for (var node1 in combinedNodes) {
      for (var node2 in combinedNodes) {
        // Parent1 of edge source must be connected to Parent2 of edge destination and vice versa.
        // We require that the edge type is the same. If we don't we'd have to prefer one edge type to another..
        for (var edge1 in policy1.edges) {
          if (edge1.source == node1.parent1 && edge1.target == node2.parent1) {
            for (var edge2 in policy2.edges) {
              if (edge2.source == node1.parent2 && edge2.target == node2.parent2 && edge2.type == edge1.type) {
                newEdges.add((source: node1, destination: node2, type: edge1.type));
              }
            }
          }
        }
      }
    }
    return newEdges;
  }

  final combinedNodes = cartesian(policy1.nodes, policy2.nodes)
      .where((pair) => pair.$1.runtimeType == pair.$2.runtimeType)
      .map((pair) => (parent1: pair.$1, parent2: pair.$2, type: pair.$1.type))
      .toList();
  final combinedEdges = combineEdges(policy1, policy2, combinedNodes);

  final nodes = _createNodesFromCombined(combinedNodes);
  final edges = _createEdgesFromCombined(combinedEdges, combinedNodes, nodes);

  return Policy(name: '${policy1.name} x ${policy2.name}', nodes: nodes, edges: edges);
}

/*
Cartesian product

two vertices (u,v) and (u' ,v' ) are adjacent in G x H if and only if
  u = u' and v is adjacent to v' in H, OR
  v = v' and u is adjacent to u' in G.
 */
Policy cartesianProduct(Policy policy1, Policy policy2) {
  List<_CombinedEdge> combineEdges(List<Edge> edges, List<_CombinedNode> combinedNodes, {bool compareFirstComponent = true}) {
    List<_CombinedEdge> combinedEdges = [];
    for (var edge in edges) {
      for (var combinedNode1 in combinedNodes) {
        for (var combinedNode2 in combinedNodes) {
          if (compareFirstComponent) {
            if (combinedNode1.parent2 != combinedNode2.parent2) {
              continue;
            }
          } else {
            if (combinedNode1.parent1 != combinedNode2.parent1) {
              continue;
            }
          }

          final comparedComponent1 = compareFirstComponent ? combinedNode1.parent1 : combinedNode1.parent2;
          final comparedComponent2 = compareFirstComponent ? combinedNode2.parent1 : combinedNode2.parent2;

          if (edge.source == comparedComponent1 && edge.target == comparedComponent2) {
            combinedEdges.add((source: combinedNode1, destination: combinedNode2, type: edge.type));
          } else if (edge.source == comparedComponent2 && edge.target == comparedComponent1) {
            combinedEdges.add((source: combinedNode2, destination: combinedNode1, type: edge.type));
          }
        }
      }
    }
    return combinedEdges;
  }

  final combinedNodes = cartesian(policy1.nodes, policy2.nodes)
      .where((pair) => pair.$1.runtimeType == pair.$2.runtimeType)
      .map((pair) => (parent1: pair.$1, parent2: pair.$2, type: pair.$1.type))
      .toList();

  final combinedEdges = [
    ...combineEdges(policy1.edges, combinedNodes, compareFirstComponent: true),
    ...combineEdges(policy2.edges, combinedNodes, compareFirstComponent: false)
  ];

  final nodes = _createNodesFromCombined(combinedNodes);
  final edges = _createEdgesFromCombined(combinedEdges, combinedNodes, nodes);

  return Policy(name: '${policy1.name} x ${policy2.name}', nodes: nodes, edges: edges);
}

// Helpers

List<Node> _createNodesFromCombined(List<_CombinedNode> combinedNodes) {
  return combinedNodes.map((node) {
    final label = node.parent1.label != node.parent2.label ? '${node.parent1.label}/${node.parent2.label}' : node.parent1.label;
    final position = node.parent1.position + node.parent2.position;
    return Node.fromType(node.type, label, position);
  }).toList();
}

List<Edge> _createEdgesFromCombined(List<_CombinedEdge> combinedEdges, List<_CombinedNode> combinedNodes, List<Node> nodes) {
  return combinedEdges.toSet().map((edge) {
    final sourceNode = nodes[combinedNodes.indexOf(edge.source)];
    final destinationNode = nodes[combinedNodes.indexOf(edge.destination)];
    return Edge(sourceNode, destinationNode, edge.type);
  }).toList();
}
