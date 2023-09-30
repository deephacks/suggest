version     = "0.0.1"
author      = "Kristoffer Sjögren"
description = "Provide fast word suggestions from stdin using fuzzy search based damerau-levenshtein."
license     = "MIT"

bin = @[ "suggest" ]
binDir = ".bin"
requires "nim >= 2.0.0", "cligen"
