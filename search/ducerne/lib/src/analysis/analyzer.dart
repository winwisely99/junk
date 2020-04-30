// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// An Analyzer builds tokens, which analyze text.
///
/// An Analyzer has [CharFilter]s, a [Tokenizer], and [TokenFilter]s.
abstract class Analyzer {
  List<CharFilter> charFilters = <CharFilter>[];
  Tokenizer tokenizer;
  List<TokenFilter> tokenFilters = <TokenFilter>[];
  Iterable<String> getTokens(String text) {
    String normalized = text;
    for (CharFilter charFilter in charFilters) {
      normalized = charFilter.normalize(normalized);
    }
    final Iterable<String> tokens = tokenizer.tokenize(normalized);
    Iterable<String> filteredTokens = tokens;
    for (TokenFilter tokenFilter in tokenFilters) {
      filteredTokens = tokenFilter.filter(filteredTokens);
    }
    return filteredTokens;
  }
}

/// A CharFilter normalizes text.
// ignore: one_member_abstracts
abstract class CharFilter {
  String normalize(String text);
}

/// A Tokenizer splits text into tokens.
// ignore: one_member_abstracts
abstract class Tokenizer {
  Iterable<String> tokenize(String text);
}

/// A TokenFilter filters tokens.
// ignore: one_member_abstracts
abstract class TokenFilter {
  Iterable<String> filter(Iterable<String> tokens);
}

abstract class PatternReplaceCharFilter extends CharFilter {
  Pattern pattern;
  String replace;
  @override
  String normalize(String text) => text.replaceAll(pattern, replace);
}

class PatternCharFilter extends PatternReplaceCharFilter {
  Pattern _pattern;
  String _replace;
  PatternCharFilter(this._pattern, this._replace) {
    pattern = _pattern;
    replace = _replace;
  }
}

class IdeographicSpaceCharFilter extends PatternReplaceCharFilter {
  IdeographicSpaceCharFilter() {
    pattern = new RegExp(r"　");
    replace = " ";
  }
}

class MappingCharFilter extends CharFilter {
  Map<String, String> _mapping;
  MappingCharFilter(this._mapping);
  @override
  String normalize(String text) {
    String txt = '';
    for (int i = 0; i < text.length; i++) {
      if (_mapping[text[i]] != null) {
        txt = txt + _mapping[text[i]];
      } else {
        txt = txt + text[i];
      }
    }
    return txt;
  }
}

class UpperFullWidthCharFilter extends MappingCharFilter {
  static final Map<String, String> _xMapping = <String, String>{
    'Ａ': 'A',
    'Ｂ': 'B',
    'Ｃ': 'C',
    'Ｄ': 'D',
    'Ｅ': 'E',
    'Ｆ': 'F',
    'Ｇ': 'G',
    'Ｈ': 'H',
    'Ｉ': 'I',
    'Ｊ': 'J',
    'Ｋ': 'K',
    'Ｌ': 'L',
    'Ｍ': 'M',
    'Ｎ': 'N',
    'Ｏ': 'O',
    'Ｐ': 'P',
    'Ｑ': 'Q',
    'Ｒ': 'R',
    'Ｓ': 'S',
    'Ｔ': 'T',
    'Ｕ': 'U',
    'Ｖ': 'V',
    'Ｗ': 'W',
    'Ｘ': 'X',
    'Ｙ': 'Y',
    'Ｚ': 'Z'
  };
  UpperFullWidthCharFilter() : super(_xMapping);
}

class LowerFullWidthCharFilter extends MappingCharFilter {
  static final Map<String, String> _xMapping = <String, String>{
    'ａ': 'a',
    'ｂ': 'b',
    'ｃ': 'c',
    'ｄ': 'd',
    'ｅ': 'e',
    'ｆ': 'f',
    'ｇ': 'g',
    'ｈ': 'h',
    'ｉ': 'i',
    'ｊ': 'j',
    'ｋ': 'k',
    'ｌ': 'l',
    'ｍ': 'm',
    'ｎ': 'n',
    'ｏ': 'o',
    'ｐ': 'p',
    'ｑ': 'q',
    'ｒ': 'r',
    'ｓ': 's',
    'ｔ': 't',
    'ｕ': 'u',
    'ｖ': 'v',
    'ｗ': 'w',
    'ｘ': 'x',
    'ｙ': 'y',
    'ｚ': 'z'
  };
  LowerFullWidthCharFilter() : super(_xMapping);
}

class LowerCaseCharFilter extends CharFilter {
  @override
  String normalize(String text) {
    return text.toLowerCase();
  }
}

class DigitSeparatorCharFilter extends CharFilter {
  @override
  String normalize(String text) {
    String txt = '';
    if (text.indexOf(',') == -1) return text;
    for (int i = 0; i < text.length; i++) {
      bool found = false;
      if (text[i] == ',') {
        final int prevIndex = i - 1;
        if ((i != 0) &&
            (StandardTokenizer.isDigit(text.codeUnitAt(prevIndex)))) {
          final int nextIndex = i + 1;
          if (!(nextIndex > text.length - 1) &&
              (StandardTokenizer.isDigit(text.codeUnitAt(nextIndex)))) {
            found = true;
          }
        }
      }
      if (!found) txt = txt + text[i];
    }
    return txt;
  }
}

class KeywordTokenizer extends Tokenizer {
  @override
  Iterable<String> tokenize(String text) => <String>[text];
}

class WhitespaceTokenizer extends Tokenizer {
  final RegExpTokenizer regExpTokenizer =
      new RegExpTokenizer(new RegExp("[ ,.!?:;'\"\r\n]"));
  @override
  Iterable<String> tokenize(String text) {
    return regExpTokenizer.tokenize(text);
  }
}

class RegExpTokenizer extends Tokenizer {
  final RegExp _regExp;
  RegExpTokenizer(this._regExp);
  @override
  Iterable<String> tokenize(String text) {
    return text.split(_regExp).where((String e) => e.length > 0);
  }
}

class NGramTokenizer extends Tokenizer {
  final int _n;
  NGramTokenizer(this._n);
  @override
  Iterable<String> tokenize(String text) {
    return new Iterable<String>.generate(text.length, (int i) {
      final int endIndex = i + _n;
      if (!(endIndex > text.length)) {
        return text.substring(i, endIndex);
      }
    }).where((String e) => e != null);
  }
}

class EdgeNGramTokenizer extends Tokenizer {
  final int _n;
  EdgeNGramTokenizer(this._n);
  @override
  Iterable<String> tokenize(String text) {
    return new Iterable<String>.generate(_n, (int i) {
      final int endIndex = i + 1;
      if (!(endIndex > text.length)) {
        return text.substring(0, endIndex);
      }
    }).where((String e) => e != null);
  }
}

class PathHierarchyTokenizer extends Tokenizer {
  final String _sep;
  PathHierarchyTokenizer(this._sep);
  @override
  Iterable<String> tokenize(String text) {
    final List<String> items = text.split(_sep);
    final List<String> curItems = <String>[];
    return new Iterable<String>.generate(items.length, (int i) {
      curItems.add(items[i]);
      return curItems.join(_sep);
    }).where((String e) => e.length > 0);
  }
}

class LowerCaseFilter extends TokenFilter {
  @override
  Iterable<String> filter(Iterable<String> tokens) {
    return tokens.map((String e) => e.toLowerCase());
  }
}

class NGramFilter extends TokenFilter {
  final int _n;
  NGramFilter(this._n);
  @override
  Iterable<String> filter(Iterable<String> tokens) {
    return new Iterable<Iterable<String>>.generate(tokens.length, (int i) {
      final String text = tokens.elementAt(i);
      return new Iterable<String>.generate(text.length, (int i) {
        final int endIndex = i + _n;
        if (!(endIndex > text.length)) {
          return text.substring(i, endIndex);
        }
      }).where((String e) => e != null);
    })
        .where((Iterable<String> e) => e != null)
        .expand((Iterable<String> x) => x);
  }
}

class EdgeNGramFilter extends TokenFilter {
  final int _n;
  EdgeNGramFilter(this._n);
  @override
  Iterable<String> filter(Iterable<String> tokens) {
    return new Iterable<Iterable<String>>.generate(tokens.length, (int i) {
      final String text = tokens.elementAt(i);
      return new Iterable<String>.generate(_n, (int i) {
        final int endIndex = i + 1;
        if (!(endIndex > text.length)) {
          return text.substring(0, endIndex);
        }
      }).where((String e) => e != null);
    })
        .where((Iterable<String> e) => e != null)
        .expand((Iterable<String> x) => x);
  }
}

class ShingleFilter extends TokenFilter {
  final int _n;
  final String _separator;
  ShingleFilter(this._n, this._separator);
  @override
  Iterable<String> filter(Iterable<String> tokens) {
    return new Iterable<String>.generate(tokens.length, (int i) {
      final List<String> shingle = _doShingle(tokens, i, _n);
      return (shingle.length == _n) ? shingle.join(_separator) : null;
    }).where((String e) => e != null);
  }

  List<String> _doShingle(Iterable<String> tokens, int i, int n) {
    final List<String> ret = <String>[];
    for (int x = i; x < i + n; x++) {
      if (!(x > tokens.length - 1)) {
        ret.add(tokens.elementAt(x));
      }
    }
    return ret;
  }
}

class SkipBiGramFilter extends TokenFilter {
  final int _k;
  final String _separator;
  SkipBiGramFilter(this._k, this._separator);
  @override
  Iterable<String> filter(Iterable<String> tokens) {
    return new Iterable<Iterable<String>>.generate(tokens.length, (int i) {
      return _doSkipBiGram(tokens, i, _k);
    })
        .where((Iterable<String> e) => e != null)
        .expand((Iterable<String> x) => x);
  }

  List<String> _doSkipBiGram(Iterable<String> tokens, int i, int skip) {
    final List<String> ret = <String>[];
    final int endIndex = i + skip + 1;
    for (int x = i; x < endIndex; x++) {
      final int end = x + 1;
      if (!(end > tokens.length - 1)) {
        final String str =
            tokens.elementAt(i) + _separator + tokens.elementAt(end);
        ret.add(str);
      }
    }
    return ret;
  }
}

class CompoundWordsFilter extends TokenFilter {
  final int max = 10;
  final List<String> _dictionary;
  CompoundWordsFilter(this._dictionary);
  @override
  Iterable<String> filter(Iterable<String> tokens) {
    return tokens
        .map((String token) => _decompose(token))
        .expand((Iterable<String> x) => x)
        .where((String e) => e.length > 0);
  }

  List<String> _decompose(String token) {
    final List<String> ret = <String>[];
    ret.add(token);
    for (int i = 0; i < token.length; i++) {
      for (int j = max - 1; j > 0; j--) {
        final int endIndex = i + j + 1;
        if (!(endIndex > token.length)) {
          final String text = token.substring(i, endIndex);
          if (text.length > 0 && _dictionary.contains(text)) {
            if (!ret.contains(text)) ret.add(text);
            break;
          }
        }
      }
    }
    return ret;
  }
}

abstract class StopFilter extends TokenFilter {
  List<String> stopWords = <String>[];
  @override
  Iterable<String> filter(Iterable<String> tokens) {
    return tokens.where((String e) => !stopWords.contains(e));
  }
}

class StopWordsFilter extends StopFilter {
  final List<String> _stopWords;
  StopWordsFilter(this._stopWords) {
    stopWords = _stopWords;
  }
}

class EnglishStopWordsFilter extends StopFilter {
  EnglishStopWordsFilter() {
    stopWords = <String>[
      "a",
      "an",
      "and",
      "are",
      "as",
      "at",
      "be",
      "but",
      "by",
      "for",
      "if",
      "in",
      "into",
      "is",
      "it",
      "no",
      "not",
      "of",
      "on",
      "or",
      "such",
      "that",
      "the",
      "their",
      "then",
      "there",
      "these",
      "they",
      "this",
      "to",
      "was",
      "will",
      "with"
    ];
  }
}

class JapaneseStopWordsFilter extends StopFilter {
  JapaneseStopWordsFilter() {
    stopWords = <String>[
      'の',
      'に',
      'は',
      'を',
      'た',
      'が',
      'で',
      'て',
      'と',
      'し',
      'れ',
      'さ',
      'ある',
      'いる',
      'も',
      'する',
      'から',
      'な',
      'こと',
      'として',
      'い',
      'や',
      'れる',
      'など',
      'なっ',
      'ない',
      'この',
      'ため',
      'その',
      'あっ',
      'よう',
      'また',
      'もの',
      'という',
      'あり',
      'まで',
      'られ',
      'なる',
      'へ',
      'か',
      'だ',
      'これ',
      'によって',
      'により',
      'おり',
      'より',
      'による',
      'ず',
      'なり',
      'られる',
      'において',
      'ば',
      'なかっ',
      'なく',
      'しかし',
      'について',
      'せ',
      'だっ',
      'その後',
      'できる',
      'それ',
      'う',
      'ので',
      'なお',
      'のみ',
      'でき',
      'き',
      'つ',
      'における',
      'および',
      'いう',
      'さらに',
      'でも',
      'ら',
      'たり',
      'その他',
      'に関する',
      'たち',
      'ます',
      'ん',
      'なら',
      'に対して',
      '特に',
      'せる',
      '及び',
      'これら',
      'とき',
      'では',
      'にて',
      'ほか',
      'ながら',
      'うち',
      'そして',
      'とともに',
      'ただし',
      'かつて',
      'それぞれ',
      'または',
      'お',
      'ほど',
      'ものの',
      'に対する',
      'ほとんど',
      'と共に',
      'といった',
      'です',
      'とも',
      'ところ',
      'ここ'
    ];
  }
}

abstract class KeepFilter extends TokenFilter {
  List<String> keepWords = <String>[];
  @override
  Iterable<String> filter(Iterable<String> tokens) {
    return tokens.where((String e) => keepWords.contains(e));
  }
}

class KeepWordsFilter extends KeepFilter {
  final List<String> _keepWords;
  KeepWordsFilter(this._keepWords) {
    keepWords = _keepWords;
  }
}

abstract class OrderingFilter extends TokenFilter {
  bool reverse = false;
  @override
  Iterable<String> filter(Iterable<String> tokens) {
    return tokens.map((String e) {
      final List<String> str =
          new Iterable<String>.generate(e.length, (int i) => e[i]).toList();
      List<String> ordered = <String>[];
      str.sort();
      ordered.addAll(str);
      if (reverse) {
        ordered = ordered.reversed.toList();
      }
      return ordered.join();
    });
  }
}

class OrderingNaturalFilter extends OrderingFilter {
  OrderingNaturalFilter() {
    reverse = false;
  }
}

class OrderingReverseFilter extends OrderingFilter {
  OrderingReverseFilter() {
    reverse = true;
  }
}

class ReverseStringFilter extends TokenFilter {
  @override
  Iterable<String> filter(Iterable<String> tokens) {
    return tokens.map((String e) {
      final List<String> str =
          new Iterable<String>.generate(e.length, (int i) => e[i]).toList();
      final List<String> ordered = str.reversed.toList();
      return ordered.join();
    });
  }
}

class LengthFilter extends TokenFilter {
  final int _min;
  final int _max;
  LengthFilter(this._min, this._max);
  @override
  Iterable<String> filter(Iterable<String> tokens) {
    return tokens.where((String e) => (_min <= e.length && e.length <= _max));
  }
}

class TypoToleranceFilter extends TokenFilter {
  final int _n;
  NGramFilter _nGram;
  final List<OrderingFilter> _orders = <OrderingFilter>[
    new OrderingNaturalFilter(),
    new OrderingReverseFilter()
  ];
  TypoToleranceFilter(this._n) {
    _nGram = new NGramFilter(_n);
  }
  @override
  Iterable<String> filter(Iterable<String> tokens) {
    final Iterable<Iterable<String>> ite =
        new Iterable<Iterable<String>>.generate(_orders.length, (int i) {
      final OrderingFilter order = _orders[i];
      return order.filter(tokens);
    });
    return _nGram.filter(ite.expand((Iterable<String> x) => x));
  }
}

class EnglishMinimalStemFilter extends TokenFilter {
  @override
  Iterable<String> filter(Iterable<String> tokens) {
    return tokens.map((String token) => _stem(token));
  }

  String _stem(String text) {
    final List<String> s =
        new Iterable<String>.generate(text.length, (int i) => text[i]).toList();
    return s.getRange(0, _doStem(s, s.length)).join();
  }

  int _doStem(List<String> s, int len) {
    if (len < 3 || s[len - 1] != 's') return len;

    switch (s[len - 2]) {
      case 'u':
      case 's':
        return len;
      case 'e':
        if (len > 3 &&
            s[len - 3] == 'i' &&
            s[len - 4] != 'a' &&
            s[len - 4] != 'e') {
          s[len - 3] = 'y';
          return len - 2;
        }
        if (s[len - 3] == 'i' ||
            s[len - 3] == 'a' ||
            s[len - 3] == 'o' ||
            s[len - 3] == 'e') return len; /* intentional fallthrough */
        return len - 1;
      default:
        return len - 1;
    }
  }
}

class AliasFilter extends TokenFilter {
  final Map<String, List<String>> _dictionary;
  AliasFilter(this._dictionary);
  @override
  Iterable<String> filter(Iterable<String> tokens) {
    return tokens.map((String token) {
      final List<String> aliasList = _dictionary[token];
      if (aliasList != null) {
        return aliasList;
      } else {
        return <String>[token];
      }
    }).expand((Iterable<String> x) => x);
  }
}

class KanaFilter extends TokenFilter {
  @override
  Iterable<String> filter(Iterable<String> tokens) {
    return tokens.map((String token) {
      String chars = '';
      for (int i = 0; i < token.length; i++) {
        String char = '';
        final int code = token.codeUnitAt(i);
        if (StandardTokenizer.isKatakana(code)) {
          char = new String.fromCharCode(code - 96);
          char = char.replaceAll('゜', 'ー');
        } else {
          char = token[i];
        }
        chars = chars + char;
      }
      return chars;
    });
  }
}

class CharacterTypeFilter extends TokenFilter {
  final Set<int> _types;
  CharacterTypeFilter(this._types);
  @override
  Iterable<String> filter(Iterable<String> tokens) {
    return tokens.where((String token) {
      if (token.length <= 0) return false;
      final int code = token.codeUnitAt(0); // first character
      int charType = StandardTokenizer.unknown;
      if (StandardTokenizer.isDigit(code)) {
        charType = StandardTokenizer.digitId(code);
        return _types.contains(charType);
      }
      if (StandardTokenizer.isLatin(code)) {
        charType = StandardTokenizer.latinId(code);
        return _types.contains(charType);
      }
      if (StandardTokenizer.isIdeographic(code)) {
        charType = StandardTokenizer.ideographicId(code);
        return _types.contains(charType);
      }
      if (StandardTokenizer.isHiragana(code)) {
        charType = StandardTokenizer.hiraganaId(code);
        return _types.contains(charType);
      }
      if (StandardTokenizer.isKatakana(code)) {
        charType = StandardTokenizer.katakanaId(code);
        return _types.contains(charType);
      }
      return false;
    });
  }
}

class JapaneseCharacterTypeFilter extends CharacterTypeFilter {
  static final Set<int> _jTypes = new Set<int>()
    ..add(StandardTokenizer.ideographic)
    ..add(StandardTokenizer.hiragana)
    ..add(StandardTokenizer.katakana);
  JapaneseCharacterTypeFilter() : super(_jTypes);
}

class TrimFilter extends TokenFilter {
  @override
  Iterable<String> filter(Iterable<String> tokens) {
    return tokens
        .map((String e) => e.trim())
        .map((String e) => _trimLeading(e))
        .where((String e) => e.length > 0);
  }

  String _trimLeading(String s) {
    if (s.length > 0) {
      String ret;
      if (StandardTokenizer.isControl(s.codeUnitAt(0))) {
        ret = s.substring(1);
      } else {
        ret = s;
      }
      return ret;
    }
    return s;
  }
}

class KeywordAnalyzer extends Analyzer {
  KeywordAnalyzer() {
    tokenizer = new KeywordTokenizer();
  }
}

class LowerCaseAnalyser extends Analyzer {
  LowerCaseAnalyser() {
    charFilters = <CharFilter>[new IdeographicSpaceCharFilter()];
    tokenizer = new KeywordTokenizer();
    tokenFilters = <TokenFilter>[new LowerCaseFilter()];
  }
}

class WhitespaceAnalyzer extends Analyzer {
  WhitespaceAnalyzer() {
    tokenizer = new WhitespaceTokenizer();
    tokenFilters = <TokenFilter>[new LowerCaseFilter()];
  }
}

class RegExpAnalyzer extends Analyzer {
  final RegExp _regExp;
  RegExpAnalyzer(this._regExp) {
    tokenizer = new RegExpTokenizer(_regExp);
    tokenFilters = <TokenFilter>[new LowerCaseFilter()];
  }
}

class NGramAnalyzer extends Analyzer {
  final int _n;
  NGramAnalyzer(this._n) {
    tokenizer = new NGramTokenizer(_n);
    tokenFilters = <TokenFilter>[new LowerCaseFilter()];
  }
}

class EdgeNGramAnalyzer extends Analyzer {
  final int _n;
  EdgeNGramAnalyzer(this._n) {
    tokenizer = new EdgeNGramTokenizer(_n);
    tokenFilters = <TokenFilter>[new LowerCaseFilter()];
  }
}

class ShingleAnalyzer extends Analyzer {
  final List<CharFilter> _charFilters;
  final Tokenizer _tokenizer;
  final List<TokenFilter> _tokenFilters;
  final int _n;
  final String _separator;
  ShingleAnalyzer(this._charFilters, this._tokenizer, this._tokenFilters,
      this._n, this._separator) {
    charFilters = _charFilters;
    tokenizer = _tokenizer;
    final List<TokenFilter> filters = <TokenFilter>[];
    filters.addAll(_tokenFilters);
    filters.add(new ShingleFilter(_n, _separator));
    tokenFilters = filters;
  }
}

class StandardAnalyzer extends Analyzer {
  List<String> _dictionary;
  int _max;
  StandardAnalyzer({List<String> dictionary, int max}) {
    _dictionary = (dictionary == null) ? <String>[] : dictionary;
    _max = (max == null) ? 16 : max;
    charFilters = <CharFilter>[new DigitSeparatorCharFilter()];
    tokenizer = new StandardTokenizer();
    tokenFilters = <TokenFilter>[
      new LowerCaseFilter(),
      new CompoundWordsFilter(_dictionary),
      new LengthFilter(1, _max),
      new EnglishStopWordsFilter(),
      new JapaneseStopWordsFilter(),
      new EnglishMinimalStemFilter()
    ];
  }
}

class PhraseAnalyzer extends Analyzer {
  final Analyzer _analyzer;
  final String _separator;
  PhraseAnalyzer(this._analyzer, this._separator) {
    charFilters = _analyzer.charFilters;
    tokenizer = _analyzer.tokenizer;
    final List<TokenFilter> filters = <TokenFilter>[];
    filters.addAll(_analyzer.tokenFilters);
    filters.add(new ShingleFilter(2, _separator));
    tokenFilters = filters;
  }
}

class TypoToleranceAnalyzer extends Analyzer {
  final Analyzer _analyzer;
  TypoToleranceAnalyzer(this._analyzer) {
    charFilters = _analyzer.charFilters;
    tokenizer = _analyzer.tokenizer;
    final List<TokenFilter> filters = <TokenFilter>[];
    filters.addAll(_analyzer.tokenFilters);
    filters.add(new TypoToleranceFilter(4));
    tokenFilters = filters;
  }
}

class UniGramAnalyzer extends Analyzer {
  UniGramAnalyzer() {
    tokenizer = new NGramTokenizer(1);
  }
}

class BiGramAnalyzer extends Analyzer {
  BiGramAnalyzer() {
    tokenizer = new NGramTokenizer(2);
  }
}

class StandardTokenizer extends Tokenizer {
  static int control = 0;
  static int digit = 1;
  static int latin = 2;
  static int ideographic = 3;
  static int hiragana = 4;
  static int katakana = 5;
  static bool isControl(int code) {
    return controlId(code) != unknown;
  }

  static int controlId(int code) {
    return (0x0000 <= code && code <= 0x001F) ? control : unknown;
  }

  static bool isDigit(int code) {
    return digitId(code) != unknown;
  }

  static int digitId(int code) {
    return (0x0030 <= code && code <= 0x0039) ? digit : unknown;
  }

  static bool isLatin(int code) {
    return latinId(code) != unknown;
  }

  static int latinId(int code) {
    return ((0x0041 <= code && code <= 0x005A) ||
            (0x0061 <= code && code <= 0x007A))
        ? latin
        : unknown;
  }

  static bool _ideographic(int code) => (0x4E00 <= code && code <= 0x9FD5);
  static bool _ideographicA(int code) => (0x3400 <= code) && (code <= 0x4DFF);
  static bool _ideographicB(int code) => (0x20000 <= code) && (code <= 0x2A6FF);
  static bool _ideographicC(int code) => (0x2A700 <= code) && (code <= 0x2B734);
  static bool _ideographicD(int code) => (0x2B740 <= code) && (code <= 0x2B81F);
  static bool _ideographicE(int code) => (0x2B820 <= code) && (code <= 0x2CEAF);
  static bool isIdeographic(int code) {
    return ideographicId(code) != unknown;
  }

  static int ideographicId(int code) {
    if (_ideographic(code) ||
        _ideographicA(code) ||
        _ideographicB(code) ||
        _ideographicC(code) ||
        _ideographicD(code) ||
        _ideographicE(code)) {
      return ideographic;
    }
    return unknown;
  }

  static bool isHiragana(int code) {
    return hiraganaId(code) != unknown;
  }

  static int hiraganaId(int code) {
    return (0x3041 <= code && code <= 0x3096) ? hiragana : unknown;
  }

  static bool isKatakana(int code) {
    return katakanaId(code) != unknown;
  }

  static int katakanaId(int code) {
    return (0x30A1 <= code && code <= 0x30FA) || (code == 0x30FC)
        ? katakana
        : unknown;
  }

  int _charType(int code) {
    final int a = digitId(code);
    if (a != unknown) return a;
    final int b = latinId(code);
    if (b != unknown) return b;
    final int c = ideographicId(code);
    if (c != unknown) return c;
    final int d = hiraganaId(code);
    if (d != unknown) return d;
    final int e = katakanaId(code);
    if (e != unknown) return e;
    return unknown;
  }

  static int unknown = -1;

  bool _shouldAdd(int type) => (type == unknown) ? false : true;
  bool _shouldBreak(
      int prevType, int type, List<String> tmpChars, String curChar) {
    if (_shouldBreakByType(prevType, type)) {
      return true;
    }
    if (_shouldBreakByCaseChange(tmpChars, curChar)) {
      return true;
    }
    return false;
  }

  bool _shouldBreakByType(int prevType, int type) => prevType != type;
  bool _shouldBreakByCaseChange(List<String> tmpChars, String curChar) {
    if (tmpChars.isNotEmpty) {
      final String prevChar = tmpChars[tmpChars.length - 1];
      if (prevChar != prevChar.toUpperCase() &&
          curChar == curChar.toUpperCase()) {
        return true;
      }
    }
    return false;
  }

  @override
  Iterable<String> tokenize(String text) {
    final int _initState = -10000;
    int _previousState = _initState;
    final List<String> ret = <String>[];
    final List<String> tmpChars = <String>[];
    for (int i = 0; i < text.length; i++) {
      final int code = text.codeUnitAt(i);
      final int type = _charType(code);
      final int prevState = _previousState;
      _previousState = type;
      if (_shouldAdd(type)) {
        final String char = text[i];
        if (_shouldBreak(prevState, type, tmpChars, char)) {
          _emit(tmpChars, ret);
        }
        tmpChars.add(char);
      } else {
        _emit(tmpChars, ret);
      }
    }
    _emit(tmpChars, ret);
    return ret;
  }

  void _emit(List<String> tmpChars, List<String> ret) {
    if (tmpChars.isNotEmpty) {
      final String str = tmpChars.join();
      ret.add(str);
      tmpChars.clear();
    }
  }
}

class RomajiFilter extends TokenFilter {
  final Map<String, List<String>> _dictionary = <String, List<String>>{
    'あ': <String>['a'],
    'い': <String>['i', 'yi'],
    'う': <String>['u', 'wu', 'whu'],
    'え': <String>['e'],
    'お': <String>['o'],
    'うぁ': <String>['wha'],
    'うぃ': <String>['whi', 'wi'],
    'うぇ': <String>['whe', 'we'],
    'うぉ': <String>['who'],
    'ゐ': <String>['wi'],
    'ゑ': <String>['we'],
    'ぁ': <String>['la', 'xa'],
    'ぃ': <String>['ili', 'xi', 'lyi', 'xyi'],
    'ぅ': <String>['lu', 'xu'],
    'ぇ': <String>['le', 'xe', 'lye', 'xye'],
    'ぉ': <String>['lo', 'xo'],
    'か': <String>['ka', 'ca'],
    'き': <String>['ki'],
    'く': <String>['ku', 'cu', 'qu'],
    'け': <String>['ke'],
    'こ': <String>['ko', 'co'],
    'きゃ': <String>['kya'],
    'きぃ': <String>['kyi'],
    'きゅ': <String>['kyu'],
    'きぇ': <String>['kye'],
    'きょ': <String>['kyo'],
    'くゃ': <String>['qya'],
    'くゅ': <String>['qyu'],
    'くょ': <String>['qyo'],
    'くぁ': <String>['qwa', 'qa', 'kwa'],
    'くぃ': <String>['qwi', 'qi', 'qyi'],
    'くぅ': <String>['qwu'],
    'くぇ': <String>['qwe', 'qe', 'qye'],
    'くぉ': <String>['qwo', 'qo'],
    'が': <String>['ga'],
    'ぎ': <String>['gi'],
    'ぐ': <String>['gu'],
    'げ': <String>['ge'],
    'ご': <String>['go'],
    'ぎゃ': <String>['gya'],
    'ぎぃ': <String>['gyi'],
    'ぎゅ': <String>['gyu'],
    'ぎぇ': <String>['gye'],
    'ぎょ': <String>['gyo'],
    'ぐぁ': <String>['gwa'],
    'ぐぃ': <String>['gwi'],
    'ぐぅ': <String>['gwu'],
    'ぐぇ': <String>['gwe'],
    'ぐぉ': <String>['gwo'],
    'ヵ': <String>['lka', 'xka'],
    'ヶ': <String>['lke', 'xke'],
    'さ': <String>['sa'],
    'し': <String>['si', 'ci', 'shi'],
    'す': <String>['su'],
    'せ': <String>['se', 'ce'],
    'そ': <String>['so'],
    'しゃ': <String>['sya', 'sha'],
    'しぃ': <String>['syi'],
    'しゅ': <String>['syu', 'shu'],
    'しぇ': <String>['sye', 'she'],
    'しょ': <String>['syo', 'sho'],
    'すぁ': <String>['swa'],
    'すぃ': <String>['swi'],
    'すぅ': <String>['swu'],
    'すぇ': <String>['swe'],
    'すぉ': <String>['swo'],
    'ざ': <String>['za'],
    'じ': <String>['zi', 'ji'],
    'ず': <String>['zu'],
    'ぜ': <String>['ze'],
    'ぞ': <String>['zo'],
    'じゃ': <String>['zya', 'ja', 'jya'],
    'じぃ': <String>['zyi', 'jyi'],
    'じゅ': <String>['zyu', 'ju', 'jyu'],
    'じぇ': <String>['zye', 'je', 'jye'],
    'じょ': <String>['zyo', 'jo', 'jyo'],
    'た': <String>['ta'],
    'ち': <String>['ti', 'chi'],
    'つ': <String>['tu', 'tsu'],
    'て': <String>['te'],
    'と': <String>['to'],
    'ちゃ': <String>['tya', 'cha', 'cya'],
    'ちぃ': <String>['tyi', 'cyi'],
    'ちゅ': <String>['tyu', 'chu', 'cyu'],
    'ちぇ': <String>['tye', 'che', 'cye'],
    'ちょ': <String>['tyo', 'cho', 'cyo'],
    'つぁ': <String>['tsa'],
    'つぃ': <String>['tsi'],
    'つぇ': <String>['tse'],
    'つぉ': <String>['tso'],
    'てゃ': <String>['tha'],
    'てぃ': <String>['thi'],
    'てゅ': <String>['thu'],
    'てぇ': <String>['the'],
    'てょ': <String>['tho'],
    'とぁ': <String>['twa'],
    'とぃ': <String>['twi'],
    'とぅ': <String>['twu'],
    'とぇ': <String>['twe'],
    'とぉ': <String>['two'],
    'だ': <String>['da'],
    'ぢ': <String>['di'],
    'づ': <String>['du'],
    'で': <String>['de'],
    'ど': <String>['do'],
    'ぢゃ': <String>['dya'],
    'ぢぃ': <String>['dyi'],
    'ぢゅ': <String>['dyu'],
    'ぢぇ': <String>['dye'],
    'ぢょ': <String>['dyo'],
    'でゃ': <String>['dha'],
    'でぃ': <String>['dhi'],
    'でゅ': <String>['dhu'],
    'でぇ': <String>['dhe'],
    'でょ': <String>['dho'],
    'どぁ': <String>['dwa'],
    'どぃ': <String>['dwi'],
    'どゅ': <String>['dwu'],
    'どぇ': <String>['dwe'],
    'どょ': <String>['dwo'],
    'っ': <String>['ltu', 'xtu', 'ltsu'],
    'っか': <String>['kka', 'cca'],
    'っき': <String>['kki'],
    'っく': <String>['kku', 'ccu', 'qqu'],
    'っけ': <String>['kke'],
    'っこ': <String>['kko', 'cco'],
    'っさ': <String>['ssa'],
    'っし': <String>['ssi', 'cci'],
    'っす': <String>['ssu'],
    'っせ': <String>['sse', 'cce'],
    'っそ': <String>['sso'],
    'った': <String>['tta'],
    'っち': <String>['tti'],
    'っつ': <String>['ttu'],
    'って': <String>['tte'],
    'っと': <String>['tto'],
    'っぱ': <String>['ppa'],
    'っぴ': <String>['ppi'],
    'っぷ': <String>['ppu'],
    'っぺ': <String>['ppe'],
    'っぽ': <String>['ppo'],
    'な': <String>['na'],
    'に': <String>['ni'],
    'ぬ': <String>['nu'],
    'ね': <String>['ne'],
    'の': <String>['no'],
    'にゃ': <String>['nya'],
    'にぃ': <String>['nyi'],
    'にゅ': <String>['nyu'],
    'にぇ': <String>['nye'],
    'にょ': <String>['nyo'],
    'は': <String>['ha'],
    'ひ': <String>['hi'],
    'ふ': <String>['hu', 'fu'],
    'へ': <String>['he'],
    'ほ': <String>['ho'],
    'ひゃ': <String>['hya'],
    'ひぃ': <String>['hyi'],
    'ひゅ': <String>['hyu'],
    'ひぇ': <String>['hye'],
    'ひょ': <String>['hyo'],
    'ふぁ': <String>['fwa', 'fa'],
    'ふぃ': <String>['fwi', 'fi', 'fyi'],
    'ふぅ': <String>['fwu'],
    'ふぇ': <String>['fwe', 'fe', 'fye'],
    'ふぉ': <String>['fwo', 'fo'],
    'ふゃ': <String>['fya'],
    'ふゅ': <String>['fyu'],
    'ふょ': <String>['fyo'],
    'ば': <String>['ba'],
    'び': <String>['bi'],
    'ぶ': <String>['bu'],
    'べ': <String>['be'],
    'ぼ': <String>['bo'],
    'びゃ': <String>['bya'],
    'びぃ': <String>['byi'],
    'びゅ': <String>['byu'],
    'びぇ': <String>['bye'],
    'びょ': <String>['byo'],
    'ヴぁ': <String>['va'],
    'ヴぃ': <String>['vi', 'vyi'],
    'ヴ': <String>['vu'],
    'ヴぇ': <String>['ve', 'vye'],
    'ヴぉ': <String>['vo'],
    'ゔぁ': <String>['va'],
    'ゔぃ': <String>['vi', 'vyi'],
    'ゔ': <String>['vu'],
    'ゔぇ': <String>['ve', 'vye'],
    'ゔぉ': <String>['vo'],
    'ヴゃ': <String>['vya'],
    'ヴゅ': <String>['vyu'],
    'ヴょ': <String>['vyo'],
    'ゔゃ': <String>['vya'],
    'ゔゅ': <String>['vyu'],
    'ゔょ': <String>['vyo'],
    'ぱ': <String>['pa'],
    'ぴ': <String>['pi'],
    'ぷ': <String>['pu'],
    'ぺ': <String>['pe'],
    'ぽ': <String>['po'],
    'ぴゃ': <String>['pya'],
    'ぴぃ': <String>['pyi'],
    'ぴゅ': <String>['pyu'],
    'ぴぇ': <String>['pye'],
    'ぴょ': <String>['pyo'],
    'ま': <String>['ma'],
    'み': <String>['mi'],
    'む': <String>['mu'],
    'め': <String>['me'],
    'も': <String>['mo'],
    'みゃ': <String>['mya'],
    'みぃ': <String>['myi'],
    'みゅ': <String>['myu'],
    'みぇ': <String>['mye'],
    'みょ': <String>['myo'],
    'や': <String>['ya'],
    'ゆ': <String>['yu'],
    'よ': <String>['yo'],
    'ゃ': <String>['lya', 'xya'],
    'ゅ': <String>['lyu', 'xyu'],
    'ょ': <String>['lyo', 'xyo'],
    'ら': <String>['ra'],
    'り': <String>['ri'],
    'る': <String>['ru'],
    'れ': <String>['re'],
    'ろ': <String>['ro'],
    'りゃ': <String>['rya'],
    'りぃ': <String>['ryi'],
    'りゅ': <String>['ryu'],
    'りぇ': <String>['rye'],
    'りょ': <String>['ryo'],
    'わ': <String>['wa'],
    'を': <String>['wo'],
    'ん': <String>['n', 'nn', "n'", 'xn'],
    'ゎ': <String>['lwa', 'xwa'],
    'ー': <String>['-']
  };
  @override
  Iterable<String> filter(Iterable<String> tokens) {
    return tokens
        .map((String token) => _convert(token))
        .expand((List<String> x) => x)
        .where((String e) => e.length > 0);
  }

  List<String> _convert(String text) {
    if (text.length <= 0) return <String>[text];
    if (!StandardTokenizer.isHiragana(text.codeUnitAt(0)))
      return <String>[text];
    List<String> ret = <String>[];
    bool skip = false;
    for (int i = 0; i < text.length; i++) {
      if (skip) {
        skip = false;
        continue;
      }
      final int start = i;
      int end = i + 2;
      List<String> results = _lookup(text, start, end);
      if (results != null) {
        ret = _fill(ret, results);
        skip = true;
        continue;
      }
      end = i + 1;
      results = _lookup(text, start, end);
      if (results != null) {
        ret = _fill(ret, results);
        skip = false;
        continue;
      }
      ret = _fill(ret, <String>[text[i]]);
    }
    return ret;
  }

  List<String> _fill(List<String> curList, List<String> results) {
    final List<String> ret = <String>[];
    if (curList.length == 0) {
      for (String r in results) {
        ret.add(r);
      }
    } else {
      for (String e in curList) {
        for (String r in results) {
          ret.add(e + r);
        }
      }
    }
    return ret;
  }

  List<String> _lookup(String text, int startIndex, int endIndex) {
    if (!(endIndex > text.length)) {
      final String char = text.substring(startIndex, endIndex);
      return _doLookup(char);
    }
    return null;
  }

  List<String> _doLookup(String char) {
    final List<String> ret = _dictionary[char];
    return (ret != null) ? ret : null;
  }
}
