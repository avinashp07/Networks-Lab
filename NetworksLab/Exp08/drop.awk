#============================= throughput.awk ========================

BEGIN {
gotime = 0;
c_drop = 0
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

  print gotime, c_drop;
  gotime+= time_interval;
  }


  if (( event == "d") && ( pktType == "tcp" ))
  {
     c_drop++;
  }
  

} #body


END {
;
}
#============================= Ends ============================
