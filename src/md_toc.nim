import os
import strutils
import strformat

import cligen
import regex 


type
  Header = object
    text: string
    level: int


proc getMarkdownFiles(dir: string): seq[string] =
  for kind, path in walkDir(dir):
    if kind == pcFile and path.splitFile.ext == ".md":
      result.add path


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

  # all the file paths to process
  var fileBatch: seq[string] = @[]
  var outPath: string = ""

  # these path can be files or directories
  for path in inputPaths:
    if fileExists(path):
      if path.splitFile.ext == ".md":
        echo "it's a markdown file"
        fileBatch.add path
      else:
        echo "not a markdown file: " & path
    else:
      echo "not a file"
      if dirExists path:
        let files = path.getMarkdownFiles()
        fileBatch.add files
        echo "it's a directory with " & $(files.len) & " markdown files"
      else:
        echo "ERROR: not a markdown file or directory: " & path
       
  if fileBatch.len <= 0:
    echo "no markdown files were found..."
    return false
  else:
    echo "found these files: "
    for i, f in fileBatch: echo $i & ") " & f

  
  # create outputPath if needed

  if outputPath != "":
    if dirExists(outputPath):
      outPath = outputPath.normalizedPath.absolutePath
    else:
      if outputPath.splitFile.ext == "":
        outPath = outputPath.normalizedPath.absolutePath
      else:
        outPath = outputPath.splitFile.dir.normalizedPath.absolutePath

      if existsOrCreateDir(outPath):
        echo "using output path: " & outPath
      else:
        echo "created output path: " & outPath


  for file in fileBatch:
    # process each file in the batch 
    echo "processing file: " & file
    var text = file.readFile()
    var headers = extractHeaders(text)

    # Generate the TOC text from the processed header data
    var toc = generateTOC(headers)

    # if --inject=false, then just output the TOC
    if not inject:
      echo "TOC:"
      echo toc
      continue

    # if outputPath is set to something, then create a new file in outputPath
    #   with the same filename as the input file
    var outFile = file
    if outPath != "":
      outFile = outPath / outFile.splitFile.name & outFile.splitFile.ext

    # try to replace the text and write the new file
    echo "writing file: " & outFile
    try:
      if top:
        text.insert(toc, 0)
      else:
        text = text.replace("<<TOC>>", toc)
      outFile.writeFile(text)
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
