# dev

From the protobuf describing a config we gen the code that uses it.
Maintemplate uses the fully compose one
Mods use the partial one.

In dart maintemplate cna then pass down the generated class to the Module.

In golang maintemplate can load it up and pass it down to each mod also.
- and golang can run just a module also.

https://buf.build/docs/tour-1
- nut sure we need it.

https://pub.dev/packages/protoc_plugin

Composition
For proto3, use Any.
For proto2, user extension.
