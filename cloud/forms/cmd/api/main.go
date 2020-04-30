package main

import (
	"log"
	"net/http"
	"os"
	"text/template"


	"github.com/winwisely99/network/cloud/forms/type"

	"github.com/go-playground/form"

	
)

var decoder *form.Decoder

// getEnvOr is needed to be able to run in the cloud.
func getEnvOr(key string, orValue string) string {
	val := os.Getenv(key)
	if val == "" {
		return orValue
	}
	return val
}

func signup(w http.ResponseWriter, r *http.Request) {
	var user UserDTO
	if r.Method == "POST" {
		r.ParseForm()

		decoder = form.NewDecoder()
		v := r.PostForm

		log.Printf("v %v:", v)
		err := decoder.Decode(&user, v)
		if err != nil {
			log.Panic(err)
		}

		log.Printf("user.UserName %s:", user.UserName)
	}

	// now that you have collected the values from the HTTP Form post
	// send the values to the form.
	// you need to move the user UserDTO to "types" folder because everyones needs them.

}

func login(w http.ResponseWriter, r *http.Request) {
	t, _ := template.ParseFiles("login.html")
	t.Execute(w, nil)
}
func main() {

	http.HandleFunc("/", login) // setting router rule
	http.HandleFunc("/signup", signup)
	err := http.ListenAndServe(":8080", nil) // setting listening port
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}
