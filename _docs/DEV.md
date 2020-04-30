# dev

Flutter markdown

Why both converting to HTML like HUGO etc. Instead publish the raw HTML and lets Flutter do it.

Runtime loading. Because we are using only the markdown, we can reload the docs without restarting or redeploying the app.
- huge dev speed
- easy mass deployment.
It can just use a


Markdown can be in HIVE and pulled from anywhere, so is updatable without updating the app !
- Google sheets give us the multi-language 
- Basic server can do the transformation in real time listening to the google sheets.

https://pub.dev/packages/flutter_markdown
- google supported


## Image Support
We use Google Canvas for Diagramming.
- it only supports Image output but good enough.

https://github.com/Holmusk/s3_cache_image
- cache off s3.
- this gives us good backing against google storage and minio.


## Search Support

Two primary options
- generate the index serve side and have the client use it.
- generate the index client side using HIVE
	- HIVE could maybe do it.
	- Golang / RUST embeding can def do it but complexity we dont need yet.

SO a basic HIVE approach flow:
- Parse the makrdown for words
	- also need their position. 
- Save a mapping of Markdown docs to words in HIVE
- On Search hit the Index and get back Markdown endpoints.


## Editor Support
This will allow online editing.

https://github.com/infitio/flutter_markdown
- not using anyone else.

https://github.com/memspace/zefyr
- outputs to Markdown BUT NOT at all finished.
- OT over the Textile gives RTC over P2P to show the system working itself
- We can embed the golang based Google translator inside OR run a Server that gets the changes and updates the Google Sheets and spits back all translations.
- Forks graph: https://github.com/memspace/zefyr/network
	- Most recent: https://github.com/Genzhalo/zefyr
	- also far ahead: https://github.com/Yom3n/zefyr


## Other 


https://github.com/X-Wei/flutter_catalog
- hive_flutter
- flutter_markdown
- go-flutter
- cached_network_image
- REMOVE AL FIREBASE crap.





