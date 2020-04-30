# dev notes

Only way to allow Iran and China and Russia to connect

Client must be embedded in the app. We can do this because its go



https://github.com/WireGuard

## GUI
https://github.com/subspacecloud/subspace
- Server GUI
- pure go 

https://github.com/EmbarkStudios/wireguard-ui
- Client GUI
- go & svelte (npm) 

## k8

We will need to run a large global set of servers and so k8 is perfect and allows us to run anywhere

https://github.com/squat/kilo
video: https://www.youtube.com/watch?v=iPz_DAOOCKA
- Make a full mesh between the servers
- SO a Client can access ANY server no matter where it is.


https://github.com/subspacecloud/subspace
- Web gui with SSO
- dockers
- mayn gateways



official clients
https://github.com/WireGuard
- they use golang under the hood so easy to make a Flutter GUI.
https://github.com/WireGuard/wireguard-android/blob/master/app/tools/libwg-go/Makefile
- how to build golang for android
https://github.com/WireGuard/wireguard-apple/blob/master/wireguard-go-bridge/Makefile
- how to build for ios



basic google vm setup
- can make it gcloud based.
https://github.com/rajannpatel/Pi-Hole-PiVPN-on-Google-Compute-Engine-Free-Tier-with-Full-Tunnel-and-Split-Tunnel-OpenVPN-Configs/blob/master/README.md


https://github.com/billimek/cloudvm/blob/master/main.tf
https://github.com/billimek/wireguard-install
- looks good using terraform and gcloud
https://github.com/unchartedsky/guards
- same as above


https://github.com/balboah/wireguard-operator
- golang operator with k8 config
- has dockers and makefile :)
https://github.com/blokadaorg/blokada
- android using rusts boringtun





https://medium.com/mysterium-network/golang-c-interoperability-caf0ba9f7bf3
https://github.com/mysteriumnetwork/node/tree/master/mobile/mysterium
