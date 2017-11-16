package main

import (
	"github.com/superliuwr/go-cli-boilerplate/lib/config"
	"github.com/superliuwr/go-cli-boilerplate/lib/wiring"
)

const (
	// Standard path when the working dir is at the repo root
	defEnvPath = ".env"
	// Special case when the working dir is main.go's directory
	relEnvPath = "../../.env"
)

func main() {
	cfg, err := config.NewConfig("GO_CLI_BOILERPLATE", defEnvPath, relEnvPath)
	if err != nil {
		panic(err)
	}

	app := wiring.NewApp(cfg)
	defer app.Close()
	app.Run()
}
