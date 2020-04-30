package main

import (
	"flag"
	"fmt"
	"os"
	// "github.com/winwisely99/network/cloud/forms/type"
)

var welcomeSignature = `
Usage of Form made By Rohit
_______________________________
	< Form >
-------------------------------

-name string:
	Set the name

`

func main() {
	var (
		name = flag.String("name", "", "Set the name")
	)
	flag.Parse()

	if *name == "" {
		flag.Usage = func() {
			fmt.Println(welcomeSignature)
		}
		flag.Usage()
		os.Exit(0)
	}

	// send the data to the Form package so it can save it.

}
