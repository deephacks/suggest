

# do word suggestion with distance=2
suggest word='bat':
  @ ./suggest --distance 2 < words.txt {{word}}

# show help
help: 
  @ ./suggest --help

build:
  nim c suggest.nim
