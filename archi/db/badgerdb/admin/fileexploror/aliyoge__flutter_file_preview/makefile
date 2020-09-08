# https://github.com/aliyoge/flutter_file_preview

LIB=github.com/aliyoge/flutter_file_preview
LIB_FSPATH=$(GOPATH)/src/$(LIB)

SAMPLE_FSPATH=$(LIB_FSPATH)/example

# Works on IOS
# NOT work on Web
# NOT what i need !

dep:
	git clone https://$(LIB) $(LIB_FSPATH)
dep-del:
	rm -rf $(LIB_FSPATH)

vscode-add:
	code --add $(LIB_FSPATH) --reuse-window

flu-pub-upgrade-check:
	cd $(LIB_FSPATH) && flutter pub outdated
flu-pub-upgrade:
	cd $(LIB_FSPATH) && flutter pub upgrade


flu-web-run:
	cd $(SAMPLE_FSPATH) && flutter run -d chrome

flu-mob-ios-init:
	# https://flutter.dev/docs/get-started/install/macos#deploy-to-ios-devices
	sudo gem install cocoapods
	pod setup
	cd $(SAMPLE_FSPATH) && open ios/Runner.xcworkspace

flu-mob-run:
	# ios
	open -a Simulator
	cd $(SAMPLE_FSPATH) && flutter run -d all