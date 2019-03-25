library(odbc)

# connect to a database using odbc
con <- DBI::dbConnect(odbc::odbc())

# memoise function, if it's not already memoised
if (!memoise::is.memoised(dbGetQuery)){
  dbGetQuery <- memoise::memoise(dbGetQuery)
}

# define some random function to query a database
# get back the results, and do something cool with them
somefunc <- function(input_rows, output_rows){
  input_rows <- as.character(as.integer(input_rows))
  
  sql <- paste0("
  select top ", input_rows , " *
  from dbo.etl_billpay_raw")
  
  res <- dbGetQuery(con, sql) 
  
  # perform some complex analysis or modelling with data
  # or just print the first n rows
  return(head(res, n = output_rows))
}

# run function twice with different second parameter
somefunc(100000, 10)
somefunc(100000, 20)
