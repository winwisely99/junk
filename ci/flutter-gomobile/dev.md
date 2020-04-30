# flutter mobile


Golang holds
- DB
- Template engine to produce HTML from Html templates and data

Plugin layer
- Protobufs
	- Look in to using this for speed.
- desktop: go-flutter: https://github.com/go-flutter-desktop/hover/pull/33
- mobile: go-mobile: https://github.com/DimitarPetrov/stegify-flutter-plugin

Flutter Layer
- Primarily its data driven.
- Views: HTML rendering the offical widgets.
- Routing: dependent on the roles to users mapping & the roles to flutter views.
	- so it enforces what your routing is.
- Deep linking and Sharing
	- Only share to device. On the the other device the deep linking should route you in to the correct View
- Cache
	- Hive