#!/bin/zsh
docker rm -f postgres00 || true
docker rm -f nats-streaming00 || true
rm -f nats-bench
go get -v github.com/nats-io/stan.go
go build -o stan-bench $GOPATH/src/github.com/nats-io/stan.go/examples/stan-bench/main.go
ID=$(docker run --volume `pwd`:/scripts --name postgres00 -d -e POSTGRES_PASSWORD=password -p 5432:5432 postgres)
sleep 3
cat drop_postgres.db.sql | docker exec -i $ID psql -h 127.0.0.1 -U postgres
cat postgres.db.sql | docker exec -i $ID psql -h 127.0.0.1 -U postgres
docker run -d --link postgres00:postgres00 --name nats-streaming00 -p 4222:4222 -p 8222:32768 nats-streaming --store sql --sql_driver postgres --sql_source="user=postgres password=password host=postgres00 port=5432 sslmode=disable"
sleep 5
./stan-bench -s "nats://127.0.0.1:4222" -np 100 -n 100000 -ms 1024 foo