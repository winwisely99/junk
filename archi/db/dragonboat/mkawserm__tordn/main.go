package main

import (
	"fmt"

	"github.com/mkawserm/tordn"
)

func main() {

	v3domainName := &tordn.V3{}

	// generate random v3 tor domain name
	publicKey, privateKey, onionAddress, err := v3domainName.GenerateTORDomainName(nil)
	if err == nil {
		fmt.Printf("Public Key:")
		fmt.Println(publicKey)

		fmt.Printf("Private Key:")
		fmt.Println(privateKey)

		fmt.Printf("Onion Address:")
		fmt.Println(string(onionAddress))
	}
}
