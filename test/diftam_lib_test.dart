import 'package:diftam_lib/diftam_lib.dart';
import 'package:diftam_lib/src/exceptions.dart';
import 'package:test/test.dart';
import 'dart:math';

void main() {
  group('Demo', () {
    test('Creating a policy', () {
      final stdin = EntryNode('stdin');
      final priv = TagNode('priv');
      final pub = TagNode('priv', Point(200, 200));
      final stdout = ExitNode('stdout');

      // edges
      final stdinToPriv = Edge(stdin, priv, EdgeType.boundary);
      final privToPub = Edge(priv, pub, EdgeType.oblivious);
      final pubToStdout = Edge(pub, stdout, EdgeType.boundary);

      final policy = Policy(name: 'My policy', nodes: [priv, pub, stdin, stdout], edges: [stdinToPriv, privToPub, pubToStdout]);
    });
  });

  group('Policy', () {
    test('valid', () {
      final priv = TagNode('priv');
      final pub = TagNode('priv');
      final stdin = EntryNode('stdin');
      final stdout = ExitNode('stdout');

      Policy(name: 'Policy 1', nodes: [
        priv,
        pub,
        stdin,
        stdout
      ], edges: [
        Edge(stdin, priv, EdgeType.boundary),
        Edge(priv, pub, EdgeType.oblivious),
        Edge(priv, pub, EdgeType.aware),
      ]);
    });

    group('validateEdges', () {
      test('invalid - multiple edges from a entry node', () {
        final priv = TagNode('priv');
        final pub = TagNode('priv');
        final stdin = EntryNode('stdin');

        expect(
            () => Policy(name: 'Policy 1', nodes: [
                  priv,
                  pub,
                  stdin,
                ], edges: [
                  Edge(stdin, priv, EdgeType.boundary),
                  Edge(stdin, pub, EdgeType.boundary),
                ]),
            throwsA(TypeMatcher<PolicyValidationException>()));
      });
    });
  });

  group('Edge', () {
    final priv = TagNode('priv');
    final pub = TagNode('priv');
    final stdin = EntryNode('stdin');
    final stdout = ExitNode('stdout');

    test('validation', () {
      expect(() => Edge(stdin, priv, EdgeType.boundary), returnsNormally);
      expect(() => Edge(priv, stdout, EdgeType.boundary), returnsNormally);
      expect(() => Edge(priv, priv, EdgeType.aware), returnsNormally);

      expect(() => Edge(priv, pub, EdgeType.boundary), throwsArgumentError);
      expect(() => Edge(stdin, priv, EdgeType.aware), throwsArgumentError);
      expect(() => Edge(priv, stdout, EdgeType.aware), throwsArgumentError);
      expect(() => Edge(stdin, stdin, EdgeType.boundary), throwsArgumentError);
      expect(() => Edge(stdout, stdout, EdgeType.boundary), throwsArgumentError);
      expect(() => Edge(priv, stdin, EdgeType.boundary), throwsArgumentError);
      expect(() => Edge(stdout, priv, EdgeType.boundary), throwsArgumentError);
    });
  });

  group('serialization & deserialization', () {
    const Map<String, dynamic> exampleJson = {
      "name": "Policy 1",
      "nodes": [
        {
          "type": "Tag",
          "label": "priv",
          "position": {"x": 500.0, "y": 350.0}
        },
        {
          "type": "Tag",
          "label": "pub",
          "position": {"x": 700.0, "y": 350.0}
        },
        {
          "type": "Entry",
          "descriptor": "stdin",
          "position": {"x": 300.0, "y": 250.0}
        },
        {
          "type": "Exit",
          "descriptor": "stdout",
          "position": {"x": 900.0, "y": 250.0}
        }
      ],
      "edges": [
        {"source": "stdin", "target": "priv", "type": "Boundary"},
        {"source": "priv", "target": "pub", "type": "Oblivious"},
        {"source": "priv", "target": "pub", "type": "Aware"},
        {"source": "pub", "target": "pub", "type": "Aware"},
        {"source": "pub", "target": "pub", "type": "Oblivious"},
        {"source": "pub", "target": "priv", "type": "Aware"},
        {"source": "pub", "target": "stdout", "type": "Boundary"}
      ]
    };

    final priv = TagNode('priv', Point(500, 350));
    final pub = TagNode('pub', Point(700, 350));
    final stdin = EntryNode('stdin', Point(300, 250));
    final stdout = ExitNode('stdout', Point(900, 250));

    final examplePolicy = Policy(name: 'Policy 1', nodes: [
      priv,
      pub,
      stdin,
      stdout
    ], edges: [
      Edge(stdin, priv, EdgeType.boundary),
      Edge(priv, pub, EdgeType.oblivious),
      Edge(priv, pub, EdgeType.aware),
      Edge(pub, pub, EdgeType.aware),
      Edge(pub, pub, EdgeType.oblivious),
      Edge(pub, priv, EdgeType.aware),
      Edge(pub, stdout, EdgeType.boundary),
    ]);

    test('toJSON', () {
      const Map<String, dynamic> expectedJson = exampleJson;

      expect(examplePolicy.toJson(), expectedJson);
    });

    // TODO - how to test?
    // test('fromJSON', () {
    //   const json = exampleJson;
    //   final PolicyData policy = PolicyData.fromJson(json);
    // });
  });
}
