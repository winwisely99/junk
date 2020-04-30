# Stuff we need for dev

Open Core Model and how it works in practice

## Core
- runs on our own stuff.
- Is maintemplate and k8 with no data.
- data pumper loads it with generic data.
- CI 
- Customers get the outputs ( stable, beta)
	- clients on their mobiles
	- k8s on their servers
- Customers will make their own MicroServices to extend the system.
 - so they can be on dev or beta, etc.
 - they can take our maintemplate and add their modules into the router.


## Divisions (open source on github)

- CGN / XR( global protests)
	- github and or run on your own stuff.
- Aearth (global sensing)
- Other


We help them deploy core k8.
They write their own data pumps to put the data into PAAS.
They sign the clients with their own legal entity.
They go LIVE

Upgrade them from a version of ours.


## Core Infra

We must run our Dev tools on our own Infrastructure.

- domain (one page website)

Hardware Options
- Beefy Rented Servers (2) in Berlin at hertzner ( VM )
- 2 intel nucs with big SSD on premise plugged into router.
	- no public IP and not NATed
	- Use inlets or ip tunnel so others can reach it for
		- Web GUI for devs to see CI.
		- ssh based ops into host
		- VNC into the vagrants

Stack

Tunnel to securely access the Servers anywhere
- https://github.com/square/ghostunnel


gitea for git 
- dont make ours public.
	- public is a mirror out to github for the world
- golang.
- web GUi same as github.
- HA: 
	- 2 dockers on different server.
	- master mirrors to slave.

CI / CD
- Drone
- gitea setup: https://dev.to/ruanbekker/self-hosted-cicd-with-gitea-and-drone-ci-200l
	- https://github.com/appleboy/drone-git-push
- vagrant: https://github.com/appleboy/drone-packer
- telegram: https://github.com/appleboy/drone-telegram
- ssh: https://github.com/appleboy/drone-ssh
- web site: https://github.com/appleboy/gh-pages-action


vagrant for CI (daryl)
- https://github.com/bitsydarel/flutter-ci
- vagrant boxes: https://app.vagrantup.com/bitsydarel
- runs mac, windows and linux
- so we can use our makefiles to do all out builds of Clients.
- Gets hooks from Gitea to kick off builds.
	- get a golang agent setup
	- with a Web GUI. BASIC.
- stores builds into our minio.

docker registry
- https://github.com/goharbor/harbor
- to hold our dockers.
- use docker compose.

minio
- anything that cant go into git.
- builds
- data loader
- HA
	- 2 dockers on different server
	- master mirrors to slave.




