import 'package:flutter/services.dart' show rootBundle;

class WordList {
  static Set<String> words = new Set();

  static Future<void> init() async {
    String data = await getFileData('assets/txt/words.txt');
    words.addAll(data.split('\n').where((w) => w.length >= 3));
  }

  static bool check(String a) {
    return words.contains(a);
  }

  static Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }
}
