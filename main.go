// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

package main

import (
	"embed"
	"log"
	"net/http"
	"os"
	"text/template"
)

//go:embed templates/*
var resources embed.FS

var t = template.Must(template.ParseFS(resources, "templates/*"))

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		data := map[string]string{
			"Hostname": r.Host,
		}
		t.ExecuteTemplate(w, "index.html.tmpl", data)
	})

	log.Println("Listening on", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}