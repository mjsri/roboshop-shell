#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILED $N"
    else 
        echo -e "$2 ...$G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then 
   echo -e "$R ERROR:: Please run this script in root user access $N"
   exit 1 # you can give other than 0
else
   echo "you are root user"
fi  # fi means end of if means end of statement

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "copied mongodb repo"