#! /bin/bash

osascript -e 'tell app "Terminal"
    do script "cd Documents/Cours/S9-EPFL/SemesterProject/ && sudo  mongod --dbpath ./database"
end tell'

cd SPFL
http-server
