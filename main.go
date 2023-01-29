package main

import (
	"encoding/json"
	"fmt"
	"html/template"
	"math/rand"
	"net/http"
	"os"
	"time"

	"github.com/dsquaredsolutions/sample-ci-cd/buildinfo"
)

var (
	Temperatures = []string{"53","67","94","88","44","32","100","58"}
	bInfo = buildinfo.Info
	frntEnd = Frontend{
		RequestsCount: 0,
		Hostname: must(os.Hostname()),
		BuildInfo: bInfo,
	}
)

type Frontend struct {
	RequestsCount int
	Hostname string
	BuildInfo buildinfo.Inf
}

type Temp struct {
	Val string
}

func Func1(result string) bool {
	
	if result == "fail" {
		return false
	}

	return true
}

func must(h string, err error) string {
    if err != nil {
        fmt.Printf("error from must function - %s\n", err.Error())
    }
    return h
}

func wait(sleepTime time.Duration, c chan bool) {
	time.Sleep(sleepTime)
	c <- true
}

func work(w http.ResponseWriter, r *http.Request) {
	
	query := r.URL.Query()
	wake := make(chan bool, 1)

	// check if we need to simulate delay
	delayParam := query.Get("delay")
	if delayParam != "" {
		// convert delay to time.Duration
		delay, err := time.ParseDuration(delayParam)
		if err == nil {
			go wait(delay, wake)
			for range wake {
				break
			}
		}
	}

	randSrc := rand.NewSource(time.Now().UnixNano())
	rand := Temperatures[randSrc.Int63()%int64(len(Temperatures))]

	t := Temp{
		Val: rand,
	}

	tmplIndex := template.Must(template.New("index").Parse(indexTmpl))
	err := tmplIndex.Execute(w, t)
	if err != nil {
		fmt.Printf("error in index template - %s\n", err.Error())
		w.WriteHeader(http.StatusInternalServerError)
		fmt.Fprintf(w, "an error for index.html has occured")
	}
	frntEnd.RequestsCount = frntEnd.RequestsCount + 1
}

func admin(w http.ResponseWriter, r *http.Request) {

	tmplAdmin := template.Must(template.New("admin").Parse(adminTmpl))
	err := tmplAdmin.Execute(w, frntEnd)
	if err != nil {
		fmt.Printf("error in admin template - %s\n", err.Error())
		w.WriteHeader(http.StatusInternalServerError)
		fmt.Fprintf(w, "an error for admin.html has occured")
		return
	}
}

func root(w http.ResponseWriter, r *http.Request) {
	randSrc := rand.NewSource(time.Now().UnixNano())
	rand := Temperatures[randSrc.Int63()%int64(len(Temperatures))]

	t := Temp{
		Val: rand,
	}

	tmplIndex := template.Must(template.New("index").Parse(indexTmpl))
	err := tmplIndex.Execute(w, t)
	if err != nil {
		fmt.Printf("error in index template - %s\n", err.Error())
		w.WriteHeader(http.StatusInternalServerError)
		fmt.Fprintf(w, "an error for index.html has occured")
	}
	frntEnd.RequestsCount = frntEnd.RequestsCount + 1
}

func main() {
	fmt.Println("sample-ci-cd!")

	mux := http.NewServeMux()

	mux.HandleFunc("/info", func(w http.ResponseWriter, r *http.Request) {
		json.NewEncoder(w).Encode(buildinfo.Info)
	})

	mux.HandleFunc("/work", work)
	mux.HandleFunc("/admin", admin)
	mux.HandleFunc("/healthz", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		fmt.Fprintf(w, "")
	})
	mux.HandleFunc("/", root)

	server := &http.Server{
		Addr: ":4444",
		Handler: mux,
	}

	if err := server.ListenAndServe(); err != nil {
		fmt.Printf("http server failed - %s", err.Error())
	}
}