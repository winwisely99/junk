stage 1 (16 hours):
    (blaze)
    import flamed
    simple grpc
    subscription test make sure data is distributed (from cli)
    cli to talk to grpc

stage 2:
    docker-compose spin up 3 to 5 instances (in makefile)
    kill random nodes (including leader) and make sure expected results
    standard badger admin tools (snapshots etc)

stage 3:
    lb with caddy (letsencrypt, etc) in 1 dc
    run 3 versions (alpha, beta, stable) behind caddy (tagged versions)
    grpc lb (how does flutter handle this?)

stage 4:
    3 dcs
    run 1 flamed in each dc (network resiliency)
