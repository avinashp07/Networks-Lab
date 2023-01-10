#============================= throughput.awk ========================

BEGIN {
recv=0;
gotime = 0.5;
time = 0;
packet_size = $8;
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

  print gotime, (packet_size * recv * 8.0)/1000; #packet size * ... gives results in kbps
  gotime+= time_interval;
  recv=0;
  }

#============= CALCULATE throughput=================

  if (( event == "r") && ( pktType == "cbr" ))
  {
     recv++;
  }

} #body


END {
;
}
#============================= Ends ============================
