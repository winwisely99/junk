

# https://github.com/mmcc007/screenshots


LIB_NAME=screenshots
LIB=github.com/mmcc007/$(LIB_NAME)
LIB_BRANCH=master
LIB_FSPATH=$(GOPATH)/src/$(LIB)

export ENABLE_FLUTTER_DESKTOP=true

print:
	@echo
	@echo LIB_NAME: $(LIB_NAME)
	@echo LIB: $(LIB)
	@echo LIB_BRANCH: $(LIB_BRANCH)
	@echo LIB_FSPATH: $(LIB_FSPATH)
	@echo

git-clone:
	# need flutter desktop :)
	mkdir -p $(LIB_FSPATH)
	cd $(LIB_FSPATH) && cd .. && rm -rf $(LIB_NAME) && git clone ssh://git@$(LIB).git
	cd $(LIB_FSPATH) && git checkout $(LIB_BRANCH)
git-pull:
	cd $(LIB_FSPATH) && git pull
git-clean:
	rm -rf $(LIB_FSPATH)

code:
	code $(LIB_FSPATH) 




### Common Shared


flu-config-clean:
	# disable all desktop
	flutter config --no-enable-linux-desktop
	flutter config --no-enable-macos-desktop
	flutter config --no-enable-windows-desktop
	flutter config --no-enable-web

	flutter config --clear-features

flu-config-mobile: flu-config-clean

	# cache
	flutter precache --android
	flutter precache --ios

flu-config-web: flu-config-clean
	flutter config --enable-web

	# cache
	flutter precache --web

flu-config-desktop: flu-config-clean
	# Configure the dekstop env
	# See: https://github.com/flutter/flutter/wiki/Desktop-shells#target-platform-override

	#flutter config --enable-linux-desktop
	flutter config --enable-macos-desktop
	#flutter config --enable-windows-desktop

	# cache
	flutter precache --macos

flu-config-print:
	flutter config
	#flutter doctor -v
	flutter devices

###

MOB_SAMPLE=
MOB_SAMPLE_FSPATH=$(LIB_FSPATH)/example/$(MOB_SAMPLE)

### Screenshots

flu-screenshot-os-dep:
	# Need master to have Google Desktop and Web available.
	#flutter channel master
	#flutter upgrade

	# OS stuff needed
	# https://github.com/mmcc007/screenshots#installation
	brew update && brew install imagemagick
	pub global activate screenshots

flu-screenshot-os-dep-clean:
	pub global deactivate screenshots

flu-screenshot-run:
	# WORKS :)

	# Make sure config yaml references IOS or android emulators you have.
	cd $(MOB_SAMPLE_FSPATH) && screenshots

	# screenshots outputted here:
	ls -al $(MOB_SAMPLE_FSPATH)/ios/fastlane/screenshots
	#ls -al $(MOB_SAMPLE_FSPATH)/android/fastlane/metadata/android
	

### Mob


flu-mob-create:
	cd $(LIB_FSPATH) && flutter create example_mob



flu-mob-run:
	
	$(MAKE) flu-config-mobile

	# example in repo.
	#cd $(LIB_FSPATH)/example && flutter clean
	cd $(MOB_SAMPLE_FSPATH) && flutter packages get
	#cd $(MOB_SAMPLE_FSPATH) && flutter run -d "iPhone SE"
	cd $(MOB_SAMPLE_FSPATH) && flutter run -d all
