# clean

# removes all the go and dart shit that accumulates
# but not my repos

seed:
	mkdir -p test
	cd test && mkdir -p sub01
	cd test/sub01 && touch 1.gif
	cd test && mkdir -p sub02
	cd test/sub02 && touch 2.gif

	ls -R
seed-del:	
	rm -rf test

	ls -R

seed-rm:
	#find ./test -mindepth 1 -name sub02 -prune

	cd ./test && find . -type d ! -name "sub02" -delete
	

clean-gobin:
	cd $(GOPATH)/bin && stat
clean-gocache:
	go clean -cache
	go clean -cache -modcache -i -r
clean-gosrc:
	cd $(GOPATH)/src && stat
	
