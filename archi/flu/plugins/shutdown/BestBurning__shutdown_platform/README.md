# Shutdown

This allows the User on desktop to initiate a OS shutdwn.

We need to detect if the OS is shutting down so we can make sure the user has a chance to save their work if they are in a form.



FIX:

module shutdown_platform_example/go

go 1.14

require (
	github.com/BestBurning/shutdown_platform/go v0.1.0
	github.com/go-flutter-desktop/go-flutter v0.42.0
	github.com/pkg/errors v0.9.1
)

//replace github.com/BestBurning/shutdown_platform/go => /Users/shuai/Documents/GitRepo/mine/shutdown_platform/go
