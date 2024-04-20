import 'package:d2sc_policy/d2sc_policy.dart';
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
}
