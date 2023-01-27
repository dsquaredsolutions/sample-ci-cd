package main

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/dsquaredsolutions/sample-ci-cd/buildinfo"
)

func Func1(result string) bool {
	
	if result == "fail" {
		return false
	}

	return true
}

func main() {
	fmt.Println("sample-ci-cd!")

	mux := http.NewServeMux()

	mux.HandleFunc("/info", func(w http.ResponseWriter, r *http.Request) {
		json.NewEncoder(w).Encode(buildinfo.Info)
	})

	server := &http.Server{
		Addr: ":4444",
		Handler: mux,
	}

	if err := server.ListenAndServe(); err != nil {
		fmt.Printf("http server failed - %s", err.Error())
	}
}