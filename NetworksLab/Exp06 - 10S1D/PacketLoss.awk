#============================= throughput.awk ========================

BEGIN {
drop=0;
recv=0;
gotime = 0;
time = 0;
packet_size = $8;
time_interval = 0.002;
}
#body
{
             event = $1
             time = $2
             node_id = $3
             level = $4
             pktType = $7
	     packet_size = $8

 if(time>gotime) {

  print gotime, drop/recv; 
  gotime+= time_interval;
  }



  if (( event == "r") )
  {
    recv++;
  }
  
  if (( event == "d"))
  {
    drop++;
  }

} #body


END {
;
}
#============================= Ends ============================
