import unittest

import md_toc


suite "markdown header parsing":
  test "can parse headers":
    check:
      getHeaders("./testinput.md") == @["This is ..."] 
