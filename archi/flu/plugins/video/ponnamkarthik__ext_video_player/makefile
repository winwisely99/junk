# https://github.com/ponnamkarthik/ext_video_player

LIB=github.com/ponnamkarthik/ext_video_player
LIB_FSPATH=$(GOPATH)/src/$(LIB)

FLU_SSAMPLE_FSPATH=$(LIB_FSPATH)/example

print:
	@echo $(LIB_FSPATH)

dep:
	git clone https://$(LIB) $(LIB_FSPATH)

dep-clean:
	rm -rf $(LIB_FSPATH)

flu-web-run: ## flu-web-run
	flutter config --enable-web
	cd $(FLU_SSAMPLE_FSPATH) && flutter run -d chrome

## Builds flutter web as a release version
flu-web-build: ## flu-web-build
	flutter config --enable-web
	cd $(FLU_SSAMPLE_FSPATH) && flutter build web

flu-mob-run: ## flu-mob-run
	cd $(FLU_SSAMPLE_FSPATH) && flutter run -d all

## Fixes a common bug with IOS
flu-mob-fix:
	# webrtc fix
	# MIGHT have to apply this to CI also. Lets see.
	cd $(FLU_SSAMPLE_FSPATH) && rm ios/Podfile.lock
	cd $(FLU_SSAMPLE_FSPATH) && rm -rf ios/Pods
	cd $(FLU_SSAMPLE_FSPATH) && flutter clean

flu-mob-build: ## flu-mob-build
	# ios
	# https://flutter.dev/docs/deployment/ios
	# change to ios 11 in xcode for runner and pods
	cd $(FLU_SSAMPLE_FSPATH)/ios && pod install
	#cd $(FLU_SSAMPLE_FSPATH) && flutter build ios

	cd $(FLU_SSAMPLE_FSPATH) && 	flutter build ios --release --no-codesign

## Inits Flutter Desktop
flu-desk-init: ## flu-desk-init
	cd $(FLU_SSAMPLE_FSPATH) && hover init
	

## Runs Flutter Desktop
flu-desk-run: ## flu-desk-run
	cd $(FLU_SSAMPLE_FSPATH) && hover run