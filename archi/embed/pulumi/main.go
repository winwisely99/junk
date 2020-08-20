package main

import (
	"github.com/pulumi/pulumi/sdk/v2/go/pulumi"
	hcloud "github.com/pulumi/pulumi-hcloud/sdk/go/hcloud"
  )
  
  network, _ := hcloud.NewNetwork(ctx, "demo-network", &hcloud.NetworkArgs{
	IpRange: pulumi.String("10.0.1.0/24"),
  })