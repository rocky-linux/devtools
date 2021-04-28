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
    var mods []string

    for _, arg := range os.Args[1:] {
        file, err := os.Open(arg)
        if err != nil {
            fmt.Fprintf(os.Stderr, "Could not open file: %s\n", err)
            os.Exit(1)
        }
        d := yaml.NewDecoder(file)
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
        mods = append(mods, fmt.Sprintf("%s:%s", config.Type.Name, config.Type.Stream))
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

    if len(mods) > 0 {
        fmt.Printf("\nconfig_opts['module_setup_commands'] = [\n")
        fmt.Printf("    ('enable', '%s'),\n", strings.Join(mods, ", "))
        fmt.Printf("]\n\n")
    }

}
