# ducene

Facet Search For Flutter

Golang Server can use bleve or blast or other.
Can be embedded inside flutter for offline.

I think we can do this with HIVE actually.


## DEMO

https://ouava.github.io/#/pubsearch

demo code: https://github.com/ouava/ouava.github.io


## Usage

A simple usage example:

```
Future main() async {
  // open an index holder
  IndexHolder index = await DirectoryHolder.open(new RAMIndexHolderDirectory());
  // prepare documents
  List<Document> docs = [new Document()...];
  // add or update documents
  await index.updateDocuments(docs);
  // open a searcher
  IndexSearcher searcher = await index.newIndexSearcher();
  // count by query
  int count = await searcher.count(new BoolQuery()...);
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://bitbucket.org/ouava/ducene/issues
