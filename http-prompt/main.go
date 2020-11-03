package main

import (
	"context"
	"net/http"
	"log"
	"fmt"
	"io/ioutil"
	"encoding/json"
	"time"
	"os"
	"os/exec"
	"net"
)

type Cfg struct {
	ServerAddr string
	ViewPath string
}

var cfg Cfg
var srv http.Server

func promptView(w http.ResponseWriter, r *http.Request) {
	html, err := ioutil.ReadFile(cfg.ViewPath)
	if err != nil {
		panic(err)
	}
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	fmt.Fprint(w, string(html))
}

func handleAnswer(w http.ResponseWriter, r *http.Request) {
	decoder := json.NewDecoder(r.Body)
	
	var answer struct { Action string }
	err := decoder.Decode(&answer)

	if err != nil {
		panic(err)
	}

	if answer.Action != "yes" && answer.Action != "no" {
		panic("unexpected answer " + answer.Action)
	}

	fmt.Fprint(w, "ok")
	if f, ok := w.(http.Flusher); ok {
		f.Flush()
	}

	fmt.Println(answer.Action)

	go func() {
		time.Sleep(500 * time.Millisecond)
		if err := srv.Shutdown(context.Background()); err != nil {
			log.Printf("%v", err)
		}
	}()
}

func showBrowser() {
	err := exec.Command("xdg-open", "http://" + cfg.ServerAddr).Start()
	if  err != nil {
		log.Fatal(err)
	}
}

func parseArgs() {
	if len(os.Args) != 2 {
		log.Fatal("Usage: http-prompt /path/to/prompt-view.html")
	}

	cfg.ViewPath = os.Args[1]
}

func main() {	
	cfg = Cfg{ServerAddr: "localhost:8383"}
	parseArgs()

	srv = http.Server{Addr: cfg.ServerAddr}
	listener, err := net.Listen("tcp", cfg.ServerAddr)
	if err != nil {
		log.Fatal(err)
	}

	showBrowser()

	http.HandleFunc("/", promptView)
	http.HandleFunc("/answer", handleAnswer)

	if err := srv.Serve(listener); err != http.ErrServerClosed {
		log.Fatal(err)
	}
}
