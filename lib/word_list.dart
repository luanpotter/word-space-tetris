import 'package:flutter/services.dart' show rootBundle;
import 'package:diacritic/diacritic.dart';

class WordList {
  static final Set<String> words = new Set();
  static final Map<String, double> frequencies = new Map();

  static bool _isUpperCase(String str) {
    return str == str.toUpperCase();
  }

  static Future<void> init(String lang) async {
    String wordData = await getFileData('assets/txt/words-$lang.txt');
    words.clear();
    words.addAll(wordData.split('\n').where((w) => w.length >= 3 && !w.contains('-') && !w.contains('.') && !_isUpperCase(w[0])).map(removeDiacritics));

    String letterData = await getFileData('assets/txt/letters-$lang.txt');
    frequencies.clear();
    letterData.split('\n').map((e) => e.split(';')).forEach((bits) => frequencies[bits[0].toLowerCase()] = double.parse(bits[1]) / 100.0);
  }

  static bool check(String a) {
    return words.contains(a);
  }

  static String nextLetter(double rand) {
    assert(rand >= 0);
    assert(rand <= 1);

    double current = 0;
    for (MapEntry<String, double> entry in frequencies.entries) {
      current += entry.value;
      if (rand <= current) {
        return entry.key;
      }
    }

    throw 'Invalid lettesr file, the percent values do not add up to 100%.';
  }

  static Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }
}
