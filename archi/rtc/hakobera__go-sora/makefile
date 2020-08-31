# https://github.com/hakobera/go-sora

#uses this serevr: https://sora-labo.shiguredo.jp/

LIB_FSPATH=$(PWD)/go-sora

print:
	@echo
	@echo LIB_FSPATH: $(LIB_FSPATH)
	@echo
dep:
	git clone https://github.com/hakobera/go-sora
dep-os:
	brew install sdl2 libvpx

ex-multi-run:
	cd $(LIB_FSPATH)/examples/multistream && go run .

ex-sdl-run:
	# https://raw.githubusercontent.com/hakobera/go-sora/master/examples/sdl2/README.md
	cd $(LIB_FSPATH)/examples/sdl2 && go run .
