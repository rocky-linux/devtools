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
	Stream    string    `yaml:"stream"`
	Name      string    `yaml:"name"`
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


    for rpm, _ := range config.Type.Components.Rpms {
        fmt.Printf("%s %s %s\n", rpm, config.Type.Name, config.Type.Stream)
    }
}
