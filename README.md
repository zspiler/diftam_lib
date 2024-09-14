# D2SC Policy

A simple Dart library for creating and managing D2SC security policies,
which are essentially directed graphs.

The library is used in `D2SC-editor` which is a Flutter app for visualizing and editing D2SC security policies.

## TLDR

`policy.dart` - `Policy` class which represents a D2SC security policy.
`edge.dart` - `Edge` class (threre are 3 types of edges)
`node.dart` - node classes (there are 3 types of nodes)
`analysis.dart` - functions for analyzing a single policy / graph (eg. finding cycles)
`product.dart` - functions for combining policies 


## Example

```dart
// Create nodes
final stdin = EntryNode('stdin');
final priv = TagNode('priv');
final pub = TagNode('priv', Point(200, 200));
final stdout = ExitNode('stdout');

// Create edges
final stdinToPriv = Edge(stdin, priv, EdgeType.boundary);
final privToPub = Edge(priv, pub, EdgeType.oblivious);
final pubToStdout = Edge(pub, stdout, EdgeType.boundary);

// Create policy
final policy = Policy(
  name: 'My policy', 
  nodes: [priv, pub, stdin, stdout],
  edges: [stdinToPriv, privToPub, pubToStdout]
);

// Modify policy
policy.name = 'Moja politika';
pub.position = Point(300, 300);
policy.edges.add(Edge(pub, priv, EdgeType.oblivious));

// Combine policies
final newPolicy = tensorProduct(policy, otherPolicy);

// Perform analysis of policy
final results = findComponents(policy, EdgeType.aware);
```