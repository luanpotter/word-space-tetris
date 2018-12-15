import 'util.dart';

class Matrix {
  List<String> matrix;

  Matrix() {
    matrix = List.filled(COLUMNS, '');
    matrix = matrix.map((s) => List.filled(COLUMNS, ' ').join('')).toList();
  }

  String _replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) + newChar + oldString.substring(index + 1);
  }

  void set(int col, int row, String char) {
    matrix[col] = _replaceCharAt(matrix[col], row, char);
  }
}