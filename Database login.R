#Install the RPostgreSQL package.
#This only needs to be done once, if the package isn't installed on the computer.
#Remove the hash from the command below to run it if needed.
#install.packages("RPostgreSQL");

#Make sure the RPostgreSQL package is available.
require("RPostgreSQL");

#Specify what driver is needed to connect to the database.
drv = dbDriver("PostgreSQL");

#Code that pops up a login box for username and password, so it doesn't appear in your file.
#The file login_box.R must be in the location specified below.
#The below code specifies that it will be in a folder named prescribing_data_analysis
source("./login_box.R");
#This calls the function that pops up a login box, and returns your username and password
#As a list with 2 items.
login = getLogin();

#Connect to the database for the course.
con <- dbConnect(drv, dbname = "gp_practice_data", 
                 host = "localhost", port = 5432,
                 user = login[1], password = login[2])

# check all tables in the database ####
dbListTables(con)

# check columns of address table
dbGetQuery(con, "
           select column_name, 
	         ordinal_position,
           data_type,
           character_maximum_length,
           numeric_precision
           from INFORMATION_SCHEMA.COLUMNS
           where table_schema = 'public'
           and table_name = 'address';")

# query a dataset ####

surgery <- dbGetQuery(con, "select distinct a.practiceid 
                      from address a
                      join gp_data_up_to_2015 b
                      on a.practiceid = b.practiceid;")

surgery

surgery <- sort(surgery$practiceid)

total_rows <- dbGetQuery(con, "select count(*) from public.gp_data_up_to_2015")
total_rows

#Add a value into a string
practice <- "W92019"

query <- paste(
  "select count(*) from public.gp_data_up_to_2015 where practiceid = '",
  practice,
  "'"
  ,sep="")

total_rows_in_practice <- dbGetQuery(con,query)
total_rows_in_practice

#More elegant way to add a variable to a string using GetoptLong package
install.packages("GetoptLong");
library(GetoptLong);

practice_query = qq(
  "select count(*) from public.gp_data_up_to_2015 where practiceid = '@{practice}'"
);
practice_query

# close the connection
dbDisconnect(con)
dbUnloadDriver(drv)




