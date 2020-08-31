# db-files

We can use the DB and chunk files in and out
- that does mean some pretty complex code for client to do the GRPC stuff

Or we can be nice and have a proper file storage.

## minikeyvalue

https://github.com/commaai/minikeyvalue
https://github.com/geohot/minikeyvalue
- nice and simple 
- by the commm AI crazy dude.
- uses goleveldb to hold the file index, and then just hits the FS
	 - we coudl easiyl get it to use whatever real DB we decide on like dragonboat stuff.
- uses Nginx 
