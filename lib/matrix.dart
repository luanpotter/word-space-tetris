import 'util.dart';
import 'word_list.dart';

import 'components/letter.dart';

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
  List<List<Letter>> matrix; // always [col][row]
  Set<_Point> _removeLater = new Set();

  Matrix() {
    matrix = List.generate(COLUMNS, (_) => List.generate(ROWS, (_) => null));
  }

  void set(int col, int row, Letter letter) {
    matrix[col][row] = letter;
    _checkWords(col, row);
  }

  void _award(int col, int row) {
    matrix[col][row].award();
    _removeLater.add(new _Point(col, row));
    matrix[col][row] = null;
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
    for (int i = r1; i <= r2; i++) {
      _award(col, i);
    }
  }

  void _hWordAward(int row, int c1, int c2) {
    for (int i = c1; i <= c2; i++) {
      _award(i, row);
    }
  }

  bool _check(String word) {
    return WordList.check(word);
  }

  void _checkWords(int col, int row) {
    _removeLater.clear();
    for (int i = col - 1; i >= 0; i--) {
      if (matrix[i][row] == null) {
        break;
      }
      if (_check(_hWord(row, i, col))) {
        _hWordAward(row, i, col);
      }
    }

    for (int i = col + 1; i < COLUMNS; i++) {
      if (matrix[i][row] == null) {
        break;
      }
      if (_check(_hWord(row, col, i))) {
        _hWordAward(row, col, i);
      }
    }

    for (int j = row - 1; j >= 0; j--) {
      if (matrix[col][j] == null) {
        break;
      }
      if (_check(_vWord(col, j, row))) {
        _vWordAward(col, j, row);
      }
    }

    for (int j = row + 1; j < ROWS; j++) {
      if (matrix[col][j] == null) {
        break;
      }
      if (_check(_vWord(col, row, j))) {
        _vWordAward(col, row, j);
      }
    }

    for (_Point p in _removeLater) {
      matrix[p.col][p.row] = null;
    }
  }
}
