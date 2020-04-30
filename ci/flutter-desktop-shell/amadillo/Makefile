# https://github.com/dahlia-os/armadillo

# This is the Fuschia UI running on flutter
# But i think this allows oyu to run full fuschia eventually ?

LIB_NAME=armadillo
LIB=github.com/dahlia-os/$(LIB_NAME)
LIB_BRANCH=master
LIB_FSPATH=$(GOPATH)/src/$(LIB)

print:
	@echo $(LIB_NAME)
	@echo $(LIB)
	@echo $(LIB_BRANCH)
	@echo $(LIB_FSPATH)

dep:
	# git clone
	mkdir -p $(LIB_FSPATH)
	cd $(LIB_FSPATH) && cd .. && rm -rf $(NAME) && git clone https://$(LIB).git
	cd $(LIB_FSPATH) && git checkout $(LIB_BRANCH)
dep-clean:
	rm -rf $(LIB_FSPATH)
code:
	code $(LIB_FSPATH)


os-dep:
	go get -u github.com/go-flutter-desktop/hover
	go get -u github.com/go-flutter-desktop/go-flutter

SAMPLE=apps/sysui/armadillo
SAMPLE_FSPATH=$(LIB_FSPATH)/$(SAMPLE)

flu-clean:
	cd $(SAMPLE_FSPATH) && flutter clean
flu-update:
	cd $(SAMPLE_FSPATH) && flutter packages get

flu-mob-run:
	cd $(SAMPLE_FSPATH) && flutter run -d all


flu-desk-init:
	cd $(SAMPLE_FSPATH) && hover init $(LIB)/$(SAMPLE)
flu-desk-init-clean:
	rm -rf $(SAMPLE_FSPATH)/go
flu-desk-run:
	cd $(SAMPLE_FSPATH) && hover run
flu-desk-build:
	cd $(SAMPLE_FSPATH) && hover build
flu-desk-buildrun: flu-desk-build
	open $(SAMPLE_FSPATH)/go/build/outputs/darwin/
	open $(SAMPLE_FSPATH)/go/build/outputs/darwin/$(SAMPLE)
flu-desk-pack:
	# See python scripts from rust golang and adapt to golang


