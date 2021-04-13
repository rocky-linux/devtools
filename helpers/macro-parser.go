package main

import (
	"bufio"
	"io"
	"strings"

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
	Buildopts RPMStruct `yaml:"buildopts"`
	Stream    string    `yaml:"stream"`
	Name      string    `yaml:"name"`
}

type RPMStruct struct {
	Rpm BuildMacros `yaml:"rpms"`
}

type BuildMacros struct {
	Macros string `yaml:"macros"`
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
				log.Printf("unexpected decoding error")
			}
		}
	}

	fmt.Printf("config_opts['module_setup_commands'] = [\n")
	fmt.Printf("    ('enable', '%s:%s'),\n", config.Type.Name, config.Type.Stream)
	fmt.Printf("]\n\n")

	scanner := bufio.NewScanner(strings.NewReader(config.Type.Buildopts.Rpm.Macros))
	for {
		if !scanner.Scan() {
			if scanner.Err() != nil {
				log.Printf("unexpected scanning error")
				return
			}
			break
		}
		line := scanner.Text()
		split := strings.Split(line, " ")
		if len(split) != 2 {
			log.Printf("Unexpected formatting: %q", line)
			continue
		}
		fmt.Printf(`config_opts['macros']['%s'] = %s`, split[0], split[1])
		fmt.Println()
	}
}
