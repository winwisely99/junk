# Device ID

We need to detect which device the user is on when they have many devices, so you can make sure you push the message from the server that the user is actually using right now.

Needs a simple Presence ping system to know what they are using right now.

Fix needed to make it run:
https://github.com/BestBurning/platform_device_id/issues/4
comment out the replace

update the version to v0.1.1

this now works:

module platform_device_id_example/go

go 1.14

require (
	github.com/BestBurning/platform_device_id/go v0.1.1
	github.com/go-flutter-desktop/go-flutter v0.38.0
	github.com/pkg/errors v0.9.1
)

//replace github.com/BestBurning/platform_device_id/go => D:\gitRepo\platform_device_id\go