# telegram 

Worldwide non blockable messageing system .

Wireguard
- Run on Cloud.

Clients need some thing to get a list of our VPN Nodes. So use wireguard
- Telegram use this to get aroudn the blocks in Iran, China and Russia

Use as an ordered message queue.
- We just put our protobufs there 
- But it enforces on number per account.
	- SO we peek on the protobuf to see who it should go to and send it out via the VPN.

Entry via Tor.

## blocks



## Bot API

https://github.com/requilence/integram
- nice base messaging server stuff
- run local from: https://github.com/requilence/integram/blob/master/cmd/single-process-mode/main.go_example
	- uses https://github.com/integram-org
	- these are examples

search: https://github.com/search?l=&o=desc&q=telegram+language%3AGo&s=indexed&type=Code

https://github.com/go-telegram-bot-api/telegram-bot-api

- most commonly used
- https://github.com/Syfaro/finch
	- by same author
	- validats the SSL certs



## Telegram DB

This is the Telegram Client

https://github.com/tdlib/td/blob/master/example/README.md#dart

Flutter
https://github.com/periodicaidan/dart_tdlib
- generates the API and uses Dart FFI. NICE

golang
https://github.com/zelenin/go-tdlib
