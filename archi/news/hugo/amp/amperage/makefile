# my build make file that uses theirs
# github.com/asurbernardo/amperage

# AMP Valiator: https://search.google.com/test/amp?utm_source=gws&utm_medium=onebox&utm_campaign=suit&url=https://asur.dev/en/

# Web Stories: https://amp.dev/about/stories/

LIB_NAME=		amperage
LIB=			github.com/asurbernardo/$(LIB_NAME)
LIB_FSPATH=		${GOPATH}/src/$(LIB)


print:
	@echo
	@echo -- LIB --
	@echo LIB_FSPATH: 	$(LIB_NAME)
	@echo LIB: 			$(LIB)
	@echo LIB_FSPATH: 	$(LIB_FSPATH)
	@echo


### Example
# All works...
example-create:
	mkdir -p data

	# copy content
	cp -R $(LIB_FSPATH)/exampleSite data

	# copy theme
	mkdir -p data/exampleSite/themes/
	cp -R $(LIB_FSPATH) data/exampleSite/themes/amperage/

example-delete:
	rm -rf data

example-run:
	cd data/exampleSite && hugo serve

example-build:
	# this will gen all the html etc to Content so it can be checked, etc
	cd data/exampleSite && hugo -D



