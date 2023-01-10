#============================= throughput.awk ========================

BEGIN {
gotime = 0;
c_dequeue = 0
packet_size = $6;
time_interval=0.01;
}

#body
{
       event = $1
             time = $2
             node_id = $4
             pktType = $5
	     packet_size = $6
	     
 if(gotime+1) {

  print gotime, c_dequeue;
  gotime+= time_interval;
  }


  if (( event == "-") && ( pktType == "tcp" ))
  {
     c_dequeue++;
  }
  

} #body


END {
;
}
#============================= Ends ============================
