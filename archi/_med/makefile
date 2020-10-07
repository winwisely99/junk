# https://github.com/openemr/app-flutter-openemr

# old demo: https://www.open-emr.org/demo/

LIB=github.com/openemr/app-flutter-openemr
LIB_FSPATH=$(GOPATH)/src/$(LIB)



SAMPLE_WEB_FSPATH=$(LIB_FSPATH)

SAMPLE_NATIVE_FSPATH=$(LIB_FSPATH)

print:

dep:
	git clone https://$(LIB) $(LIB_FSPATH)
	cd $(LIB_FSPATH) && git submodule update --init

dep-del:
	rm -rf $(LIB_FSPATH)

vscode-add:
	code --add $(LIB_FSPATH) --reuse-window

flu-pub-upgrade-check:
	@echo 
	@echo -- WEB --
	cd $(SAMPLE_WEB_FSPATH) && flutter pub outdated
	@echo 

	@echo
	@echo -- NATIVE --
	cd $(SAMPLE_NATIVE_FSPATH) && flutter pub outdated
	@echo 
flu-pub-upgrade:
	cd $(LIB_FSPATH) && flutter pub upgrade

### Web

flu-web-run:
	cd $(SAMPLE_WEB_FSPATH)/ && flutter run -d chrome

### Mob

flu-mob-ios-init:
	# https://flutter.dev/docs/get-started/install/macos#deploy-to-ios-devices
	sudo gem install cocoapods
	pod setup
	cd $(SAMPLE_NATIVE_FSPATH) && open ios/Runner.xcworkspace
flu-mob-ios-clean:
	cd $(SAMPLE_NATIVE_FSPATH) && rm ios/Podfile
flu-mob-run:
	# ios
	open -a Simulator
	cd $(SAMPLE_NATIVE_FSPATH) && flutter run -d all
flu-mob-build:
	cd $(SAMPLE_NATIVE_FSPATH) && flutter build ios --release
	# And in Xcode --> Product --> Archive .

### Desk
flu-desk-init:
	#cd $(SAMPLE_NATIVE_FSPATH) && hover init
	cd $(SAMPLE_NATIVE_FSPATH) && hover plugins get
	
flu-desk-run:
	cd $(SAMPLE_NATIVE_FSPATH) && hover run
