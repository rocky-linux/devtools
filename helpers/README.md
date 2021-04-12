## macro-parser.go

To use the macro parser, simply pipe the raw macro YAML file into the tool. Here is a working example:

```
curl https://git.centos.org/modules/javapackages-tools/raw/c8-stream-201801/f/javapackages-tools.yaml | go run macro-parser.go
```
