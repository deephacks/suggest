
# suggest

Provide fast word suggestions from stdin using fuzzy search based damerau-levenshtein.

```bash
Provide fast word suggestions from stdin using fuzzy search based damerau-levenshtein.

USAGE: 
  suggest [optional-params] [args: string...]

OPTIONS:
  -h, --help                 print help
  -d=, --distance=  int  4   max number of transpositions to match
  -n=, --num=       int  10  max number of matches
```


## build

1. Install [Nim v2.0](https://nim-lang.org/blog/2023/08/01/nim-v20-released.html) using [choosenim](https://github.com/dom96/choosenim) to `~/.choosenim`
   
   `curl https://nim-lang.org/choosenim/init.sh -sSf | sh`

2. install executable `suggest` to `~/.nimble/bin`
   
   `nimble install`

3. Make sure `$PATH` contains `~/.nimble/bin`


## note

By default, Nim builds dynamically linked binaries using the glibc version present on the OS where those binaries are built.

Building fully static and cross-compiled musl binaries is possible using [nim2-buildroot-toolchain](https://github.com/deephacks/nim2-buildroot-toolchain), which provide a fully automated toolchain using docker and [buildroot](https://buildroot.org/).
