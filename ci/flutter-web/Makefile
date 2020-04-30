
# github.com/flutter/flutter_web

LIB_NAME=flutter_web
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

dep-os:
	# For flutter web you need the webdev tool
	# You dont need the source code, but its below in the other make commands anyway.
	flutter pub global activate webdev

#SAMPLE=hello_world
SAMPLE=gallery
#SAMPLE=html_platform_view
#SAMPLE=spinning_square
#SAMPLE=custom_fonts

flu-dep:
	# needed first time
	cd $(LIB_FSPATH)/examples/$(SAMPLE) && flutter pub upgrade
flu-run:
	cd $(LIB_FSPATH)/examples/$(SAMPLE) && webdev serve --auto restart
flu-build:
	cd $(LIB_FSPATH)/examples/$(SAMPLE) && webdev build

serve-hello:
	# works
	cd $(LIB_FSPATH)/examples/hello_world && flutter pub upgrade
	#cd $(LIB_FSPATH)/examples/hello_world && flutter pub run build_runner serve
	# not works
	cd $(LIB_FSPATH)/examples/hello_world && webdev serve --auto restart
build-hello:
	cd $(LIB_FSPATH)/examples/hello_world && webdev build
code-hello:
	code $(LIB_FSPATH)/examples/hello_world
	
serve-gal:
	cd $(LIB_FSPATH)/examples/gallery && flutter pub upgrade
	cd $(LIB_FSPATH)/examples/gallery && flutter pub run build_runner serve
# html_platform_view
serve-html:
	cd $(LIB_FSPATH)/examples/html_platform_view && flutter pub upgrade

	#cd $(LIB_FSPATH)/examples/html_platform_view && flutter pub run build_runner serve
	# OR
	cd $(LIB_FSPATH)/examples/html_platform_view && webdev serve --auto refresh

run-html:
	# does not wokr
	cd $(LIB_FSPATH)/examples/html_platform_view && flutter run -d chrome
	
# spinning_square
serve-spin:
	cd $(LIB_FSPATH)/examples/spinning_square && flutter pub upgrade
	cd $(LIB_FSPATH)/examples/spinning_square && flutter pub run build_runner serve
# custom_fonts
serve-font:
	cd $(LIB_FSPATH)/examples/custom_fonts && flutter pub upgrade
	cd $(LIB_FSPATH)/examples/custom_fonts && flutter pub run build_runner serve







