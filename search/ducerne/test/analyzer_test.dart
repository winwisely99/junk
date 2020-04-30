// Copyright (c) 2016, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:ducene/analysis.dart';
import 'package:test/test.dart';

void main() {
  group('A group of analyzer', () {
    WhitespaceAnalyzer ws;

    setUp(() {
      ws = new WhitespaceAnalyzer();
    });

    test('should be 1 gram', () {
      final Analyzer a = new NGramAnalyzer(1);
      expect(
          a.getTokens('aaa bbb'), <String>['a', 'a', 'a', ' ', 'b', 'b', 'b']);
    });

    test('should be 2 gram', () {
      final Analyzer a = new NGramAnalyzer(2);
      expect(
          a.getTokens('aaa bbb'), <String>['aa', 'aa', 'a ', ' b', 'bb', 'bb']);
    });

    test('should be 2 shingle with 1 gram', () {
      final Analyzer a = new ShingleAnalyzer(<CharFilter>[],
          new NGramTokenizer(1), <TokenFilter>[new LowerCaseFilter()], 2, '');
      expect(a.getTokens('aaa bbb').toList(),
          <String>['aa', 'aa', 'a ', ' b', 'bb', 'bb']);
    });

    test('should be 2 shingle with 2 gram', () {
      final Analyzer a = new ShingleAnalyzer(<CharFilter>[],
          new NGramTokenizer(2), <TokenFilter>[new LowerCaseFilter()], 2, '');
      expect(a.getTokens('aaa bbb').toList(),
          <String>['aaaa', 'aaa ', 'a  b', ' bbb', 'bbbb']);
    });

    test('should be segments by punctuation', () {
      expect(
          ws.getTokens("aa bb,cc.dd!ee?ff: gg;hh \"ii\" 'jj' \r\n kk ll"),
          <String>[
            'aa',
            'bb',
            'cc',
            'dd',
            'ee',
            'ff',
            'gg',
            'hh',
            'ii',
            'jj',
            'kk',
            'll'
          ]);
    });

    test('should be whitespace', () {
      expect(ws.getTokens('Please divide this sentence into shingles'),
          <String>['please', 'divide', 'this', 'sentence', 'into', 'shingles']);
    });

    test('should be 2 shingle with whitespace', () {
      final Analyzer a = new ShingleAnalyzer(
          ws.charFilters, ws.tokenizer, ws.tokenFilters, 2, ' ');
      expect(a.getTokens('Please divide this sentence into shingles'), <String>[
        'please divide',
        'divide this',
        'this sentence',
        'sentence into',
        'into shingles'
      ]);
    });

    test('should be 3 shingle with whitespace', () {
      final Analyzer a = new ShingleAnalyzer(
          ws.charFilters, ws.tokenizer, ws.tokenFilters, 3, ' ');
      expect(a.getTokens('Please divide this sentence into shingles'), <String>[
        'please divide this',
        'divide this sentence',
        'this sentence into',
        'sentence into shingles'
      ]);
    });

    test('should be edgeNGram up to max', () {
      final Analyzer a = new EdgeNGramAnalyzer(7);
      expect(a.getTokens('12345-abcde'),
          <String>['1', '12', '123', '1234', '12345', '12345-', '12345-a']);
    });

    test('should be edgeNGram less text length than max', () {
      final Analyzer a = new EdgeNGramAnalyzer(7);
      expect(a.getTokens('ABC'), <String>['a', 'ab', 'abc']);
    });

    test('should be splitted by regexp', () {
      final RegExp regExp =
          new RegExp("[ ,.!?:;'\"\r\n\\-_\$&()`/*+=<>@#\\[\\]]");
      final String text = "a b,c.d!e?f:g;h" +
          "'i\"j\rk\nl-m_n\$o&p(q)r`s/t*u" +
          "+v-w<x>y[z]" +
          "aa@bb#cc";
      expect(new RegExpAnalyzer(regExp).getTokens(text), <String>[
        'a',
        'b',
        'c',
        'd',
        'e',
        'f',
        'g',
        'h',
        'i',
        'j',
        'k',
        'l',
        'm',
        'n',
        'o',
        'p',
        'q',
        'r',
        's',
        't',
        'u',
        'v',
        'w',
        'x',
        'y',
        'z',
        'aa',
        'bb',
        'cc'
      ]);
    });

    final String text = '''
CJK統合漢字（シージェーケーとうごうかんじ、英: CJK unified ideographs）は、
ISO/IEC 10646（略称：UCS[1]）およびUnicode（ユニコード）にて採用されている
符号化用漢字集合およびその符号表である。CJK統合漢字の名称は、
中国語、日本語、朝鮮語で使われている漢字をひとまとめにしたことからきている。
''';

    test('should be splitted by Standard mixed', () {
      expect(new StandardAnalyzer().getTokens(text), <String>[
        'cjk',
        '統合漢字',
        'シージェーケー',
        'とうごうかんじ',
        '英',
        'cjk',
        'unified',
        'ideograph',
        'iso',
        'iec',
        '10646',
        '略称',
        'uc',
        '1',
        'unicode',
        'ユニコード',
        '採用',
        'されている',
        '符号化用漢字集合',
        'およびその',
        '符号表',
        'である',
        'cjk',
        '統合漢字',
        '名称',
        '中国語',
        '日本語',
        '朝鮮語',
        '使',
        'われている',
        '漢字'
      ]);
    });

    test('should be splitted by StandardPhrase mixed', () {
      expect(
          new PhraseAnalyzer(new StandardAnalyzer(), '').getTokens(text),
          <String>[
            'cjk統合漢字',
            '統合漢字シージェーケー',
            'シージェーケーとうごうかんじ',
            'とうごうかんじ英',
            '英cjk',
            'cjkunified',
            'unifiedideograph',
            'ideographiso',
            'isoiec',
            'iec10646',
            '10646略称',
            '略称uc',
            'uc1',
            '1unicode',
            'unicodeユニコード',
            'ユニコード採用',
            '採用されている',
            'されている符号化用漢字集合',
            '符号化用漢字集合およびその',
            'およびその符号表',
            '符号表である',
            'であるcjk',
            'cjk統合漢字',
            '統合漢字名称',
            '名称中国語',
            '中国語日本語',
            '日本語朝鮮語',
            '朝鮮語使',
            '使われている',
            'われている漢字'
          ]);
    });

    /*
    test('should be splitted by Standard mixed using japanese dictonary', () {
      final File f = new File("lib/assets/noun.json");
      final String obj = f.readAsStringSync(); //TODO remove sync
      final List<String> dict = JSON.decode(obj);
      final StandardAnalyzer st = new StandardAnalyzer(dictionary: dict);
      expect(st.getTokens(text), <String>[
        'cjk',
        '統合漢字',
        '統合',
        '漢字',
        'シージェーケー',
        'とうごうかんじ',
        'ごうかん',
        'かん',
        '英',
        'cjk',
        'unified',
        'ideograph',
        'iso',
        'iec',
        '10646',
        '略称',
        'uc',
        '1',
        'unicode',
        'ユニコード',
        'コード',
        '採用',
        'されている',
        'てい',
        '符号化用漢字集合',
        '符号',
        '漢字',
        '集合',
        'およびその',
        '符号表',
        '符号',
        'である',
        'cjk',
        '統合漢字',
        '統合',
        '漢字',
        '名称',
        '中国語',
        '国語',
        '日本語',
        '朝鮮語',
        '使',
        'われている',
        'てい',
        '漢字',
        'ひとまとめ',
        'まとめ',
        'にし',
        'した',
        'たこ',
        'てい'
      ]);
    });
    */

    final String textEn = '''
The Chinese, Japanese and Korean (CJK) scripts share a common background,
collectively known as CJK characters. In the process called Han unification,
the common (shared) characters were identified and named "CJK Unified Ideographs".
As of Unicode 9.0, Unicode defines a total of 80,388 CJK Unified Ideographs.[1]
''';

    test('should be splitted by Standard en', () {
      expect(new StandardAnalyzer().getTokens(textEn), <String>[
        'chinese',
        'japanese',
        'korean',
        'cjk',
        'script',
        'share',
        'common',
        'background',
        'collectively',
        'known',
        'cjk',
        'character',
        'process',
        'called',
        'han',
        'unification',
        'common',
        'shared',
        'character',
        'were',
        'identified',
        'named',
        'cjk',
        'unified',
        'ideograph',
        'unicode',
        '9',
        '0',
        'unicode',
        'define',
        'total',
        '80388',
        'cjk',
        'unified',
        'ideograph',
        '1'
      ]);
    });

    test('should be splitted by StandardPhrase en', () {
      expect(
          new PhraseAnalyzer(new StandardAnalyzer(), ' ').getTokens(textEn),
          <String>[
            'chinese japanese',
            'japanese korean',
            'korean cjk',
            'cjk script',
            'script share',
            'share common',
            'common background',
            'background collectively',
            'collectively known',
            'known cjk',
            'cjk character',
            'character process',
            'process called',
            'called han',
            'han unification',
            'unification common',
            'common shared',
            'shared character',
            'character were',
            'were identified',
            'identified named',
            'named cjk',
            'cjk unified',
            'unified ideograph',
            'ideograph unicode',
            'unicode 9',
            '9 0',
            '0 unicode',
            'unicode define',
            'define total',
            'total 80388',
            '80388 cjk',
            'cjk unified',
            'unified ideograph',
            'ideograph 1'
          ]);
    });

    test('should be normalized as to natural input', () {
      expect(new LowerCaseAnalyser().getTokens("中国語　日本語　朝鮮語"),
          <String>['中国語 日本語 朝鮮語']);
    });
  });

  group('A group of charFilter', () {
    test('should be replaced by regexp', () {
      final RegExp regExp = new RegExp("[a-z]");
      final PatternCharFilter patternCharFilter =
          new PatternCharFilter(regExp, "");
      final String text = "Abcde 12345";
      expect(patternCharFilter.normalize(text), 'A 12345');
    });

    test('should be replaced by regexp', () {
      final IdeographicSpaceCharFilter cf = new IdeographicSpaceCharFilter();
      final String text = "Abcde 12345　789";
      expect(cf.normalize(text), 'Abcde 12345 789');
    });

    test('should be mapped', () {
      final MappingCharFilter cf =
          new MappingCharFilter(<String, String>{'A': 'a', '3': '9'});
      final String text = "Abcde 12345";
      expect(cf.normalize(text), 'abcde 12945');
    });

    test('should be mapped upper-full-width', () {
      final UpperFullWidthCharFilter cf = new UpperFullWidthCharFilter();
      final String text = "Ａbcde 12345";
      expect(cf.normalize(text), 'Abcde 12345');
    });

    test('should be mapped lower-full-width', () {
      final LowerFullWidthCharFilter cf = new LowerFullWidthCharFilter();
      final String text = "ａＢcde 12345";
      expect(cf.normalize(text), 'aＢcde 12345');
    });

    test('should be lowercased', () {
      final LowerCaseCharFilter cf = new LowerCaseCharFilter();
      final String text = "Abcde 12345";
      expect(cf.normalize(text), 'abcde 12345');
    });

    test('should be normalized w/o comma', () {
      final DigitSeparatorCharFilter cf = new DigitSeparatorCharFilter();
      final String text = ",Abcde 123,45, 9,000 789.00,";
      expect(cf.normalize(text), ',Abcde 12345, 9000 789.00,');
    });
  });

  group('A group of tokenizer', () {
    test('should be tokenized', () {
      final StandardTokenizer t = new StandardTokenizer();
      final String text =
          "Wi-Fi PowerShot SD500 //hello---there, 'dude' O'Neil's";
      expect(t.tokenize(text).toList(), <String>[
        'Wi',
        'Fi',
        'Power',
        'Shot',
        'SD',
        '500',
        'hello',
        'there',
        'dude',
        'O',
        'Neil',
        's'
      ]);
    });

    test('should be splitted by case change', () {
      final StandardTokenizer t = new StandardTokenizer();
      final String text = "aaAa bBbb cccc dDDd";
      expect(t.tokenize(text).toList(),
          <String>['aa', 'Aa', 'b', 'Bbb', 'cccc', 'd', 'DDd']);
    });

    test('should be expanded by separator', () {
      final PathHierarchyTokenizer t = new PathHierarchyTokenizer("/");
      final String text = "/aa/bb/cc";
      expect(t.tokenize(text).toList(), <String>['/aa', '/aa/bb', '/aa/bb/cc']);
      final String text2 = "c:/a/b/c";
      expect(t.tokenize(text2).toList(),
          <String>['c:', 'c:/a', 'c:/a/b', 'c:/a/b/c']);
    });
  });

  group('A group of filter', () {
    test('should be expanded by 4 gram', () {
      final NGramFilter f = new NGramFilter(4);
      final List<String> tokens = <String>['01234567890', 'component'];
      expect(f.filter(tokens).toList(), <String>[
        '0123',
        '1234',
        '2345',
        '3456',
        '4567',
        '5678',
        '6789',
        '7890',
        'comp',
        'ompo',
        'mpon',
        'pone',
        'onen',
        'nent'
      ]);
    });

    test('should be expanded by edgeNgram', () {
      final EdgeNGramFilter f = new EdgeNGramFilter(4);
      final List<String> tokens = <String>['01234567890', 'component'];
      expect(f.filter(tokens).toList(),
          <String>['0', '01', '012', '0123', 'c', 'co', 'com', 'comp']);
    });

    test('should be expanded by 2-skip-bi-grams', () {
      final SkipBiGramFilter f = new SkipBiGramFilter(2, ' ');
      final List<String> tokens = <String>[
        'Insurgents',
        'killed',
        'in',
        'ongoing',
        'fighting'
      ];
      expect(f.filter(tokens).toList(), <String>[
        'Insurgents killed',
        'Insurgents in',
        'Insurgents ongoing',
        'killed in',
        'killed ongoing',
        'killed fighting',
        'in ongoing',
        'in fighting',
        'ongoing fighting'
      ]);
    });

    test('should be expanded by 3-skip-bi-grams', () {
      final SkipBiGramFilter f = new SkipBiGramFilter(3, ' ');
      final List<String> tokens = <String>[
        'Insurgents',
        'killed',
        'in',
        'ongoing',
        'fighting'
      ];
      expect(f.filter(tokens).toList(), <String>[
        'Insurgents killed',
        'Insurgents in',
        'Insurgents ongoing',
        'Insurgents fighting',
        'killed in',
        'killed ongoing',
        'killed fighting',
        'in ongoing',
        'in fighting',
        'ongoing fighting'
      ]);
    });

    test('should be removed by stopwords list', () {
      final List<String> stopWords = <String>['xx', 'yy'];
      final StopWordsFilter stopWordsFilter = new StopWordsFilter(stopWords);
      final List<String> tokens = <String>['aa', 'xx', 'bb', 'yy'];
      expect(stopWordsFilter.filter(tokens).toList(), <String>['aa', 'bb']);
    });

    test('should be remained by keepwords list', () {
      final List<String> keepWords = <String>['xx', 'yy'];
      final KeepWordsFilter keepWordsFilter = new KeepWordsFilter(keepWords);
      final List<String> tokens = <String>['aa', 'xx', 'bb', 'yy'];
      expect(keepWordsFilter.filter(tokens).toList(), <String>['xx', 'yy']);
    });

    test('should be ordered by natural', () {
      final OrderingNaturalFilter f = new OrderingNaturalFilter();
      final List<String> tokens = <String>['component', '314'];
      expect(f.filter(tokens).toList(), <String>['cemnnoopt', '134']);
    });

    test('should be ordered by reverse', () {
      final OrderingReverseFilter f = new OrderingReverseFilter();
      final List<String> tokens = <String>['component', '314'];
      expect(f.filter(tokens).toList(), <String>['tpoonnmec', '431']);
    });

    test('should be ordered by reverse literal', () {
      final ReverseStringFilter f = new ReverseStringFilter();
      final List<String> tokens = <String>['component', '314'];
      expect(f.filter(tokens).toList(), <String>['tnenopmoc', '413']);
    });

    test('should be filtered by length', () {
      final LengthFilter lengthFilter = new LengthFilter(2, 4);
      final List<String> tokens = <String>[
        '1',
        '12',
        '123',
        '1234',
        '1234',
        '12345'
      ];
      expect(lengthFilter.filter(tokens).toList(),
          <String>['12', '123', '1234', '1234']);
    });

    test('typo tolerance filter', () {
      final TypoToleranceFilter f = new TypoToleranceFilter(4);
      final List<String> tokens = <String>['3294567180', 'bejadhfgci'];
      expect(f.filter(tokens).toList(), <String>[
        '0123',
        '1234',
        '2345',
        '3456',
        '4567',
        '5678',
        '6789',
        'abcd',
        'bcde',
        'cdef',
        'defg',
        'efgh',
        'fghi',
        'ghij',
        '9876',
        '8765',
        '7654',
        '6543',
        '5432',
        '4321',
        '3210',
        'jihg',
        'ihgf',
        'hgfe',
        'gfed',
        'fedc',
        'edcb',
        'dcba'
      ]);
    });

    test('en stem filter', () {
      final EnglishMinimalStemFilter f = new EnglishMinimalStemFilter();
      final List<String> tokens = <String>[
        'queries',
        'phrases',
        'corpus',
        'stress',
        'kings',
        'panels',
        'aerodynamics',
        'congress',
        'serious'
      ];
      expect(f.filter(tokens).toList(), <String>[
        'query',
        'phrase',
        'corpus',
        'stress',
        'king',
        'panel',
        'aerodynamic',
        'congress',
        'serious'
      ]);
    });

    test('alias filter', () {
      final Map<String, List<String>> dict = <String, List<String>>{
        '今日': <String>['きょう', 'こんにち']
      };
      final AliasFilter f = new AliasFilter(dict);
      final List<String> tokens = <String>['今日', '昨日', 'aa', 'ひらがな', 'カタカナー'];
      expect(f.filter(tokens).toList(),
          <String>['きょう', 'こんにち', '昨日', 'aa', 'ひらがな', 'カタカナー']);
    });

    test('kana filter', () {
      final KanaFilter f = new KanaFilter();
      final List<String> tokens = <String>[
        '今日',
        '昨日',
        'aa',
        'ひらがな',
        'カタカナー',
        'ヴァージョン'
      ];
      expect(f.filter(tokens).toList(),
          <String>['今日', '昨日', 'aa', 'ひらがな', 'かたかなー', 'ゔぁーじょん']);
    });

    test('chartype filter', () {
      final Set<int> types = new Set<int>()
        ..add(StandardTokenizer.hiragana)
        ..add(StandardTokenizer.katakana);
      final CharacterTypeFilter f = new CharacterTypeFilter(types);
      final List<String> tokens = <String>[
        '今日',
        '昨日',
        'aa',
        'ひらがな',
        'カタカナ',
        ''
      ];
      expect(f.filter(tokens).toList(), <String>['ひらがな', 'カタカナ']);
    });

    test('chartype filter ja', () {
      final JapaneseCharacterTypeFilter f = new JapaneseCharacterTypeFilter();
      final List<String> tokens = <String>[
        '今日',
        '昨日',
        'aa',
        'ひらがな',
        'カタカナ',
        ''
      ];
      expect(f.filter(tokens).toList(), <String>['今日', '昨日', 'ひらがな', 'カタカナ']);
    });

    test('romaji filter #1', () {
      final RomajiFilter f = new RomajiFilter();
      final List<String> tokens = <String>['かこ', 'げんざい', 'みらい'];
      expect(f.filter(tokens).toList(), <String>[
        "kako",
        "kaco",
        "cako",
        "caco",
        "genzai",
        "genzayi",
        "gennzai",
        "gennzayi",
        "gen'zai",
        "gen'zayi",
        "gexnzai",
        "gexnzayi",
        "mirai",
        "mirayi"
      ]);
    });

    test('romaji filter #2', () {
      final RomajiFilter f = new RomajiFilter();
      final List<String> tokens = <String>['らっきー', 'いった', 'ゔぁーじょん', ''];
      expect(f.filter(tokens).toList(), <String>[
        "rakki-",
        "itta",
        "yitta",
        "va-zyon",
        "va-zyonn",
        "va-zyon'",
        "va-zyoxn",
        "va-jon",
        "va-jonn",
        "va-jon'",
        "va-joxn",
        "va-jyon",
        "va-jyonn",
        "va-jyon'",
        "va-jyoxn"
      ]);
    });

    test('romaji filter #3', () {
      final RomajiFilter f = new RomajiFilter();
      final List<String> tokens = <String>['でーたべーす', 'あぷりけーしょん', ''];
      expect(f.filter(tokens).toList(), <String>[
        "de-tabe-su",
        "apurike-syon",
        "apurike-syonn",
        "apurike-syon'",
        "apurike-syoxn",
        "apurike-shon",
        "apurike-shonn",
        "apurike-shon'",
        "apurike-shoxn"
      ]);
    });

    test('trim filter', () {
      final TrimFilter f = new TrimFilter();
      final List<String> tokens = <String>[' a a '];
      expect(f.filter(tokens).toList(), <String>['a a']);
    });

    test('compound words filter', () {
      final CompoundWordsFilter f =
          new CompoundWordsFilter(<String>['Donau', 'dampf', 'schiff']);
      final List<String> tokens = <String>['Donaudampfschiff'];
      expect(f.filter(tokens).toList(),
          <String>['Donaudampfschiff', 'Donau', 'dampf', 'schiff']);
    });
  });
}
