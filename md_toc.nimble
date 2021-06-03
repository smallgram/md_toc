# Package

version       = "0.0.1"
author        = "smallgram"
description   = "Super simple tool to generate Markdown TOCs."
license       = "MIT"
srcDir        = "src"
binDir        = "bin"
bin           = @["md_toc"]


# Dependencies

requires "nim >= 1.4.6"
requires "npeg#5d80f93"
requires "cligen#0903dec"
requires "regex#eeefb4f"
