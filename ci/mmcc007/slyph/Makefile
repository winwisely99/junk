

# https://github.com/mmcc007/sylph


LIB_NAME=sylph
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



SAMPLE=
SAMPLE_FSPATH=$(LIB_FSPATH)/example/$(SAMPLE)

flu-syl-os-dep:
	pub global activate sylph
	pub global list

	# aws cli
	curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
	unzip awscli-bundle.zip
	sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

flu-syl-print:

	@echo
	@echo AWS_DEFAULT_PROFILE: $(AWS_DEFAULT_PROFILE)
	@echo AWS_ACCESSKEYID: $(AWS_ACCESS_KEY_ID)
	@echo AWS_SECRETACCESSKEY: $(AWS_SECRET_ACCESS_KEY)
	@echo AWS_DEFAULT_REGION: $(AWS_DEFAULT_REGION)
	@echo

flu-sly-config:
	# aws configure
	aws devicefarm list-projects

	# print android devices
	sylph -d android
	# print ios devices
	sylph -d ios

flu-syl-open:
	open https://us-west-2.console.aws.amazon.com/devicefarm/home?#/projects
	
flu-syl-run-and:
	cd $(SAMPLE_FSPATH) && sylph -c sylph_android.yaml -v

flu-syl-run-ios:
	cd $(SAMPLE_FSPATH) && sylph -c sylph_ios.yaml -v

	

