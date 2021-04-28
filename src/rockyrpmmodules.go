package main

import (
	"io"
	"fmt"
	"gopkg.in/yaml.v2"
	"log"
	"os"
)


type Yaml struct {
	Type     DataStruct `yaml:"data"`
	Version  string     `yaml:"version"`
	Document string     `yaml:"document"`
}

type DataStruct struct {
	Components ComponentsStruct `yaml:"components"`
        Filters FiltersStruct `yaml:"filter"`
	Stream    string    `yaml:"stream"`
	Name      string    `yaml:"name"`
}

type FiltersStruct struct {
	Rpms []string `yaml:"rpms"`
}

type ComponentsStruct struct {
	Rpms map[string]RpmStruct `yaml:"rpms"`
}

type RpmStruct struct {
    Ref string `yaml:"ref"`
}

func main() {
	var config Yaml
	d := yaml.NewDecoder(os.Stdin)
	for {
		err := d.Decode(&config)
		if err != nil {
			if err == io.EOF {
				break
			} else {
				log.Printf("unexpected decoding error: %s\n", err)
			}
		}
	}


    for _, rpm := range config.Type.Filters.Rpms {
        fmt.Printf("%s %s %s\n", rpm, config.Type.Name, config.Type.Stream)
    }

    for rpm, _ := range config.Type.Components.Rpms {
        fmt.Printf("%s %s %s\n", rpm, config.Type.Name, config.Type.Stream)
    }
}
