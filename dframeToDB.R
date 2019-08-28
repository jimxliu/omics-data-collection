# https://programminghistorian.org/en/lessons/getting-started-with-mysql-using-r
# https://cran.r-project.org/web/packages/RMariaDB/README.html

# install.packages('RMariaDB')
library('RMariaDB')

#### The connection method below uses a password stored in a variable.  
# To use this set localuserpassword="The password of newspaper_search_results_user" 
# localuserpassword <- "AFljjasfd1231sadf"
# storiesDb <- dbConnect(RMariaDB::MariaDB(), user='xinzhou', password=localuserpassword, dbname='newspaper_search_results', host='localhost')

# More secure way, store credentials in a file

# help("dbConnect")

configFile <- "C:\\Users\\jimri\\OneDrive\\Documents\\Key_Pairs\\newspaper_search_results.cnf"
db <- "newspaper_search_results"
storiesDb <- dbConnect(RMariaDB::MariaDB(), default.file=configFile, group=db)

dbListTables(storiesDb)
# dbDisconnect(storiesDb)

### How to insert data in a table
query <- "INSERT INTO tbl_newspaper_search_results (
story_title,
story_date_published,
story_url,
search_term_used) 
VALUES('WALL STREET JOURNAL.',
'1925-06-01',
LEFT(RTRIM('http://newspapers.library.wales/view/4121281/4121288/94/'),99),
'English+Submarine');"

#  Optional. Prints out the query in case you need to troubleshoot it.
print(query)

# Execute the query on the storiesDb that we connected to above.
rsInsert <- dbSendQuery(storiesDb, query)
rsInsert
# Clear the result.
dbClearResult(rsInsert)
# Disconnect to clean up the connection to the database.
# dbDisconnect(storiesDb)

### Storing a comma separated value .csv file into a MySQL db
# read in the sample data from a newspaper search of Allotment And Garden
sampleGardenData <- read.csv(file="C:\\Users\\jimri\\OneDrive\\Documents\\R\\Data\\sample-data-allotment-garden.csv", header=TRUE, sep=",")
# inspect the data
summary(sampleGardenData)
head(sampleGardenData)
colnames(sampleGardenData)
# This statement formats story_date_published to represent a DATETIME.
sampleGardenData$story_date_published <- paste(sampleGardenData$story_date_published," 00:00:00",sep="")
# The story_title column in the database table can store values up to 99 characters long.  
# This statement trims any story_titles that are any longer to 99 characters.
sampleGardenData$story_title <- substr(sampleGardenData$story_title,0,99)
# insert data frame into the MySQL table
dbWriteTable(storiesDb, value=sampleGardenData, row.names=FALSE, name="tbl_newspaper_search_results", append=TRUE)

# read in the sample data from a newspaper search of German+Submarine
sampleSubmarineData <- read.csv(file="C:\\Users\\jimri\\OneDrive\\Documents\\R\\Data\\sample-data-submarine.csv", header=TRUE, sep=",")

sampleSubmarineData$story_title <- substr(sampleSubmarineData$story_title,0,99)
sampleSubmarineData$story_date_published <- paste(sampleSubmarineData$story_date_published," 00:00:00",sep="")

dbWriteTable(storiesDb, value = sampleSubmarineData, row.names = FALSE, name = "tbl_newspaper_search_results", append = TRUE ) 

#disconnect to clean up the connection to the database
dbDisconnect(storiesDb)
