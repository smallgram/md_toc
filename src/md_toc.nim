import os
import strutils
import strformat

import cligen
import regex 


type
  Header = object
    text: string
    level: int


proc extractHeaders(markdown: string): seq[Header] =
  ## Extract the header heirarchy from a passed in chunk of `markdown`
  let headerPattern = re"^ *(#{1,6}) *(.*?) *#* *$"
  var m: RegexMatch
  #var headers: seq[Header] = @[]
  
  # first a line-by-line method
  for l in markdown.splitLines():
    if l.match(headerPattern, m):
      let lev = m.group(0, l)[0]
      let tex = m.group(1, l)[0] 
      result.add(Header(text: tex, level: lev.len))


proc generateTOC(headers: seq[Header]): string =
  ## Generate a markdown chunk representing the passed in `headers`
  result.add("# Table of Contents\p")
  for head in headers:
    result.add(&"{\"\t\".repeat(head.level - 1)}* [{head.text}]" & 
               &"(#{head.text.toLowerAscii.replace(' ','-')})\p")


proc createTOC(outputPath: string = "",
               inject: bool = true,
               top: bool = false,
               inputPaths: seq[string]): bool =
  ## Create a TOC for an input markdown file. This is the program entry.
  for inputPath in inputPaths:
    var outPath: string = 
      if outputPath == "":
        inputPath 
      else:
        outputPath
    var (outDir, _, _) = outPath.splitFile()
    if outDir == "":
      outDir = "."

    if not fileExists(inputPath):
      raise newException(IOError, "That input file could not be found.") 
    if not existsOrCreateDir(outDir):
      echo absolutePath(outDir) & " - OUTPUT FOLDER CREATED."
    else:
      echo "OUTPUT FOLDER EXISTS."

    # Extract the headers from the inputPath file
    var text = inputPath.readFile()
    var headers = extractHeaders(text)

    # Generate the TOC text from the header data
    var toc = generateTOC(headers)

    if not inject:
      echo toc
      continue

    # Open the output file for injection of the TOC text
    echo "WRITING NEW FILE"
    try:
      if top:
        text.insert(toc, 0)
      else:
        text = text.replace("<<TOC>>", toc)

      outPath.writeFile(text)

      continue 

    except:
      raise newException(IOError, "Could not write to output file.")

  return true



when isMainModule:
  cligen.dispatch(
    createTOC,
    help = {"outputPath": "Path to the Markdown file to " &
            "output. Leave blank to replace the input.",

            "inject": "Inject to original file at <<TOC>> " &
            "marker. Otherwise, will just print the TOC " &
            "to stdout. If <<TOC>> marker does not exist " &
            "in the file, the injection will be skipped.",

            "top": "Inject the TOC at the beginning of " &
            " the file instead of at the <<TOC>> marker. " &
            "NOTE: This option will happily insert multiple TOCs " &
            "into a file.",
            "inputPaths": "<Path(s)>"}
  )
