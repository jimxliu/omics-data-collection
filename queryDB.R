library(RMariaDB)
rmariadb.settingsfile<-"C:\\Users\\jimri\\OneDrive\\Documents\\Key_Pairs\\newspaper_search_results.cnf"
rmariadb.db<-"newspaper_search_results"

storiesDb<-dbConnect(RMariaDB::MariaDB(),default.file=rmariadb.settingsfile,group=rmariadb.db) 

searchTermUsed="German+Submarine"
# Query a count of the number of stories matching searchTermUsed that were published each month.
query<-paste("SELECT ( COUNT(CONCAT(MONTH(story_date_published), ' ',YEAR(story_date_published)))) as 'count' 
    FROM tbl_newspaper_search_results
    WHERE search_term_used='",searchTermUsed,"'
    GROUP BY YEAR(story_date_published),MONTH(story_date_published)
    ORDER BY YEAR(story_date_published),MONTH(story_date_published);",sep="")

print(query)
rs = dbSendQuery(storiesDb,query)
dbRows<-dbFetch(rs)

countOfStories<-c(as.integer(dbRows$count))
countOfStories

# Put the results of the query into a time series.
qts1 = ts(countOfStories, frequency = 12, start = c(1914, 8))
print(qts1)

# Plot the qts1 time series data with a line width of 3 in the color red.
plot(qts1, 
     lwd=3,
     col = "red",
     xlab="Month of the war",
     ylab="Number of newspaper stories",
     xlim=c(1914,1919), 
     ylim=c(0,150), 
     main=paste("Number of stories in Welsh newspapers matching the search terms listed below.",sep=""),
     sub="Search term legend: Red = German+Submarine. Green = Allotment And Garden.")

searchTermUsed="AllotmentAndGarden"

# Query a count of the number of stories matching searchTermUsed that were published each month.
query<-paste("SELECT (  COUNT(CONCAT(MONTH(story_date_published),' ',YEAR(story_date_published)))) as 'count'   FROM tbl_newspaper_search_results   WHERE search_term_used='",searchTermUsed,"'   GROUP BY YEAR(story_date_published),MONTH(story_date_published)   ORDER BY YEAR(story_date_published),MONTH(story_date_published);",sep="")
print(query)
rs = dbSendQuery(storiesDb,query)
dbRows<-dbFetch(rs)

countOfStories<-c(as.integer(dbRows$count))

# Put the results of the query into a time series.
qts2 = ts(countOfStories, frequency = 12, start = c(1914, 8))

# Add this line with the qts2 time series data to the the existing plot.
lines(qts2, lwd=3,col="darkgreen")

# Clear the result
dbClearResult(rs)

# Disconnect to clean up the connection to the database.
dbDisconnect(storiesDb)
