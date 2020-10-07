# CI

The main Server will need to run a static server to provide:
- Flutter Web
- Docs ( hugo based).
- Possibly Other static sites from hugo like News or Directory Services outside Flutter


# Git

We should stick with Github for now.
Makes the project more visible and just works.


# CI - Continuous Integration

I prefer to run all CI on our own boxes with just make files from the repo.
So the same makefiles a Dev uses is what CI uses. Much easier 

- Intel NUC with Windows
- Mac Mini with Mac OS.

Options:
- Drone
-  https://github.com/jpillora/cloud-gox
	- Sort of line Drone, but simpler

Artifacts are:

- Flutter web as a tar.
- Server binary that is tar
- Hugo public content folder as a tar.

Later, artifacts will be Desktop and Mobile clients
- these have to be signed and pushed through their apps stores.
- I think we will run all this on our own hardware as doing it on github is a huge huge PITA.
- And we need a Mac and Windows box anyway for doing UAT testing anyway.
- Will run this in Berlin on site.

Use GoReleaser for all golang binaries.

Release tags we use: 
- We need alpha, beta and stable.

So git webhooks will tell our CI Server, and it will pull and do a build.
Then it will push them to our Binary Server.

## Binary Server

A Binary Server ( Google S3) then grabs the tars and puts them in the right folder
- Project Folder
	- Alpha
	- Beta
	- Stable
- File namning is what goreleser uses.

## Updating process

For V1 we just do it all off github Actions:

Use gorelease in the github actions
https://github.com/goreleaser/goreleaser-action

Use this inside the deployed binary.
https://github.com/rhysd/go-github-selfupdate
- Updates from Github releases

For V1, we run our own CI:

SO each deployed Server just polls the Binary Server for updates, based on its config.

For flutter web and hugo, the deployed Server will then pull the tar and unpack it to the correct directory.

For the main Server, the server will fork and replace

- https://github.com/jpillora/overseer
	- check it works on linux
	- Desktops will be running the binary as a Service, check it works. Not sure it will.
	- Has a poller to check for updates from binary server !

https://github.com/heetch/s3update
- Updates golang apps via s3
- Uses the golang Verson flag: "go build -ldflags "-X main.Version=111" main.go"



## How to run Alpha, beta and stable ?

### Options 1

Its best to isolate them on different servers because that gives a clean setups and no false positives.

We will just use subdomains to delineate it
- alpha.example.com
- beta.example.com
- www.example.com

TLS is done by the golang server and does NOT do wildcards

### Option 2

Run alpha, beta and stable on the one server using Caddy2  / Envoy forward proxy.

This means running a 2nd binary, but its not that bad.

TLS can be done at the goang server level or We have to do at Caddy Level ?
- I really want to do it at golang Server level so that Desktops running the Sysem are the same.

## Flutter web

Main Server binary needs needs a static server
- make sure caching and cache busting works properly...
- Might want basic auth for hidding alpha and beta releases

## GRPC

Standard stuff.

## Hugo docs

Just the same serving semantics as Flutter Web.


https://liveaverage.com/projects/integration-mermaid/
- AMP and mermaid. Basically perfect !!

### Sequence diagrams

https://mermaid.ink/

https://github.com/mermaid-js 
- is kick arse
- can just add links to Markdown.
- Edit and View have identical except for the URL have "View" or Edit in it.
	- SO there is no storage, and its all encoded in the URL :) 

https://github.com/mermaid-js/mermaid-live-editor
- Need to embed this in the golang server itself, as its acts as docs and makes interpreting the Telemetry easy.
- Users
	- https://github.com/hello2mao/go-common/blob/master/incubator/fsm/utils.go

	- https://github.com/Heiko-san/mermaidgen
		- https://github.com/Heiko-san/mermaidgen/blob/master/gantt/Gantt_test.go#L101



View:
https://mermaid-js.github.io/mermaid-live-editor/#/view/eyJjb2RlIjoic2VxdWVuY2VEaWFncmFtXG4gICAgTm9kZSBBLT4-RHJpdmVyIEE6IEVtaXQgVG8gYERyaXZlciBCYFxuICAgIERyaXZlciBBLT4-UHJvdmlkZXIgQTogRmluZCBQcm92aWRlcnNcbiAgICBOb3RlIG92ZXIgRHJpdmVyIEEsUHJvdmlkZXIgQTogYERyaXZlciBBYCBpcyBsb29raW5nIGZvciBgRHJpdmVyIEJgXG4gICAgcGFydGljaXBhbnQgTmV0d29ya1xuICAgIFByb3ZpZGVyIEEtLT4-K1Byb3ZpZGVyIEI6IEJyb2FkY2FzdCBQZWVySW5mb1xuICAgIE5vdGUgb3ZlciBQcm92aWRlciBBLFByb3ZpZGVyIEI6IGBQcm92aWRlciBBYCBCcm9hZGNhc3QgaGlzIElEIG92ZXIgdGhlIE5ldHdvcmsgdG8gZmluZCBgUHJvdmlkZXIgQmBcbiAgICBsb29wIEhhbmRsZSBQcm92aWRlclxuICAgICAgIFByb3ZpZGVyIEItPj5Qcm92aWRlciBBOiBDb25uZWN0XG4gICAgICAgUHJvdmlkZXIgQi0-PlByb3ZpZGVyIEE6IFNlbmQgYmFjayBQZWVySW5mb1xuICAgICAgIE5vdGUgb3ZlciBQcm92aWRlciBBLFByb3ZpZGVyIEI6IGBQcm92aWRlciBCYCBSZWNlaXZlIHRoZSBicm9hZGNhc3QgYW5kIHRyeSB0byBjb25uZWN0IHRvIGBQcm92aWRlciBBYFxuICAgIGVuZFxuICAgIFByb3ZpZGVyIEEtPj4rRHJpdmVyIEE6IExpc3Qgb2YgcHJvdmlkZXJzXG4gICAgTm90ZSBvdmVyIFByb3ZpZGVyIEEsRHJpdmVyIEE6IGBQcm92aWRlciBCYCBQZWVySW5mb1xuICAgIGxvb3AgZm9yIGVhY2ggcHJvdmlkZXJzXG4gICAgICAgRHJpdmVyIEEtPj5Ecml2ZXIgQjogQ29ubmVjdFxuICAgICAgIERyaXZlciBBLT4-RHJpdmVyIEI6IE9wZW4gQSBzdHJlYW1cbiAgICAgICBEcml2ZXIgQS0-PkRyaXZlciBCOiBTZW5kIEV2ZWxvcGVcbiAgICAgICBOb3RlIG92ZXIgRHJpdmVyIEEsRHJpdmVyIEI6IFNlbmQgdGhlIGVudmVsb3BlIHRvIERyaXZlciBCXG4gICAgZW5kXG4gICAgbG9vcCBIYW5kbGUgRW52ZWxvcGVcbiAgICAgICBEcml2ZXIgQi0-Pk5vZGUgQjogUmVjZWl2ZSBlbnZlbG9wZVxuICAgIGVuZFxuIiwibWVybWFpZCI6eyJ0aGVtZSI6ImRlZmF1bHQifX0


Edit:
https://mermaid-js.github.io/mermaid-live-editor/#/edit/eyJjb2RlIjoic2VxdWVuY2VEaWFncmFtXG4gICAgTm9kZSBBLT4-RHJpdmVyIEE6IEVtaXQgVG8gYERyaXZlciBCYFxuICAgIERyaXZlciBBLT4-UHJvdmlkZXIgQTogRmluZCBQcm92aWRlcnNcbiAgICBOb3RlIG92ZXIgRHJpdmVyIEEsUHJvdmlkZXIgQTogYERyaXZlciBBYCBpcyBsb29raW5nIGZvciBgRHJpdmVyIEJgXG4gICAgcGFydGljaXBhbnQgTmV0d29ya1xuICAgIFByb3ZpZGVyIEEtLT4-K1Byb3ZpZGVyIEI6IEJyb2FkY2FzdCBQZWVySW5mb1xuICAgIE5vdGUgb3ZlciBQcm92aWRlciBBLFByb3ZpZGVyIEI6IGBQcm92aWRlciBBYCBCcm9hZGNhc3QgaGlzIElEIG92ZXIgdGhlIE5ldHdvcmsgdG8gZmluZCBgUHJvdmlkZXIgQmBcbiAgICBsb29wIEhhbmRsZSBQcm92aWRlclxuICAgICAgIFByb3ZpZGVyIEItPj5Qcm92aWRlciBBOiBDb25uZWN0XG4gICAgICAgUHJvdmlkZXIgQi0-PlByb3ZpZGVyIEE6IFNlbmQgYmFjayBQZWVySW5mb1xuICAgICAgIE5vdGUgb3ZlciBQcm92aWRlciBBLFByb3ZpZGVyIEI6IGBQcm92aWRlciBCYCBSZWNlaXZlIHRoZSBicm9hZGNhc3QgYW5kIHRyeSB0byBjb25uZWN0IHRvIGBQcm92aWRlciBBYFxuICAgIGVuZFxuICAgIFByb3ZpZGVyIEEtPj4rRHJpdmVyIEE6IExpc3Qgb2YgcHJvdmlkZXJzXG4gICAgTm90ZSBvdmVyIFByb3ZpZGVyIEEsRHJpdmVyIEE6IGBQcm92aWRlciBCYCBQZWVySW5mb1xuICAgIGxvb3AgZm9yIGVhY2ggcHJvdmlkZXJzXG4gICAgICAgRHJpdmVyIEEtPj5Ecml2ZXIgQjogQ29ubmVjdFxuICAgICAgIERyaXZlciBBLT4-RHJpdmVyIEI6IE9wZW4gQSBzdHJlYW1cbiAgICAgICBEcml2ZXIgQS0-PkRyaXZlciBCOiBTZW5kIEV2ZWxvcGVcbiAgICAgICBOb3RlIG92ZXIgRHJpdmVyIEEsRHJpdmVyIEI6IFNlbmQgdGhlIGVudmVsb3BlIHRvIERyaXZlciBCXG4gICAgZW5kXG4gICAgbG9vcCBIYW5kbGUgRW52ZWxvcGVcbiAgICAgICBEcml2ZXIgQi0-Pk5vZGUgQjogUmVjZWl2ZSBlbnZlbG9wZVxuICAgIGVuZFxuIiwibWVybWFpZCI6eyJ0aGVtZSI6ImRlZmF1bHQiLCJ0aGVtZVZhcmlhYmxlcyI6eyJiYWNrZ3JvdW5kIjoid2hpdGUiLCJwcmltYXJ5Q29sb3IiOiIjRUNFQ0ZGIiwic2Vjb25kYXJ5Q29sb3IiOiIjZmZmZmRlIiwidGVydGlhcnlDb2xvciI6ImhzbCg4MCwgMTAwJSwgOTYuMjc0NTA5ODAzOSUpIiwicHJpbWFyeUJvcmRlckNvbG9yIjoiaHNsKDI0MCwgNjAlLCA4Ni4yNzQ1MDk4MDM5JSkiLCJzZWNvbmRhcnlCb3JkZXJDb2xvciI6ImhzbCg2MCwgNjAlLCA4My41Mjk0MTE3NjQ3JSkiLCJ0ZXJ0aWFyeUJvcmRlckNvbG9yIjoiaHNsKDgwLCA2MCUsIDg2LjI3NDUwOTgwMzklKSIsInByaW1hcnlUZXh0Q29sb3IiOiIjMTMxMzAwIiwic2Vjb25kYXJ5VGV4dENvbG9yIjoiIzAwMDAyMSIsInRlcnRpYXJ5VGV4dENvbG9yIjoicmdiKDkuNTAwMDAwMDAwMSwgOS41MDAwMDAwMDAxLCA5LjUwMDAwMDAwMDEpIiwibGluZUNvbG9yIjoiIzMzMzMzMyIsInRleHRDb2xvciI6IiMzMzMiLCJtYWluQmtnIjoiI0VDRUNGRiIsInNlY29uZEJrZyI6IiNmZmZmZGUiLCJib3JkZXIxIjoiIzkzNzBEQiIsImJvcmRlcjIiOiIjYWFhYTMzIiwiYXJyb3doZWFkQ29sb3IiOiIjMzMzMzMzIiwiZm9udEZhbWlseSI6IlwidHJlYnVjaGV0IG1zXCIsIHZlcmRhbmEsIGFyaWFsIiwiZm9udFNpemUiOiIxNnB4IiwibGFiZWxCYWNrZ3JvdW5kIjoiI2U4ZThlOCIsIm5vZGVCa2ciOiIjRUNFQ0ZGIiwibm9kZUJvcmRlciI6IiM5MzcwREIiLCJjbHVzdGVyQmtnIjoiI2ZmZmZkZSIsImNsdXN0ZXJCb3JkZXIiOiIjYWFhYTMzIiwiZGVmYXVsdExpbmtDb2xvciI6IiMzMzMzMzMiLCJ0aXRsZUNvbG9yIjoiIzMzMyIsImVkZ2VMYWJlbEJhY2tncm91bmQiOiIjZThlOGU4IiwiYWN0b3JCb3JkZXIiOiJoc2woMjU5LjYyNjE2ODIyNDMsIDU5Ljc3NjUzNjMxMjglLCA4Ny45MDE5NjA3ODQzJSkiLCJhY3RvckJrZyI6IiNFQ0VDRkYiLCJhY3RvclRleHRDb2xvciI6ImJsYWNrIiwiYWN0b3JMaW5lQ29sb3IiOiJncmV5Iiwic2lnbmFsQ29sb3IiOiIjMzMzIiwic2lnbmFsVGV4dENvbG9yIjoiIzMzMyIsImxhYmVsQm94QmtnQ29sb3IiOiIjRUNFQ0ZGIiwibGFiZWxCb3hCb3JkZXJDb2xvciI6ImhzbCgyNTkuNjI2MTY4MjI0MywgNTkuNzc2NTM2MzEyOCUsIDg3LjkwMTk2MDc4NDMlKSIsImxhYmVsVGV4dENvbG9yIjoiYmxhY2siLCJsb29wVGV4dENvbG9yIjoiYmxhY2siLCJub3RlQm9yZGVyQ29sb3IiOiIjYWFhYTMzIiwibm90ZUJrZ0NvbG9yIjoiI2ZmZjVhZCIsIm5vdGVUZXh0Q29sb3IiOiJibGFjayIsImFjdGl2YXRpb25Cb3JkZXJDb2xvciI6IiM2NjYiLCJhY3RpdmF0aW9uQmtnQ29sb3IiOiIjZjRmNGY0Iiwic2VxdWVuY2VOdW1iZXJDb2xvciI6IndoaXRlIiwic2VjdGlvbkJrZ0NvbG9yIjoicmdiYSgxMDIsIDEwMiwgMjU1LCAwLjQ5KSIsImFsdFNlY3Rpb25Ca2dDb2xvciI6IndoaXRlIiwic2VjdGlvbkJrZ0NvbG9yMiI6IiNmZmY0MDAiLCJ0YXNrQm9yZGVyQ29sb3IiOiIjNTM0ZmJjIiwidGFza0JrZ0NvbG9yIjoiIzhhOTBkZCIsInRhc2tUZXh0TGlnaHRDb2xvciI6IndoaXRlIiwidGFza1RleHRDb2xvciI6IndoaXRlIiwidGFza1RleHREYXJrQ29sb3IiOiJibGFjayIsInRhc2tUZXh0T3V0c2lkZUNvbG9yIjoiYmxhY2siLCJ0YXNrVGV4dENsaWNrYWJsZUNvbG9yIjoiIzAwMzE2MyIsImFjdGl2ZVRhc2tCb3JkZXJDb2xvciI6IiM1MzRmYmMiLCJhY3RpdmVUYXNrQmtnQ29sb3IiOiIjYmZjN2ZmIiwiZ3JpZENvbG9yIjoibGlnaHRncmV5IiwiZG9uZVRhc2tCa2dDb2xvciI6ImxpZ2h0Z3JleSIsImRvbmVUYXNrQm9yZGVyQ29sb3IiOiJncmV5IiwiY3JpdEJvcmRlckNvbG9yIjoiI2ZmODg4OCIsImNyaXRCa2dDb2xvciI6InJlZCIsInRvZGF5TGluZUNvbG9yIjoicmVkIiwibGFiZWxDb2xvciI6ImJsYWNrIiwiZXJyb3JCa2dDb2xvciI6IiM1NTIyMjIiLCJlcnJvclRleHRDb2xvciI6IiM1NTIyMjIiLCJjbGFzc1RleHQiOiIjMTMxMzAwIiwiZmlsbFR5cGUwIjoiI0VDRUNGRiIsImZpbGxUeXBlMSI6IiNmZmZmZGUiLCJmaWxsVHlwZTIiOiJoc2woMzA0LCAxMDAlLCA5Ni4yNzQ1MDk4MDM5JSkiLCJmaWxsVHlwZTMiOiJoc2woMTI0LCAxMDAlLCA5My41Mjk0MTE3NjQ3JSkiLCJmaWxsVHlwZTQiOiJoc2woMTc2LCAxMDAlLCA5Ni4yNzQ1MDk4MDM5JSkiLCJmaWxsVHlwZTUiOiJoc2woLTQsIDEwMCUsIDkzLjUyOTQxMTc2NDclKSIsImZpbGxUeXBlNiI6ImhzbCg4LCAxMDAlLCA5Ni4yNzQ1MDk4MDM5JSkiLCJmaWxsVHlwZTciOiJoc2woMTg4LCAxMDAlLCA5My41Mjk0MTE3NjQ3JSkifX19