# https://github.com/dahlia-os/pangolin-desktop

# The main dev
# nmcain@gmail.com

# wow it works on Mobiles

LIB_NAME=pangolin-desktop
LIB=github.com/dahlia-os/$(LIB_NAME)
LIB_BRANCH=master
LIB_FSPATH=$(GOPATH)/src/$(LIB)

print:
	@echo $(LIB_NAME)
	@echo $(LIB)
	@echo $(LIB_BRANCH)
	@echo $(LIB_FSPATH)

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


SAMPLE=
SAMPLE_FSPATH=$(LIB_FSPATH)/$(SAMPLE)

flu-clean:
	cd $(SAMPLE_FSPATH) && flutter clean
flu-update:
	cd $(SAMPLE_FSPATH) && flutter packages get

flu-mob-run:
	cd $(SAMPLE_FSPATH) && flutter run -d all


flu-desk-init:
	cd $(SAMPLE_FSPATH) && hover init
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


flu-web-config:
	flutter config --enable-web
	# turn off any desktop
	flutter config --no-enable-linux-desktop
	flutter config --no-enable-macos-desktop
	flutter config --no-enable-windows-desktop
flu-web-create: flu-web-config
	# works 
	# make sure using new dir.
	mkdir -p $(SAMPLE_FSPATH)
	cd $(SAMPLE_FSPATH) && flutter create --web .
flu-web-run: flu-web-config
	# works
	# Reload works too :)
	cd $(SAMPLE_FSPATH) && flutter run -d chrome
flu-web-build: flu-web-config
	# works :)
	cd $(SAMPLE_FSPATH) && flutter build web --release
flu-web-test: flu-web-config
	# works :)
	cd $(SAMPLE_FSPATH) && flutter test --platform=chrome
