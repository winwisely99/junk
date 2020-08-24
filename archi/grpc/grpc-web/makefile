print:
	@echo flutter devices: 
	flutter devices

dep:
	git clone https://github.com/duckladydinh/gomessenger

gen:
	cd gomessenger && protoc -Iproto proto/chat_service.proto \
		--go_out=plugins=grpc:gms-go/rpc \
		--dart_out=grpc:gms-flutter/lib/rpc


#  --js_out=import_style=commonjs:gms-web/src/rpc/ \
#  --grpc-web_out=import_style=commonjs,mode=grpcwebtext:gms-web/src/rpc/ \

server-run:
	cd gomessenger/gms-go/main && go run .

flu-web-run:
	cd gomessenger/gms-flutter && flutter run -d chrome

flu-mob-run:
	cd gomessenger/gms-flutter && flutter run -d 