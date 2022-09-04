#!/bin/bash

#Save text from ifconfig and date to data.log
interface="br0"
ifconfig $interface > data.log
date "+%Y/%m/%d-%H:%M:%S" >> data.log

#Search "...keyword..." line
MACaddr=$(grep "ether" ./data.log)
IPaddr=$(grep "inet" ./data.log)
NRx=$(grep "RX packets" ./data.log)
NTx=$(grep "TX packets" ./data.log)
Date=$(tail -n 1 ./data.log)

#Cut text
MACaddr=$(echo $MACaddr | cut -d " " -f2)
IPaddr=$(echo $IPaddr | cut -d " " -f2)
NRx=$(echo $NRx | cut -d " " -f3)
NTx=$(echo $NTx | cut -d " " -f3)

#Print text
echo -e "\nDate: $Date"
echo "MAC Address: $MACaddr"
echo "IP Address: $IPaddr"
echo "Received Packages: $NRx"
echo -e "Transmitted Packages: $NTx\n"

#Save TX and RX data
for i in `seq 1 20`
do
	ifconfig $interface > loop.log
	date "+%Y/%m/%d-%H:%M:%S" >> loop.log

	NRx=`grep "RX packets" ./loop.log`
	NTx=`grep "TX packets" ./loop.log`
	Date=`tail -n 1 ./loop.log`

	NRx=`echo $NRx | cut -d " " -f3`
	NTx=`echo $NTx | cut -d " " -f3`

	#Verbose
	echo "$i of 20"
	echo "Date: $Date"
	echo "Received Packages: $NRx"
	echo "Transmitted Packages: $NTx"
	echo "$Date,$NRx,$NTx"  >> Time_RP_TP.csv

	#0.5[s] pause
	sleep 0.5
done