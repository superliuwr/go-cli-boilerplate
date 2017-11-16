package config

import (
	"github.com/joho/godotenv"
	"github.com/vrischmann/envconfig"
)

type AppConfig struct {
	DevMode bool `envconfig:"default=false"`
}

// NewConfig returns a default config loaded from the environment
func NewConfig(prefix string, fileNames ...string) (*AppConfig, error) {
	godotenv.Load(fileNames...)

	cfg := AppConfig{}
	err := envconfig.InitWithPrefix(&cfg, prefix)
	if err != nil {
		return nil, err
	}

	return &cfg, nil
}
