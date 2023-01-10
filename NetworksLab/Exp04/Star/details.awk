#============================= throughput.awk ========================

BEGIN {
recv=0;
gotime = 0.5;
time = 0;
packet_size = $8;
receivedPackets = 1;
droppedPackets = 1;
sentPackets = 0;
time_interval=0.1;
}
#body
{
             event = $1
             time = $2
             send_node = $3
             recv_node = $4
             pktType = $5
	     packet_size = $6
	     
 if(time>gotime) {
  gotime+= time_interval;
  }

#============= CALCULATE throughput=================

  if (( event == "r"))
  {
     receivedPackets++;
  }
  
  if (( event == "d"))
  {
     droppedPackets++;
  }
  
   if (( event == "+"))
  {
     sentPackets++;
  }


} #body


END {
print "\n\n\t\tReceived Packets = " receivedPackets;
print "\n\n\t\tDropped Packets  = " droppedPackets;
print "\n\n\t\tSent Packets  = " sentPackets;
print "\n\n\t\tPacket Delivery Ratio  = " receivedPackets/sentPackets*100 "%";
print "\n\n\t\tPacket Loss Ratio  = " 100 - (receivedPackets/sentPackets*100) "%";
}
#============================= Ends ============================
