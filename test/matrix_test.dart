import 'package:test/test.dart';
import 'package:word_space_tetris/matrix.dart';
import 'package:word_space_tetris/word_list.dart';

class Notifier {
  List<String> events = [];

  void awake(MyLetter letter) {
    events.add('Awoken ${letter.letter}');
  }

  void award(MyLetter letter) {
    events.add('Awarded ${letter.letter}');
  }
}

class MyLetter implements ILetter {
  String letter;
  Notifier notifier;

  MyLetter(this.letter, {this.notifier});

  @override
  void awake() {
    notifier?.awake(this);
  }

  @override
  void award() {
    notifier?.award(this);
  }
}

void main() {
  setUp(() {
    WordList.words.clear();
    WordList.words.add('tea');
  });

  test('test simple word disappears', () {
    Matrix m = new Matrix();
    m.set(0, 0, new MyLetter('t'));
    expect(m.matrix[0][0].letter, 't');
    m.set(1, 0, new MyLetter('e'));
    expect(m.matrix[1][0].letter, 'e');
    m.set(2, 0, new MyLetter('a'));
    expect(m.matrix[0][0], null);
    expect(m.matrix[1][0], null);
    expect(m.matrix[2][0], null);
  });

  test('test proper awaking and awarding', () {
    Matrix m = new Matrix();
    Notifier n = new Notifier();
    var add = (int col, int row, String str) => m.set(col, row, new MyLetter(str, notifier: n));
    for (int i = 0; i <= 5; i++) {
      add(i, 0, 'x$i');
    }
    for (int i = 0; i <= 5; i++) {
      add(i, 2, 'y$i');
    }
    add(0, 1, 't');
    add(1, 1, 't');
    add(2, 1, 'e');
    add(4, 1, 't');

    expect(n.events.length, 0);
    add(3, 1, 'a');
    expect(n.events.length, 6);
    expect(
        n.events,
        containsAll([
          'Awarded t',
          'Awarded e',
          'Awarded a',
          'Awoken y1',
          'Awoken y2',
          'Awoken y3',
        ]));
  });
}
