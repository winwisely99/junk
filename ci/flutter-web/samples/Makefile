# https://github.com/flutter/samples
# - web are in there
# - instructions for environment are there as links.

LIB_NAME=samples
LIB=github.com/flutter/$(LIB_NAME)
LIB_BRANCH=master
LIB_FSPATH=$(GOPATH)/src/$(LIB)

print:
	@echo
	@echo LIB_NAME: $(LIB_NAME)
	@echo LIB: $(LIB)
	@echo LIB_BRANCH: $(LIB_BRANCH)
	@echo LIB_FSPATH: $(LIB_FSPATH)
	@echo

git-clone:
	mkdir -p $(LIB_FSPATH)
	cd $(LIB_FSPATH) && cd .. && rm -rf $(LIB_NAME) && git clone ssh://git@$(LIB).git
	cd $(LIB_FSPATH) && git checkout $(LIB_BRANCH)
git-pull:
	cd $(LIB_FSPATH) && git pull
git-clean:
	rm -rf $(LIB_FSPATH)

code:
	code $(LIB_FSPATH)







go-os-dep:
	# install it
	GO111MODULE=off go get -u github.com/go-flutter-desktop/hover

go-test-run:
	cd $(LIB_FSPATH) && go test -v ./...




flu-os-dep:
	# mac
	sudo gem install cocoapods
	pod setup

	# specific for this from puhb spec
	#github.com/pavan2you/flutter-mvp-framework

flu-print:
	flutter config
	flutter devices
flu-clean:
	cd $(SAMPLE_FSPATH) && flutter clean


# Latest tooling notes
# https://github.com/flutter/flutter/wiki/Building-a-web-application-with-Flutter

flu-config-clean:
	flutter config --clear-features

### web ####

# change as needed
SAMPLE_WEB_NAME=gallery
SAMPLE_WEB_FSPATH=$(LIB_FSPATH)/web/$(SAMPLE_WEB_NAME)

flu-web-config: flu-config-clean
	flutter config --enable-web
	# turn off any desktop
	flutter config --no-enable-linux-desktop
	flutter config --no-enable-macos-desktop
	flutter config --no-enable-windows-desktop
flu-web-create: flu-web-config
	# works 
	# make sure using new dir.
	mkdir -p $(SAMPLE_WEB_FSPATH)
	cd $(SAMPLE_WEB_FSPATH) && flutter create --web .
flu-web-run: flu-web-config
	# works
	# Reload works too :)
	cd $(SAMPLE_WEB_FSPATH) && flutter run -d chrome
flu-web-build: flu-web-config
	# works :)
	cd $(SAMPLE_WEB_FSPATH) && flutter build web --release
flu-web-test: flu-web-config
	# works :)
	cd $(SAMPLE_WEB_FSPATH) && flutter test --platform=chrome

# in order of their site.
SAMPLE=animations
#SAMPLE=chrome-os-best-practices
#SAMPLE=experimental
#SAMPLE=flutter_maps_firestore
#SAMPLE=isolate_example

SAMPLE_FSPATH=$(LIB_FSPATH)/$(SAMPLE)

### mob ###
flu-mob-run:
	cd $(SAMPLE_FSPATH) && flutter run -d "iPhone SE"

### desk ###

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
	# not done yet.









