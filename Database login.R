#Install the RPostgreSQL package.
#This only needs to be done once, if the package isn't installed on the computer.
#Remove the hash from the command below to run it if needed.
#install.packages("RPostgreSQL");

#Make sure the RPostgreSQL package is available.
require("RPostgreSQL");

#Specify what driver is needed to connect to the database.
drv = dbDriver("PostgreSQL");

#Connect to the database for the course.
con <- dbConnect(drv, dbname = "gp_practice_data", 
                 host = "localhost", port = 5432,
                 user = "postgres", password = rstudioapi::askForPassword())

# check all tables in the database ####
dbListTables(con)

# check columns of address table
# Using information_schema, a standard set of database information that 
# holds information about the database contents.
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
                      from address a")

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


period_summary <- dbGetQuery(con, 
  "select 	period,
	        	sum(items) as total_items,
		        sum(nic) as total_cost
	    from gp_data_up_to_2015
	    group by period
")

period_summary$period = as.factor(period_summary$period)

plot(x=period_summary$period, y=period_summary$total_cost)
