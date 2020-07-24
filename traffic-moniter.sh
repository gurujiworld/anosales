#!/bin/bash
#Moniter the traffic for monthly and daly basis 
#using vnstate cmd 
path="/"
m_target=3
m_rx=6
m_tx=5
HOSTNAME=$(hostname)
mailer=root
mkdir -p /var/log/bandwidth
LOGER=/var/log/bandwidth/traffic-Moniter`date +%Y-%h-%d.log`
touch $LOGER
rx=`vnstat -i bridge0 | grep "estimated" | head -n 1 | awk '{print $2}' | awk -F . '{print $1}'`
tx=`vnstat -i bridge0 | grep "estimated" | head -n 1 | awk '{print $5}' | awk -F . '{print $1}'`
total=`vnstat -i bridge0 | grep "estimated" | head -n 1 | awk '{print $8}' | awk -F . '{print $1}'`

    if [ "$tx" -ge "$m_tx" ]
    then
        echo "The $HOSTNAME is used total Bandwidth TX:$tx GB on `date +%d-%h-%Y`" >> $LOGER
        echo "TOTAL :  The $HOSTNAME is used total Bandwidth RX:$tx GB on `date +%d-%h-%Y`" | mail -s "Transfered Bandwidth WARNING" $mailer
        
    fi

    if [ "$rx" -ge "$m_rx" ]
    then    
        echo "The $HOSTNAME is used total Bandwidth RX:$rx GB on `date +%d-%h-%Y`" >> $LOGER
        echo "TOTAL :  The $HOSTNAME is used total Bandwidth RX:$rx  GB on `date +%d-%h-%Y`" | mail -s "Recived Bandwidth WARNING" $mailer
        
    fi

    if [ "$total" -ge "$m_target" ]
    then
        echo "The $HOSTNAME is used Total_Bandwidth:$total GB on `date +%d-%h-%Y`" >> $LOGER
        echo "TOTAL :  The $HOSTNAME is used Total_Bandwidth:$total GB on `date +%d-%h-%Y`" | mail -s "Total Used Bandwidth WARNING" $mailer
    fi  

    if [ "$rx" -lt "$m_rx" -a "$tx" -lt $m_tx -a "$total" -lt "$m_target" ]
    then
        echo "Bandwidth on $HOSTNAME is total:$total, Recived:$rx, Transfered:$tx" traffic is under control >> $LOGER
        echo "Bandwidth on $HOSTNAME is total:$total, Recived:$rx, Transfered:$tx" traffic is under control | mail -s "Bandwidth stable state"
    fi
    


