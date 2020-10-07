# https://github.com/miguelpruivo/flutter_file_picker

LIB=github.com/miguelpruivo/flutter_file_picker
LIB_FSPATH=$(GOPATH)/src/$(LIB)

# Works on Web and desktop and mobile !


dep:
	git clone https://$(LIB) $(LIB_FSPATH)
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
	cd $(SAMPLE_NATIVE) && flutter pub outdated
	@echo 
flu-pub-upgrade:
	cd $(LIB_FSPATH) && flutter pub upgrade

### Web
SAMPLE_WEB_FSPATH=$(LIB_FSPATH)/file_picker_web/example
flu-web-run:
	cd $(SAMPLE_WEB_FSPATH)/ && flutter run -d chrome

### Mob
SAMPLE_NATIVE=$(LIB_FSPATH)/file_picker/example
flu-mob-ios-init:
	# https://flutter.dev/docs/get-started/install/macos#deploy-to-ios-devices
	sudo gem install cocoapods
	pod setup
	cd $(SAMPLE_NATIVE) && open ios/Runner.xcworkspace

flu-mob-run:
	# ios
	open -a Simulator
	cd $(SAMPLE_NATIVE) && flutter run -d all
flu-mob-build:
	cd $(SAMPLE_NATIVE) && flutter build ios --release
	# And in Xcode --> Product --> Archive .

### Desk
flu-desk-init:
	#cd $(SAMPLE_NATIVE) && hover init
	cd $(SAMPLE_NATIVE) && hover plugins get
	
flu-desk-run:
	cd $(SAMPLE_NATIVE) && hover run
