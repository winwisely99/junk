# ci

ci things

Currently lots of make files that are callable from other projects to build up standard Ci routines.

Eventually change to golang that wraps them.

Use Azure for CI for GUi because it has full desktops running in a VM and so makes proper builds,etc

Make the OS level dependencies also installable via golang wrappers. This will make the CI possible to run locally and in Azure using the exact same code.

Currently for DESKTOP, go-flutter is the clear winner.

https://github.com/smu-gp
- also using grpc


Easiest is to build on a mac.
https://github.com/mikolajdebowski/techviz/tree/development/scripts
Simple and works

Fledge
https://medium.com/@nocnoc/cicd-for-flutter-fdc07fe52abd
https://github.com/mmcc007/fledge
works with jenkins too

AWS Device farm.
https://github.com/mmcc007/sylph
