#!/bin/bash

AMI=ami-0b4f379183e5706b9
SG_ID=sg-0ff003356a354c08c
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")
ZONE_ID=Z07244143QJ1OEE84DH86
DOMAIN_NAME=srikanthdevops.online

for i in "${INSTANCES[@]}"
do  
    if [ $i=="mongodb" ] || [ $i="mysql"] || [ $i="shipping"]
    then    
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    IP_ADDRESS=$(aws ec2 run-instances --image-id $AMI --instance-type $INSTANCE_TYPE --security-group-ids $SG_ID 
    --tag-specifications "ResourceType=instance,Tags=[{key=Name,Value=$i}]" --query 'Instance[0].PrivateIpAddress' --output text)
    echo "$i: $IP_ADDRESS"

    #create route53 records make sure you delete existing records
    aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '
    {
        "Comment": "Creating a record set for cognito endpoint"
        ,"Changes": [{
        "Action"              : "UPSERT"
        ,"ResourceRecordSet"  : {
            "Name"              : "'$i'.'$DOMAIN_NAME'"
            ,"Type"             : "A"
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'$IP_ADDRESS'"
            }]
        }
        }]
    }
        '
done