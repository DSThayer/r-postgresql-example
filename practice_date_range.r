#Example of a function that executes a query.
#Gets the date range for practices within a particular postcode area.
require("RPostgreSQL");
library(GetoptLong);

#Specify what driver is needed to connect to the database.
drv = dbDriver("PostgreSQL");

#Connect to the database for the course.
con <- dbConnect(drv, dbname = "gp_practice_data", 
                 host = "localhost", port = 5432,
                 user = "postgres", password = rstudioapi::askForPassword())


get_practice_data_range <- function(db_con, postcode_part) {
    query = qq("
      select  
      gp2015.practiceid,
      max(gp2015.period) as latest_date, 
      min(gp2015.period) as earliest_date
      from address a 
      inner join gp_data_up_to_2015 as gp2015 on
      gp2015.practiceid=a.practiceid and 
      a.postcode like '@{postcode_part}%'
      group by gp2015.practiceid          
    ");

    result <- dbGetQuery(db_con,query);  

    if(nrow(result)==0) {
      warning("No practices found. Was postcode part a valid value?")
    }
    
    return(result);
}

cardiff_practices <- get_practice_data_range(con,'CF')

llanelli_practices <- get_practice_data_range(con,'LL')

invalid <- get_practice_data_range(con,'1!')

