## Tools
https://github.com/lu4p

ONION ROuting
He has Tor onion working so clients can connect to it other
https://github.com/lu4p/ToRat/wiki/How-to-use-the-ToRat-Docker-Image
- When the docker is run, it creates a Tor Onion address
- The clients can then connect using the credentials and binaries outputted from the docker build.
- VERY clean !
- Includes Shred to zero out the Disk and leave no traces.

He has all this other great stuff for Golang client stuff

https://github.com/lu4p/binclude
- embeds assets
- respects the go tags and so will include and unpack per OS correctly, just like the golang compiler.

https://github.com/lu4p/garble
- proper real obfuscation