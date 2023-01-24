package main

import (
	"fmt"
)

func Func1(result string) bool {
	
	if result == "fail" {
		return false
	}

	return true
}

func main() {
	fmt.Println("sample-ci-cd!")
}