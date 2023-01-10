#============================= throughput.awk ========================

BEGIN {
recv=0;
gotime = 0;
time = 0;
packet_size = $6;
time_interval=0.002;
}
#body
{
       event = $1
             time = $2
             node_id = $3
             level = $4
             pktType = $5
	     packet_size = $6
	     
 if(gotime <= 2) {

  print gotime, (packet_size * recv * 8.0)/1000; #packet size * ... gives results in kbps
  gotime+= time_interval;
  }

#============= CALCULATE throughput=================

  if (( event == "r" ))
  {
     recv++;
  }

} #body


END {
;
}
#============================= Ends ============================
