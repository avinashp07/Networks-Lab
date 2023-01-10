set ns [new Simulator]

set nf [open tahoe.nam w]
set nt [open tahoe.tr w]
$ns namtrace-all $nf
$ns trace-all $nt

$ns color 0 Blue

for { set a 0} {$a < 21} { incr a } {
  set n($a) [$ns node]
}


for { set a 0} { $a < 20} { incr a } {
  $ns duplex-link $n($a) $n([expr {$a+1}]) 1Mb 10ms DropTail
  $ns queue-limit $n($a) $n([expr {$a+1}]) 6
}

 $ns duplex-link $n(20) $n(0) 1Mb 10ms DropTail
 $ns queue-limit $n(20) $n(0) 6



for {set a 0} { $a < 21} { incr a } {
  set tcp($a) [new Agent/TCP]
  $tcp($a) set class_ 0
  $ns attach-agent $n($a) $tcp($a)
}

for { set a 0 } { $a < 21 } { incr a } {
   set ftp($a) [new Application/FTP]
   $ftp($a) attach-agent $tcp($a)
}


for { set a 1 } { $a < 21 } { incr a } {
   set sink($a) [new Agent/TCPSink]
   $ns attach-agent $n($a) $sink($a)
}


for { set a 0 } { $a < 16 } { incr a } {
   $ns connect $tcp($a) $sink([expr {$a+5}])
}




proc finish {} {
  global ns nf nt
  $ns flush-trace
  close $nf
  close $nt
  exec nam tahoe.nam & 
  exit 0
}

for {set i 0} {$i < 16} {incr i} {
  $ns at "0.0" "$ftp($i) start"
}


$ns at 3.0 "finish"
$ns run
