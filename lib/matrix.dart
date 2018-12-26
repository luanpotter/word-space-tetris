import 'util.dart';
import 'word_list.dart';

abstract class ILetter {
  void award();
  void awake();
  String get letter;
}

class _Point {
  int col, row;

  _Point(this.col, this.row);

  int get hashCode => '$col.$row'.hashCode;

  operator ==(dynamic other) {
    if (!(other is _Point)) {
      return false;
    }
    return other.col == col && other.row == row;
  }
}

class Matrix {
  List<List<ILetter>> matrix; // always [col][row]
  Set<_Point> _removeLater = new Set();

  Matrix() {
    matrix = List.generate(COLUMNS, (_) => List.generate(ROWS, (_) => null));
  }

  void set(int col, int row, ILetter letter) {
    matrix[col][row] = letter;
    _checkWords(col, row);
  }

  void _award(int col, int row) {
    matrix[col][row].award();
    _removeLater.add(new _Point(col, row));
    for (int i = row + 1; i < ROWS; i++) {
      matrix[col][i]?.awake();
      _removeLater.add(new _Point(col, i));
    }
  }

  String _hWord(int row, int c1, int c2) {
    String word = '';
    for (int i = c1; i <= c2; i++) {
      word += matrix[i][row].letter;
    }
    return word;
  }

  String _vWord(int col, int r1, int r2) {
    String word = '';
    for (int i = r1; i <= r2; i++) {
      word += matrix[col][i].letter;
    }
    return word;
  }

  void _vWordAward(int col, int r1, int r2) {
    String word = '';
    for (int i = r1; i <= r2; i++) {
      word += matrix[col][i].letter;
      _award(col, i);
    }
    print('Awarding word "$word"');
  }

  void _hWordAward(int row, int c1, int c2) {
    String word = '';
    for (int i = c1; i <= c2; i++) {
      word += matrix[i][row].letter;
      _award(i, row);
    }
    print('Awarding word "$word"');
  }

  static String _reverse(String str) {
    return new String.fromCharCodes(str.runes.toList().reversed);
  }

  bool _check(String word) {
    return WordList.check(word) || WordList.check(_reverse(word));
  }

  void _checkWords(int col, int row) {
    _removeLater.clear();

    checkHorizontal(col, row);
    checkVertical(col, row);

    for (_Point p in _removeLater) {
      matrix[p.col][p.row] = null;
    }
  }

  void checkHorizontal(int col, int row) {
    int firstStart = 0;
    for (int i = col - 1; i >= 0; i--) {
      if (matrix[i][row] == null) {
        firstStart = i + 1;
        break;
      }
    }

    int firstEnd = col;
    for (int i = col + 1; i < COLUMNS; i++) {
      if (matrix[i][row] == null) {
        firstEnd = i - 1;
        break;
      }
    }

    for (int start = firstStart; start <= col; start++) {
      for (int end = start + 1; end <= firstEnd; end++) {
        if (_check(_hWord(row, start, end))) {
          _hWordAward(row, start, end);
        }
      }
    }
  }

  void checkVertical(int col, int row) {
    int firstStart = 0;
    for (int i = row - 1; i >= 0; i--) {
      if (matrix[col][i] == null) {
        firstStart = i + 1;
        break;
      }
    }

    int firstEnd = row;
    for (int i = row + 1; i < ROWS; i++) {
      if (matrix[col][i] == null) {
        firstEnd = i - 1;
        break;
      }
    }

    for (int start = firstStart; start <= col; start++) {
      for (int end = start + 1; end <= firstEnd; end++) {
        if (_check(_vWord(col, start, end))) {
          _vWordAward(col, start, end);
        }
      }
    }
  }
}
