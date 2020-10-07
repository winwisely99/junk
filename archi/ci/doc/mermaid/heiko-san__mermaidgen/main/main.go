package main

import (
	"fmt"
	"time"

	"github.com/Heiko-san/mermaidgen/gantt"
)

func main() {
	g, _ := gantt.NewGantt()
	timestamp := time.Date(2019, 6, 20, 9, 15, 30, 0, time.UTC)
	g.AddTask("t1", "a task", "1h", timestamp)
	g.AddTask("t2", "another task", "2h")
	// you can also use g.ViewInBrowser() to open the URL in browser directly
	fmt.Println(g.LiveURL())
	//Output: https://mermaidjs.github.io/mermaid-live-editor/#/view/eyJjb2RlIjoiZ2FudHRcbmRhdGVGb3JtYXQgWVlZWS1NTS1ERFRISDptbTpzc1pcbmEgdGFzayA6IHQxLCAyMDE5LTA2LTIwVDA5OjE1OjMwWiwgMzYwMHNcbmFub3RoZXIgdGFzayA6IDcyMDBzXG4iLCJtZXJtYWlkIjp7InRoZW1lIjoiZGVmYXVsdCJ9fQ==
}