# k8

Kubernetes setup, ops and management.

Envoy is the core thing used, and it run be run OnCloud ( K8 ), but also OnPremise ( no k8)

why do it ?
Envoy can do all auth and authz, as well as GRPC and GRPC-web as well as many other things.
It can be configured via an external system also for no hands Ops.
By putting all auth and authz at the envoy level the golang layer remains simple, and you dont reinvent the wheel and you centralise the Auth and Authz for situations where you need to stand up many MicroServices.

Nomad, kubernettes and gloo all use Envoy under the hood.

gloo just happens to give you a golang API though, and so can be used in different scenario's, which is flexible. It also runs on darwin, linux ( both AMD64 and AMR64).
I dont think nomad runs on ARM64 yet.

https://docs.solo.io/gloo/1.1.0/installation/gateway/nomad/

https://docs.solo.io/gloo/1.1.0/installation/gateway/docker-compose-consul/

https://docs.solo.io/gloo/1.1.0/installation/gateway/kubernetes/



This approach allows our dockers to be:
- run onPremsie using KIND and docker compose
- run onCloud using k8.

See Liftbridge as a good example.

Us gofish to install the tools.

## Joining 

You want to deploy pieces to join together in a composition style.

To add a k8 to an existing environment use "app.kubernetes.io/part-of" label
https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/


