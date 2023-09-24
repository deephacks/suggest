import os, sequtils, terminal
from strutils import splitWhitespace, join

type C = int16      ##Type for edit cost values & totals
const mxC = C.high

# @author c-blake
proc distDamerau*[T](a, b: openArray[T], maxDist=mxC,
                     idC=C(1), subC=C(1), xpoC=C(1), dI: var seq[C]): C =
  ## True Damerau(1964) distance with unrestricted transpositions.
  var n = a.len                         #ensure 2nd arg shorter (m < n)
  var m = b.len     #XXX Ukkonen/Berghel or even faster Myers/Hyyro?
  if abs(n - m) * int(idC) >= int(maxDist):
    return maxDist
  let subCeff = min(C(2) * idC, subC)   #effective cost; Can sub w/del+ins
  template d(i, j: C): auto = dI[(C(m) + C(2))*(i) + (j)]
  template dA(i: C): auto = dI[(C(m) + C(2))*(C(n) + C(2)) + (i)]
  let big = C(n + m) * idC
  dI.setLen((n + 2) * (m + 2) + 256)
  zeroMem(addr dA(0), 256 * sizeof(C))
  d(C(0), C(0)) = big
  for i in C(0) .. C(n):
    d(i+C(1), C(1)) = C(i) * idC
    d(i+C(1), C(0)) = big
  for j in C(0) .. C(m):
    d(C(1), j+1) = C(j) * idC
    d(C(0), j+1) = big
  for i in C(1) .. C(n):
    var dB = C(0)
    for j in C(1) .. C(m):
      let i1 = dA(C(b[j - 1]))
      let j1 = dB
      let cost = if a[i-1] == b[j-1]: C(0) else: C(1)
      if cost == 0:
        dB = j
      d(i+C(1), j+C(1)) = min(d(i1, j1) + (i-i1-C(1) + C(1) + j-j1-C(1)) * xpoC,
                            min(d(i, j) + cost * subCeff,
                                min(d(i+1, j) + idC,
                                    d(i  , j+1) + idC)))
    dA(C(a[i-1])) = i
  return min(maxDist, d(C(n)+C(1), C(m)+C(1)))


proc suggestions*[T](wrong: string; match, right: openArray[T],
                     enoughResults=3, unrelatedDistance=C(4)): seq[string] =
  ## Return entries from `right` if the parallel entry in `match` is "close"
  ## to `wrong` in order of (in Damerau distance units).  Considering further
  ## distances is halted once result has `enoughResults` (but all suggestions
  ## for a given distance are included).  Matches >= `unrelatedDistance` are
  ## not considered.
  var dI, dist: seq[C]        #dI for Damerau & seq parallel to `match`,`right`
  if match.len != right.len:
    raise newException(ValueError, "match.len must equal right.len")
  for m in match:                         #Distance calc slow => save answers
    dist.add(distDamerau(wrong, m, maxDist=C(unrelatedDistance), dI=dI))
  for d in C(0) ..< C(unrelatedDistance):  #Expanding distances from zero
    for i in 0 ..< match.len:
      if right[i] notin result and dist[i] <= d:
        result.add(right[i])
    if result.len >= enoughResults:
      break

proc readWords(): seq[string] =
  if not stdin.isatty():
    for line in stdin.lines():
      for word in line.splitWhitespace():
        result &= word

proc suggestions0(distance = 4, num = 10, args: seq[string]) = 
  var words = readWords()
  for word in args:
    let sugg = suggestions(word, words, words, enoughResults = num, unrelatedDistance = C(distance))
    if sugg.len > 0: 
      echo sugg.join(" ")

when isMainModule:
  import cligen
  try: 
    dispatch(suggestions0,
      doc = " word suggestions from stdin",
      short = {
        "distance":  'd',
        "num":       'n'
      }, 
      help = {
        "distance":  "max number of transpositions to match",
        "num":       "max number of matches"
      },
    cmdName = "suggest", 
    noHdr=true)
  except CatchableError as e:
    stderr.writeLine(e.msg)
    quit(e.getStackTrace(), 1)
