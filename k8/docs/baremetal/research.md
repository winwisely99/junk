# baremetal


We are building a thing can can run anywhere.
- hosting cloud like google kde
- baremetal cloud like packet
- baremetal on any servers in any colo
- home servers ( like pine64)

This is why we keep the architecture simple and only have
- pass storage
- saas service ( as a monolith)
 - wire together usng importants)


Docker Swarm or k8 ???
- https://blog.cherryservers.com/docker-swarm-vs-kubernetes-the-subtle-differences
- no weird networking layer, so much easier to bring up anywhere.
- the docker compose can be used.

- Can we still sue envoy and gloo to egt the grpc goodies ?
L

Minio on Docker Swarm is easy:
https://docs.min.io/docs/deploy-minio-on-docker-swarm.html

tidb on Docker Swarm is also easy
https://github.com/pingcap/tidb-docker-compose#docker-swarm

nats on Docker Swarm also easy
https://docs.nats.io/nats-streaming-server/swarm




https://github.com/alexellis/awesome-baremetal/blob/master/README.md

# home use cases
you have no choice but to use k8, but k8 is envoy mostly.
So on home servers you dont need scaling, pixie, etc etc. You just need envoy and docker almost.
Then the agent joins you to the cloud via a tunnel, so you dont need a public static IP.
For HA of PAAS you need 3 servers though.
- BUT with minio and tidb you can spread that with friends servers in other locations ( like giving one to your brother, etc)
	- and it will work for low mutatation scenarioes
	- And the tunnel can tell you their IP and you can then go use a webrtc tunel if you trust them.

## baremetal cloud like packet

https://www.packet.com/
- x86_64 & arm64

Full k8 using https://github.com/kinvolk/lokomotive-kubernetes
- suppott packet currently.

# baremetal on any servers in any colo

Need Pixie boot and then a K8s Cloud Controller Manager for Metal
https://github.com/metal-stack/metal-ccm

matchmaker
