print:

docker-run: 
	docker build -t blaze:dev . && \
	docker run -d -v $$(pwd):/go/blaze --name blaze_dev -it blaze:dev 

go-init:
	go mod init
go-run:
	CGO_ENABLED=0 go run .


