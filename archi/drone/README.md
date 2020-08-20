# Drone


## Hardware

Run all of it offsite on our hardware.

- Intel NUC with Windows
- Mac Mini with Mac OS.

## Network

wireguard for all CI Boxes.
- Use teamviewer to configure or ssh.

Inlets for the Web Client and Server
- so users can test it.

## Backup

- Gitea: Just set each one to backup to the other one.
- Drone: not sure what it needs yet

## Updates

All deployed software ( clients and servers ) just uses a NATS subscription to be told when a new version is available.

All Builds are held on the Gateway or Relay server itself and get replicated to all Relay Servers in the cluster.
The Internal team can promote a Build version to a Build channel, but just moving the build to the appropriate folder, or use the NATS CLi to do it.

Builds to use a channel names as such:
- Canary: bleeding edge from the CI directly
- Beta: UAT tested but will have some bugs
- Stable: User Tested on a few Users, so we know its ok.

The software can self update on Servers, Web and Desktop
- Android, we can do self update on android
- IOS, we need to use fastlane.

## Build as a Service

https://github.com/jpillora/cloud-gox
- Sort of line Drone, but simpler