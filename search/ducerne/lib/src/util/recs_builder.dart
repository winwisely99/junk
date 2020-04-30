// Copyright (c) 2017, Shinichiro Abe. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:ducene/index.dart';
import 'package:ducene/search.dart';
import 'package:ducene/util.dart';

class RecsBuilderConfig {
  //
  String fieldNameForUser;
  String fieldNameForItem;
  String fieldNameForRating;
  //
  final String userFieldName = "user";
  final String itemFieldName = "item";
  final String ratingFieldName = "rating";
  //
  final String mainItemFieldName = "mainItem";
  final String otherItemFieldName = "otherItem";
  final String similarityFieldName = "similarity";
}

class RecsBuilder {
  static Future<Null> addEvents(IndexHolder events, List<Document> docs) async {
    await events.updateDocuments(docs);
  }

  static Future<Null> transformEvents(RecsBuilderConfig config,
      IndexHolder events, IndexHolder userItem) async {
    final IndexSearcher searcher = await events.newRealTimeIndexSearcher();

    final Iterable<String> users =
        await _collectUsers(config.fieldNameForUser, searcher);
    for (String user in users) {
      final Set<String> items = await _collectItemsByUser(
          config.fieldNameForUser, user, config.fieldNameForItem, searcher);
      for (String item in items) {
        final String rating = await _sumRatingsGroupingByUserAndItem(
            config.fieldNameForUser,
            user,
            config.fieldNameForItem,
            item,
            config.fieldNameForRating,
            searcher);
        await _saveRating(userItem, config.userFieldName, user,
            config.itemFieldName, item, config.ratingFieldName, rating);
      }
    }
  }

  static Future<Null> buildItemSimilarity(RecsBuilderConfig config,
      IndexHolder userItem, IndexHolder itemSimilarity) async {
    final IndexSearcher searcher = await userItem.newRealTimeIndexSearcher();

    final Iterable<String> itemColumns =
        await _collectItems(config.itemFieldName, searcher);
    final Iterable<String> itemRows = itemColumns;

    final Iterable<String> users =
        await _collectUsers(config.userFieldName, searcher);

    for (String mainItem in itemRows) {
      final List<double> vectorA = await _getVector(users, config.userFieldName,
          config.itemFieldName, mainItem, config.ratingFieldName, searcher);

      for (String otherItem in itemColumns) {
        final List<double> vectorB = await _getVector(
            users,
            config.userFieldName,
            config.itemFieldName,
            otherItem,
            config.ratingFieldName,
            searcher);

        final String sim = (mainItem != otherItem)
            ? cosineSim(vectorA, vectorB).toString()
            : 1.00.toString();

        await _saveSimilarity(
            itemSimilarity,
            config.mainItemFieldName,
            mainItem,
            config.otherItemFieldName,
            otherItem,
            config.similarityFieldName,
            sim);
      }
    }
  }

  static Future<Null> predictRatings(
      RecsBuilderConfig config,
      IndexHolder userItem,
      IndexHolder itemSimilarity,
      IndexHolder predictRatings) async {
    final IndexSearcher userItemSearcher =
        await userItem.newRealTimeIndexSearcher();

    final IndexSearcher itemSimilaritySearcher =
        await itemSimilarity.newRealTimeIndexSearcher();

    final Set<String> items =
        (await _collectItems(config.itemFieldName, userItemSearcher)).toSet();

    final Iterable<String> users =
        await _collectUsers(config.userFieldName, userItemSearcher);

    for (String user in users) {
      final Set<String> seenItems = await _getSeenItemsByUser(
          config.userFieldName, user, config.itemFieldName, userItemSearcher);
      final Set<String> unseenItems = items.difference(seenItems);

      for (String unseenItem in unseenItems) {
        final Map<String, double> simsByUnseenItem =
            await _getSimilaritiesByItem(
                config.mainItemFieldName,
                unseenItem,
                config.otherItemFieldName,
                config.similarityFieldName,
                itemSimilaritySearcher);

        final Map<String, double> userRatings = <String, double>{};
        for (String seenItem in seenItems) {
          final double rating = await _getRatingsByUserAndItem(
              config.userFieldName,
              user,
              config.itemFieldName,
              seenItem,
              config.ratingFieldName,
              userItemSearcher);
          userRatings[seenItem] = rating;
        }

        double predictRating = 0.00;
        double weightedRatingSum = 0.00;
        double similaritySum = 0.00;
        for (String item in userRatings.keys) {
          final double itemSim = simsByUnseenItem[item];
          final double itemRating = userRatings[item];
          final double weightedRating = itemSim * itemRating;
          weightedRatingSum += weightedRating;
          similaritySum += itemSim;
        }
        if (similaritySum > 0.00) {
          predictRating = weightedRatingSum / similaritySum;
        }

        await _saveRating(
            predictRatings,
            config.userFieldName,
            user,
            config.itemFieldName,
            unseenItem,
            config.ratingFieldName,
            predictRating.toString());
      }
    }
  }

  static double cosineSim(List<double> vectorA, List<double> vectorB) {
    double numerator = 0.00;
    double denominator = 0.00;
    double denominatorA = 0.00;
    double denominatorB = 0.00;
    int i = 0;
    for (double a in vectorA) {
      final double b = vectorB[i];
      numerator += a * b;
      i++;
    }
    for (double a in vectorA) {
      denominatorA += a * a;
    }
    denominatorA = sqrt(denominatorA);
    for (double b in vectorB) {
      denominatorB += b * b;
    }
    denominatorB = sqrt(denominatorB);
    denominator = denominatorA * denominatorB;
    if (denominator < 0.00) denominator = 1.00;
    return numerator / denominator;
  }

  static Future<Iterable<String>> _collectUsers(
      String userFieldName, IndexSearcher searcher) async {
    return await _getTerms(userFieldName, searcher);
  }

  static Future<Iterable<String>> _collectItems(
      String itemFieldName, IndexSearcher searcher) async {
    return await _getTerms(itemFieldName, searcher);
  }

  static Future<Iterable<String>> _getTerms(
      String fieldName, IndexSearcher searcher) async {
    return await searcher.reader.terms(fieldName);
  }

  static Future<Set<String>> _collectItemsByUser(String userFieldName,
      String user, String itemFieldName, IndexSearcher searcher) async {
    final Set<String> items = new Set<String>();
    final TopDocs docs = await searcher.search(
        new BoolQuery()
            .addQuery(new MatchAllDocsQuery())
            .addFilter(new TermQuery(new Term(userFieldName, user))),
        1000);
    for (ScoreDoc d in docs.scoreDocs) {
      final String item =
          (await searcher.doc(d.doc, fieldsToLoad: <String>[itemFieldName]))
              .get(itemFieldName);
      items.add(item);
    }
    return items;
  }

  static Future<String> _sumRatingsGroupingByUserAndItem(
      String userFieldName,
      String user,
      String itemFieldName,
      String item,
      String ratingFieldName,
      IndexSearcher searcher) async {
    final TopDocs docs = await searcher.search(
        new BoolQuery()
            .addQuery(new MatchAllDocsQuery())
            .addFilter(new TermQuery(new Term(userFieldName, user)))
            .addFilter(new TermQuery(new Term(itemFieldName, item))),
        1000);
    final StatsResult statsResult = await FieldStats.getStats(
        docs.docSet, ratingFieldName, searcher.reader);
    final String rating = statsResult.sum.toString();
    return rating;
  }

  static Future<Null> _saveRating(
      IndexHolder collection,
      String userFieldName,
      String user,
      String itemFieldName,
      String item,
      String ratingFieldName,
      String rating) async {
    await _saveResult(collection, userFieldName, user, itemFieldName, item,
        ratingFieldName, rating);
  }

  static Future<Null> _saveSimilarity(
      IndexHolder collection,
      String mainItemFieldName,
      String mainItem,
      String otherItemFieldName,
      String otherItem,
      String simFieldName,
      String sim) async {
    await _saveResult(collection, mainItemFieldName, mainItem,
        otherItemFieldName, otherItem, simFieldName, sim);
  }

  static Future<Null> _saveResult(
      IndexHolder collection,
      String fieldName1,
      String fieldValue1,
      String fieldName2,
      String fieldValue2,
      String fieldName3,
      String fieldValue3) async {
    await collection.updateDocuments(<Document>[
      new Document()
          .append("id", new DateTime.now().millisecondsSinceEpoch.toString())
          .append(fieldName1, fieldValue1)
          .append(fieldName2, fieldValue2)
          .append(fieldName3, fieldValue3)
    ]);
  }

  static Future<double> _getRatingsByUserAndItem(
      String userFieldName,
      String user,
      String itemFieldName,
      String item,
      String ratingFieldName,
      IndexSearcher searcher) async {
    final TopDocs docs = await searcher.search(
        new BoolQuery()
            .addQuery(new MatchAllDocsQuery())
            .addFilter(new TermQuery(new Term(userFieldName, user)))
            .addFilter(new TermQuery(new Term(itemFieldName, item))),
        1);
    double ret = 0.00;
    if (docs.totalHits > 0) {
      final String rating = (await searcher.doc(docs.scoreDocs[0].doc,
              fieldsToLoad: <String>[ratingFieldName]))
          .get(ratingFieldName);
      ret = double.parse(rating);
    }
    return ret;
  }

  static Future<List<double>> _getVector(
      Iterable<String> users,
      String userFieldName,
      String itemFieldName,
      String item,
      String ratingFieldName,
      IndexSearcher searcher) async {
    final List<double> vector = <double>[];
    for (String user in users) {
      final double rating = await _getRatingsByUserAndItem(
          userFieldName, user, itemFieldName, item, ratingFieldName, searcher);
      vector.add(rating);
    }
    return vector;
  }

  static Future<Set<String>> _getSeenItemsByUser(String userFieldName,
      String user, String itemFieldName, IndexSearcher searcher) async {
    final Set<String> seenItems = new Set<String>();
    final TopDocs docs = await searcher.search(
        new BoolQuery()
            .addQuery(new MatchAllDocsQuery())
            .addFilter(new TermQuery(new Term(userFieldName, user))),
        1);
    final Map<String, FacetValue> seen =
        await FieldFacet.getCount(docs.docSet, itemFieldName, searcher.reader);
    for (String item in seen.keys) {
      seenItems.add(item);
    }
    return seenItems;
  }

  static Future<Map<String, double>> _getSimilaritiesByItem(
      String mainItemFieldName,
      String item,
      String otherItemFieldName,
      String similarityFieldName,
      IndexSearcher searcher) async {
    final Map<String, double> ret = <String, double>{};
    final TopDocs docs = await searcher.search(
        new BoolQuery()
            .addQuery(new MatchAllDocsQuery())
            .addFilter(new TermQuery(new Term(mainItemFieldName, item))),
        1000);
    if (docs.totalHits > 0) {
      for (ScoreDoc d in docs.scoreDocs) {
        final Document doc = await searcher.doc(d.doc,
            fieldsToLoad: <String>[otherItemFieldName, similarityFieldName]);
        ret[doc.get(otherItemFieldName)] =
            double.parse(doc.get(similarityFieldName));
      }
    }
    return ret;
  }
}
