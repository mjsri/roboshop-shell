#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGODB_HOST=mongodb.srikanthdevops.online

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

dnf module disable nodejs -y

VALIDATE $? "Disabling current nodejs" &>> $LOGFILE

dnf module enable nodejs:18 -y

VALIDATE $? "enabling nodejs::18" &>> $LOGFILE

dnf install nodejs -y

VALIDATE $? "installing nodejs::18" &>> $LOGFILE

useradd roboshop

VALIDATE $? "creating roboshop user" &>> $LOGFILE

mkdir /app

VALIDATE $? "creating app directory" &>> $LOGFILE

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip

VALIDATE $? "downloading catalogue app" &>> $LOGFILE

cd /app 

unzip /tmp/catalogue.zip

VALIDATE $? "unzipping catalogue app" &>> $LOGFILE

npm install 

VALIDATE $? "installing dependencies" &>> $LOGFILE

#use absolute because catalogue.service exit there
cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service

VALIDATE $? "copying catalogue service file"

systemctl daemon-reload

VALIDATE $? "daemon reload" &>> $LOGFILE

systemctl enable catalogue

VALIDATE $? "enable catalogue" &>> $LOGFILE

systemctl start catalogue

VALIDATE $? "starting catalogue" &>> $LOGFILE

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

VALIDATE $? "copying mongod repo" &>> $LOGFILE

dnf install mongodb-org-shell -y

VALIDATE $? "installing mongodb client" &>> $LOGFILE

mongo --host $MONGODB_HOST </app/schema/catalogue.js

VALIDATE $? "loading catalogue data in to mongodb"











