package wiring

import (
	"fmt"

	"github.com/superliuwr/go-cli-boilerplate/lib/config"
)

type App interface {
	Run()
	Close()
}

type app struct {
	config *config.AppConfig
}

func (a *app) Run() {
	fmt.Println(fmt.Sprintf("It's running in dev mode: %v!", a.config.DevMode))
}

func (a *app) Close() {
	fmt.Println("It's closed!")
}

func NewApp(cfg *config.AppConfig) App {
	return &app{
		config: cfg,
	}
}
