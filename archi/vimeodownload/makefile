# https://github.com/iawia002/annie

LIB=github.com/iawia002/annie
LIB_FSPATH=$(GOPATH)/src/$(LIB)
LIB_BIN_FSPATH=$(GOPATH)/bin/annie

dep:
	git clone https://$(LIB) $(LIB_FSPATH)

build:
	cd $(LIB_FSPATH) && go build -o $(LIB_BIN_FSPATH) .

### EX


ex:
	# https://shop.auditorium-netzwerk.de/custom/index/sCustom/501
	$(LIB_BIN_FSPATH) -i https://player.vimeo.com/video/454621490