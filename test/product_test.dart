import 'package:diftam_lib/diftam_lib.dart';
import 'package:test/test.dart';

void main() {
  group('Products', () {
    group('Tensor', () {
      test('should generate correct tensor product', () {
        final policy1 = () {
          final stdin = EntryNode('stdin');
          final pub = TagNode('pub');
          final priv = TagNode('priv');

          final edges = [
            Edge(stdin, pub, EdgeType.boundary),
            Edge(pub, priv, EdgeType.aware),
            Edge(pub, pub, EdgeType.aware),
            Edge(priv, priv, EdgeType.aware),
          ];

          return Policy(name: 'Policy 1', nodes: [stdin, pub, priv], edges: edges);
        }();

        final policy2 = () {
          final stdin = EntryNode('stdin');
          final low = TagNode('low');
          final high = TagNode('high');

          final edges = [
            Edge(stdin, low, EdgeType.boundary),
            Edge(high, low, EdgeType.aware),
            Edge(low, low, EdgeType.aware),
            Edge(high, high, EdgeType.aware),
          ];

          return Policy(name: 'Policy 2', nodes: [stdin, low, high], edges: edges);
        }();

        final expectedProduct = {
          'name': 'Policy 1 x Policy 2',
          'nodes': [
            {
              'type': 'Entry',
              'position': {'x': 0.0, 'y': 0.0},
              'descriptor': 'stdin'
            },
            {
              'type': 'Tag',
              'position': {'x': 0.0, 'y': 0.0},
              'label': 'pub/low'
            },
            {
              'type': 'Tag',
              'position': {'x': 0.0, 'y': 0.0},
              'label': 'pub/high'
            },
            {
              'type': 'Tag',
              'position': {'x': 0.0, 'y': 0.0},
              'label': 'priv/low'
            },
            {
              'type': 'Tag',
              'position': {'x': 0.0, 'y': 0.0},
              'label': 'priv/high'
            }
          ],
          'edges': [
            {'source': 'stdin', 'target': 'pub/low', 'type': 'Boundary'},
            {'source': 'pub/low', 'target': 'pub/low', 'type': 'Aware'},
            {'source': 'pub/low', 'target': 'priv/low', 'type': 'Aware'},
            {'source': 'pub/high', 'target': 'pub/low', 'type': 'Aware'},
            {'source': 'pub/high', 'target': 'pub/high', 'type': 'Aware'},
            {'source': 'pub/high', 'target': 'priv/low', 'type': 'Aware'},
            {'source': 'pub/high', 'target': 'priv/high', 'type': 'Aware'},
            {'source': 'priv/low', 'target': 'priv/low', 'type': 'Aware'},
            {'source': 'priv/high', 'target': 'priv/low', 'type': 'Aware'},
            {'source': 'priv/high', 'target': 'priv/high', 'type': 'Aware'}
          ]
        };

        expect(tensorProduct(policy1, policy2).toJson(), expectedProduct);
      });

      test('should generate correct tensor product', () {
        final policy1 = () {
          final stdin = EntryNode('stdin');
          final pub = TagNode('pub');
          final priv = TagNode('priv');

          final edges = [
            Edge(stdin, pub, EdgeType.boundary),
            Edge(pub, priv, EdgeType.oblivious),
            Edge(pub, pub, EdgeType.aware),
            Edge(priv, priv, EdgeType.aware),
          ];

          return Policy(name: 'Policy 1', nodes: [stdin, pub, priv], edges: edges);
        }();

        final policy2 = () {
          final stdin = EntryNode('stdin');
          final low = TagNode('low');
          final high = TagNode('high');

          final edges = [
            Edge(stdin, low, EdgeType.boundary),
            Edge(high, low, EdgeType.aware),
            Edge(low, low, EdgeType.aware),
            Edge(high, high, EdgeType.aware),
          ];

          return Policy(name: 'Policy 2', nodes: [stdin, low, high], edges: edges);
        }();

        final expectedProduct = {
          'name': 'Policy 1 x Policy 2',
          'nodes': [
            {
              'type': 'Entry',
              'position': {'x': 0.0, 'y': 0.0},
              'descriptor': 'stdin'
            },
            {
              'type': 'Tag',
              'position': {'x': 0.0, 'y': 0.0},
              'label': 'pub/low'
            },
            {
              'type': 'Tag',
              'position': {'x': 0.0, 'y': 0.0},
              'label': 'pub/high'
            },
            {
              'type': 'Tag',
              'position': {'x': 0.0, 'y': 0.0},
              'label': 'priv/low'
            },
            {
              'type': 'Tag',
              'position': {'x': 0.0, 'y': 0.0},
              'label': 'priv/high'
            }
          ],
          'edges': [
            {'source': 'stdin', 'target': 'pub/low', 'type': 'Boundary'},
            {'source': 'pub/low', 'target': 'pub/low', 'type': 'Aware'},
            {'source': 'pub/high', 'target': 'pub/low', 'type': 'Aware'},
            {'source': 'pub/high', 'target': 'pub/high', 'type': 'Aware'},
            {'source': 'priv/low', 'target': 'priv/low', 'type': 'Aware'},
            {'source': 'priv/high', 'target': 'priv/low', 'type': 'Aware'},
            {'source': 'priv/high', 'target': 'priv/high', 'type': 'Aware'}
          ]
        };

        expect(tensorProduct(policy1, policy2).toJson(), expectedProduct);
      });
    });

    group('Cartesian', () {
      test('should generate correct cartesian product', () {
        final policy1 = () {
          final stdin = EntryNode('stdin');
          final pub = TagNode('pub');
          final priv = TagNode('priv');

          final edges = [
            Edge(stdin, pub, EdgeType.boundary),
            Edge(pub, priv, EdgeType.aware),
            Edge(pub, pub, EdgeType.aware),
            Edge(priv, priv, EdgeType.aware),
          ];

          return Policy(name: 'Policy 1', nodes: [stdin, pub, priv], edges: edges);
        }();

        final policy2 = () {
          final stdin = EntryNode('stdin');
          final low = TagNode('low');
          final high = TagNode('high');

          final edges = [
            Edge(stdin, low, EdgeType.boundary),
            Edge(high, low, EdgeType.aware),
            Edge(low, low, EdgeType.aware),
            Edge(high, high, EdgeType.aware),
          ];

          return Policy(name: 'Policy 2', nodes: [stdin, low, high], edges: edges);
        }();

        final expectedProduct = {
          'name': 'Policy 1 x Policy 2',
          'nodes': [
            {
              'type': 'Entry',
              'position': {'x': 0.0, 'y': 0.0},
              'descriptor': 'stdin'
            },
            {
              'type': 'Tag',
              'position': {'x': 0.0, 'y': 0.0},
              'label': 'pub/low'
            },
            {
              'type': 'Tag',
              'position': {'x': 0.0, 'y': 0.0},
              'label': 'pub/high'
            },
            {
              'type': 'Tag',
              'position': {'x': 0.0, 'y': 0.0},
              'label': 'priv/low'
            },
            {
              'type': 'Tag',
              'position': {'x': 0.0, 'y': 0.0},
              'label': 'priv/high'
            }
          ],
          'edges': [
            {'source': 'pub/low', 'target': 'priv/low', 'type': 'Aware'},
            {'source': 'pub/high', 'target': 'priv/high', 'type': 'Aware'},
            {'source': 'pub/low', 'target': 'pub/low', 'type': 'Aware'},
            {'source': 'pub/high', 'target': 'pub/high', 'type': 'Aware'},
            {'source': 'priv/low', 'target': 'priv/low', 'type': 'Aware'},
            {'source': 'priv/high', 'target': 'priv/high', 'type': 'Aware'},
            {'source': 'pub/high', 'target': 'pub/low', 'type': 'Aware'},
            {'source': 'priv/high', 'target': 'priv/low', 'type': 'Aware'}
          ]
        };

        expect(cartesianProduct(policy1, policy2).toJson(), expectedProduct);
      });

      test('should generate correct cartesian product', () {
        final policy1 = () {
          final stdin = EntryNode('stdin');
          final pub = TagNode('pub');
          final priv = TagNode('priv');

          final edges = [
            Edge(stdin, pub, EdgeType.boundary),
            Edge(pub, priv, EdgeType.oblivious),
            Edge(pub, pub, EdgeType.aware),
            Edge(priv, priv, EdgeType.aware),
          ];

          return Policy(name: 'Policy 1', nodes: [stdin, pub, priv], edges: edges);
        }();

        final policy2 = () {
          final stdin = EntryNode('stdin');
          final low = TagNode('low');
          final high = TagNode('high');

          final edges = [
            Edge(stdin, low, EdgeType.boundary),
            Edge(high, low, EdgeType.aware),
            Edge(low, low, EdgeType.aware),
            Edge(high, high, EdgeType.aware),
          ];

          return Policy(name: 'Policy 2', nodes: [stdin, low, high], edges: edges);
        }();

        final expectedProduct = {
          'name': 'Policy 1 x Policy 2',
          'nodes': [
            {
              'type': 'Entry',
              'position': {'x': 0.0, 'y': 0.0},
              'descriptor': 'stdin'
            },
            {
              'type': 'Tag',
              'position': {'x': 0.0, 'y': 0.0},
              'label': 'pub/low'
            },
            {
              'type': 'Tag',
              'position': {'x': 0.0, 'y': 0.0},
              'label': 'pub/high'
            },
            {
              'type': 'Tag',
              'position': {'x': 0.0, 'y': 0.0},
              'label': 'priv/low'
            },
            {
              'type': 'Tag',
              'position': {'x': 0.0, 'y': 0.0},
              'label': 'priv/high'
            }
          ],
          'edges': [
            {'source': 'pub/low', 'target': 'priv/low', 'type': 'Oblivious'},
            {'source': 'pub/high', 'target': 'priv/high', 'type': 'Oblivious'},
            {'source': 'pub/low', 'target': 'pub/low', 'type': 'Aware'},
            {'source': 'pub/high', 'target': 'pub/high', 'type': 'Aware'},
            {'source': 'priv/low', 'target': 'priv/low', 'type': 'Aware'},
            {'source': 'priv/high', 'target': 'priv/high', 'type': 'Aware'},
            {'source': 'pub/high', 'target': 'pub/low', 'type': 'Aware'},
            {'source': 'priv/high', 'target': 'priv/low', 'type': 'Aware'}
          ]
        };

        expect(cartesianProduct(policy1, policy2).toJson(), expectedProduct);
      });
    });
  });
}
