using Weave

weave(joinpath("", "FirstTimeInJulia.jmd"),
      informat="markdown",
      out_path = :pwd,
      doctype = "md2html")
