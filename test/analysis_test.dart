import 'package:diftam_lib/diftam_lib.dart';
import 'package:test/test.dart';

void main() {
  group('Policy analysis', () {
    test('findCycles', () {
      final stdin = EntryNode('stdin');
      final a = TagNode('a');
      final b = TagNode('b');
      final c = TagNode('c');
      final d = TagNode('d');
      final e = TagNode('e');
      final f = TagNode('f');

      final stdinA = Edge(stdin, a, EdgeType.boundary);
      final ab = Edge(a, b, EdgeType.aware);
      final bc = Edge(b, c, EdgeType.aware);
      final cd = Edge(c, d, EdgeType.aware);
      final db = Edge(d, b, EdgeType.aware);
      final be = Edge(b, e, EdgeType.aware);
      final ef = Edge(e, f, EdgeType.aware);
      final cc = Edge(c, c, EdgeType.oblivious);

      final policy = Policy(name: '', nodes: [a, b, c, d, e, f, stdin], edges: [stdinA, ab, bc, cd, db, be, ef, cc]);

      final awareCycles = findCycles(policy, EdgeType.aware);
      final obliviuosCycles = findCycles(policy, EdgeType.oblivious);

      expect(awareCycles, [
        [b, c, d]
      ]);
      expect(obliviuosCycles, [
        [c]
      ]);
    });

    test('findCycles - multiple cycles', () {
      final stdin = EntryNode('stdin');
      final a = TagNode('a');
      final b = TagNode('b');
      final c = TagNode('c');
      final d = TagNode('d');
      final e = TagNode('e');
      final f = TagNode('f');

      final stdinA = Edge(stdin, a, EdgeType.boundary);
      final ab = Edge(a, b, EdgeType.aware);
      final bc = Edge(b, c, EdgeType.aware);
      final cd = Edge(c, d, EdgeType.aware);
      final db = Edge(d, b, EdgeType.aware);
      final be = Edge(b, e, EdgeType.aware);
      final ef = Edge(e, f, EdgeType.aware);
      final fa = Edge(f, a, EdgeType.aware);
      final cc = Edge(c, c, EdgeType.oblivious);

      final policy = Policy(name: '', nodes: [
        a,
        b,
        c,
        d,
        e,
        f,
        stdin
      ], edges: [
        stdinA,
        ab,
        bc,
        cd,
        db,
        be,
        ef,
        fa,
        cc,
      ]);

      final awareCycles = findCycles(policy, EdgeType.aware);
      final obliviousCycles = findCycles(policy, EdgeType.oblivious);

      expect(
          awareCycles,
          containsAllInOrder([
            [b, c, d],
            [a, b, e, f],
          ]));
      expect(
          obliviousCycles,
          containsAllInOrder([
            [c],
          ]));
    });
  });
}
