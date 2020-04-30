package type

import (
	
	// "github.com/go-playground/form"
	"github.com/go-playground/form"
)

// UserDTO get user details for signup
type UserDTO struct {
	UserName  string `form:"userName,omitempty"`
	FirstName string `form:"firstName,omitempty"`
	LastName  string `form:"lastName,omitempty"`
}
