# stack

The stack is the big picture view of how the system layers work together.

You need to understand this if you wish to write new Modules.



## DNS

Google Anycast

## Clients

Clients can be in any language but its best if they support

- GRPC
- S3
- oAuth2

GRPC Support covers these langages: https://chromium.googlesource.com/chromium/src/+/master/third_party/protobuf/docs/third_party.md

## SAAS

Software layer (MicroServices) in any language to be used by the Client Layer

We run a sidecar Envoy for all of their microservices, forming a mesh.

envoy (data plane)
- to load balance connections, apply security aspects and for grpc and grpc-web support.
- It is essentially the data-plane.
- Bench: https://www.loggly.com/blog/benchmarking-5-popular-load-balancers-nginx-haproxy-envoy-traefik-and-alb/
- API: https://github.com/envoyproxy/go-control-plane
- XDS: https://www.envoyproxy.io/docs/envoy/latest/api-docs/xds_protocol
	- Discovery Services

## Edge, Load Balancing and Mesh

Intro: https://www.microservices.com/talks/lyfts-envoy-monolith-service-mesh-matt-klein/

https://www.datawire.io/envoyproxy/envoy-as-api-gateway/

Docs: https://www.getambassador.io/docs/latest/topics/concepts/architecture/





## SAAS Protocols

GRPC
- standard for remote procedure calls

S3
- JSON and images storage
- DB using S3 Select

## PAAS

Platform layer providing HA standard stateful services to be used by the SAAS Layer.

S3 (minio)
minio
- https://minio.getcouragenow.org
- dashboard. Same URL

REDIS
- mutable kv / message sub pub
- yubabyte
- redis.getcouragenow.org
- dashboard

nats ( not streaming )
- nats.getcouragenow.org
- liftbridge.getcouragenow.org

MySQL (TIDB)


## IAAS

This is the actual Servers.

We need to support K8, nomad and IOT devices ( using tinygo )

Deployment Targets:
- Edge singles and Clusters, installed behind NAT Routers.
	- Pine64 ( AMD64) with SSD
	- Rasp Pi is not really preferred.
	- NUC 7i5BNK with NVMe (https://github.com/rancher/k3s/issues/1576)
- Clouds
	- The usual suspects ( google, etc)

For Edges, we need the ability to upgrade them together.
- kubeCtl can do this (e.g. "kubectl label node --all plan.upgrade.cattle.io/k3os-latest=enabled")
- Clouds are used as the Ingress into the Edges.

Gloo is a modern generic Envoy Proxy that can be used with Nomad, Istio, And many other k8 systems.
- It wraps and installs Envoy for you.
	- https://github.com/solo-io/gloo/releases
		- glooctl is the main exe for everything...
	- https://github.com/solo-io/gloo
	- We need Envoy because we rely on GRPC-Web and other filters.
- Its can acts an an ingress controller or gateway
	- https://docs.solo.io/gloo/latest/installation/#2c-install-the-gloo-knative-cluster-ingress-to-your-kubernetes-cluster-using-glooctl
- Is can work with Nomad, Consul etc :)
- What is Enterprise
	- https://www.solo.io/products/gloo/
	- GUI ( Read onyl is included though :) )
	- Security ( Dex, OPA, WAF, etc etc)

Users of gloo:

- K3OS is a OS with k3s included, and is 100$ upgradable remotely.
	- https://github.com/rancher/k3os
- Rio from Rancher also uses it.
	- https://github.com/rancher/rio
	- https://rio.io/


Talos is another approach: https://github.com/talos-systems/talos
	- is pure k8 with firecracker :)
	- remote control: https://github.com/talos-systems/talos/tree/master/cmd/talosctl
	- uses GRPC alot for control, and so not mystical like k8 api machinaery.


Nomad approach:
Its essentially a quasi K8 setup, where K8 runs nomad and so acts as a command and control Public node.

All jobs are all golang for us and this makes it very easy to distribute work on the Edges all the way down to simple IOT devices

K3OS approach:
Like the nomad approach but running k3OS on bare metal edge nodes, and a cloud k3OS controlling them all.
- upgrade nodes using k8
- can use firecracker for the KVM ?
	- https://github.com/firecracker-microvm/firecracker-containerd



