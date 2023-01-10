#============================= throughput.awk ========================

BEGIN {
recv=0;
gotime = 0.5;
time = 0;
packet_size = $8;
receivedPackets = 0;
droppedPackets = 0;
sentPackets = 0;
time_interval=0.1;
}
#body
{
             event = $1
             time = $2
             send_node = $3
             recv_node = $4
             pktType = $7
	     packet_size = $8

 if(time>gotime) {
  gotime+= time_interval;
  }

#============= CALCULATE throughput=================

if (pktType == "tcp" || pktType == "AODV")
{

  if (( event == "r"))
  {
     receivedPackets++;
  }
  
  if (( event == "d") || ( event == "D"))
  {
     droppedPackets++;
  }
  
   if (( event == "s") || ( event == "f"))
  {
     sentPackets++;
  }
}

  print gotime, droppedPackets/sentPackets*100; #packet size * ... gives results in kbps

} #body


END {
;
}
#============================= Ends ============================
