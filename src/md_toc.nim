import os

import cligen
import regex 



proc generateTOC(inputPath: string,
                 outputPath: string = "",
                 print: bool = false): bool =
  var outPath: string = if outputPath == "": inputPath else: outputPath
  var (outDir, outFile, outExt) = outPath.splitFile()

  if not fileExists(inputPath):
    raise newException(IOError, "That input file could not be found.") 
  if not existsOrCreateDir(outDir):
    echo absolutePath(outDir) & " - OUTPUT FOLDER CREATED."
  else:
    echo "OUTPUT FOLDER EXISTS."

  echo "inputPath: " & expandFilename(inputPath)
  echo "outFilePath: " & absolutePath(outDir)
  echo "outFilename: " & outFile & outExt
  echo "print?: " & $print

  # TODO: Parse inputPath file as Markdown and extract the header structure.
  # TODO: Open the outPath file and write the table of contents (with links)
  #       plus the original contents.

  let header = re"^ *(#{1,6}) *(.*?) *#* *$"
  var m: RegexMatch
  
  # first a line-by-line method
  for l in inputPath.lines:
    if l.match(header, m):
      let lev = m.group(0, l)[0]
      let tex = m.group(1, l)[0] 
      echo "found: " & tex & ", level: " & $(lev.len)

  # TODO: next we need to create a heirarchy of headers.
  #       probably one will be the "current one" and then when we hit one
  #       of equal or greater value, we add it to the stack...


when isMainModule:
  cligen.dispatch(generateTOC, help = {"inputPath": "path to the Markdown " &
                               "file to process",
                               "outputPath": "path to the Markdown file to " &
                               "output. Leave blank to replace the input.",
                               "print": "just print the output to stdout."})

