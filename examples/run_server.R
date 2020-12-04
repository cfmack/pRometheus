library("plumber")
server <- plumb("../examples/plumber.R")  # Where 'plumber.R' is the location of the file shown above
server$run(port=8000)
