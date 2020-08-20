# go get github.com/pulumi/pulumi-hcloud/sdk/go/...

### ENV
# see: https://www.pulumi.com/docs/intro/cloud-providers/hcloud/setup/
export HCLOUD_TOKEN=XXXXXXXXXXXXXX


print:
	
	@echo pulumi: $(shell pulumi version)
	@echo HCLOUD_TOKEN: $(HCLOUD_TOKEN)
dep:
	brew install pulumi

	go get github.com/pulumi/pulumi-hcloud/sdk/go/...

env-set:
	# Seems to cost money. Fuck that.
	pulumi config set hcloud:token XXXXXXXXXXXXXX --secret

run:
	go run main.go