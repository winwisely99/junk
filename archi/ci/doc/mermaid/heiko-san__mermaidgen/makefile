# https://github.com/Heiko-san/mermaidgen

LIB_NAME=mermaidgen

dep:
	git clone https://github.com/Heiko-san/$(LIB_NAME)
	cd $(LIB_NAME) && go mod init

all-test:
	cd $(LIB_NAME) && chmod +x ./unittests.sh && ./unittests.sh
all-test-open:
	cd $(LIB_NAME) && open cover.html



