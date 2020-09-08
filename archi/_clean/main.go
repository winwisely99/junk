package main

import (
	"fmt"
	"go/build"
	"os"
)

func main() {

	// The target directory.
	gopath := os.Getenv("GOPATH")
	if gopath == "" {
		gopath = build.Default.GOPATH
	}
	fmt.Println(gopath)

	directory := gopath

	delFiles(directory + "/src/")

}

func delFiles(directory string) {
	// Open the directory and read all its files.
	dirRead, _ := os.Open(directory)
	dirFiles, _ := dirRead.Readdir(0)

	// Loop over the directory's files.
	for index := range dirFiles {
		fileHere := dirFiles[index]

		// Get name of file and its full path.
		nameHere := fileHere.Name()
		fullPath := directory + nameHere

		// Remove the file.
		// os.RemoveAll(fullPath)
		fmt.Println("Removed file:", fullPath)
	}
}
