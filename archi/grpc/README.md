# GRPC



## Remove need for envoy

"grpcweb.WrapServer" is the way its done.

https://github.com/duckladydinh/gomessenger
- works ! nice work.
- Check native still works

## Get Certs working locally and remotly
- Add TLS
	- mkcert
	- flatend autocert code.

Server TLS - AutoCert
https://github.com/lithdew/flatend
- adapt to store Certs on Google Buckets
https://github.com/caddyserver/certmagic