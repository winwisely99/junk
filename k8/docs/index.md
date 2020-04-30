# k8 docs


## Intent

A k8 system that can run on ARM64 and AMD64 with both cloud and edge devices.

ARM64 still has issues that are being solved quickly now.

AMD64
- Cloud: Google Container Engine
- Hardware:intel NUC

ARM64
- Cloud: Scaleway and Packet
- Hardware: RockchipPro hardware with PCI based SSD

Topology
- Each Site can run a cluster or ARM64 for its own HA
- Each Cloud runs a Management plane with a tunnel to the Edge devices.

Gitops
- Wraps for Weave FLux.

## Envoy

Envoy sidecars are a best practice way to enforce global aspects around the code without polluting the code with those orthogonal aspects.

- Protocol transformation ( e.g GRPC-web)
- Security ( e.g OPA)
- Telemetry

GRPC is an agnostic standard for bidirectional RPC, and enforces the code for the Server and Client to be best practice and so lower security risks whilst increasing Design Time and runtime performance.

- GRPC and GRPC-web so that MicroServices are high quality and highly reusable.
- apply OPA policies at this level
	- currently Envoy for ARM64 is almost ready: https://github.com/envoyproxy/envoy/issues/1861
		- RPI Bazel: https://github.com/mjbots/rpi_bazel
		

## Docker, Helm and Operators

At the k8 level Images must be:

- multi-arch (ARM64, AMD64)
- support HA
- support CSI with rook and ceph
- use Metal LB to be independent of the cloud hosting LB

https://github.com/docker/buildx
- Docker CLI extension that allow cross image builds.
- Github Action: https://github.com/crazy-max/ghaction-docker-buildx

https://github.com/raspbernetes/multi-arch-images
- Has many of the images we need in ARM64
- we extend these to have HA versions
- fork and commit back.

K8 Operators
https://operatorhub.io/operator/keycloak-operator

