import os

import cligen
import npeg


proc generateTOC(inputPath: string,
                 outputPath: string = "",
                 print: bool = false): bool =
  var outPath: string = if outputPath == "": inputPath else: outputPath

  if not fileExists(inputPath):
    raise newException(IOError, "That input file could not be found.") 
  if not existsOrCreateDir(outPath.splitFile().dir):
    echo absolutePath(outPath.splitFile.dir) & " OUTPUT FOLDER CREATED."
  else:
    echo "OUTPUT FOLDER EXISTS."

  echo "inputPath: " & expandFilename(inputPath)
  echo "outFilePath: " & absolutePath(outPath.splitFile().dir)
  echo "outFilename: " & outPath.splitFile().name & outPath.splitFile().ext
  echo "print?: " & $print

  # TODO: Parse inputPath file as Markdown and extract the header structure.
  # TODO: Open the outPath file and write the table of contents (with links)
  #       plus the original contents.


when isMainModule:
  cligen.dispatch(generateTOC, help = {"inputPath": "path to the Markdown " &
                               "file to process",
                               "outputPath": "path to the Markdown file to " &
                               "output. Leave blank to replace the input.",
                               "print": "just print the output to stdout."})

