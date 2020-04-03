#docker container run -it mssql-tools sqlcmd -?
#docker container run -it mssql-tools mssql-cli --help
#docker container run -it mssql-tools sqlpackage

docker container run -it mssql-alpine sqlcmd -?

docker container run -it --network host mssql-tools mssql-cli -S localhost -U sa -P chucho
master > use "MyDB" 
MyDB> select name from chucho

── Scripts
│   ├── bookTable.sql
│   ├── demo.bacpac
│   └── example.sql

docker container run -v /home/vin/scripts:/scripts -it --network host mssql-tools mssql-cli -S localhost \
-U sa -P chucho -d MyDB -i /scripts/bookTable.sql

docker container run -v /home/vin/scripts:/scripts -it --network host mssql-tools sqlpackage \
/TargetFile:"/scripts/demo.dacpac" /Action:Extract /SourceServerName:"localhost" /SourceDatabaseName:"MyDB" \
/SourcePassword:"chucho" /SourceUser:"sa"

docker container run -v /home/vin/scripts:/scripts -it --network host mssql-tools mssql-cli -S localhost \
-U sa -P chucho -d MyDB -Q "select name from sys.tables"

docker container run -v /home/vin/scripts:/scripts -it --network host mssql-tools mssql-cli -S localhost \
-U sa -P chucho -d MyDB -Q "Drop table books"

docker container run -v /home/vin/scripts:/scripts -it --network host mssql-tools sqlpackage \
/TargetFile:"/scripts/demo.dacpac" /Action:Publish /TargetServerName:"localhost" /TargetDatabaseName:"MyDB" \
/TargetPassword:"chucho" /Target  User:"sa"

docker container run -v /home/vin/scripts:/scripts -it --network host mssql-tools mssql-cli -S localhost \
-U sa -P chucho -d MyDB -Q "select name from sys.tables"