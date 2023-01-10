set ns [new Simulator]

set nf [open out.nam w]
set nt [open out.tr w]
$ns namtrace-all $nf
$ns trace-all $nt



for { set a 0} {$a < 11} { incr a } {
  set n($a) [$ns node]
}


for { set a 1} { $a < 11 } { incr a } {
  $ns duplex-link $n(0) $n($a) 0.5Mb 10ms DropTail
}

$ns queue-limit $n(0) $n(1) 5


for { set a 1 } { $a < 11 } { incr a } {
  set udp($a) [new Agent/UDP]
  $ns attach-agent $n($a) $udp($a)
}

for { set a 1 } { $a < 11 } { incr a } {
   set cbr($a) [new Application/Traffic/CBR]
   $cbr($a) set packet_size_ 500
   $cbr($a) set interval_ 0.005
   $cbr($a) attach-agent $udp($a)
}


set null0 [new Agent/Null]
$ns attach-agent $n(0) $null0

for { set a 1 } { $a < 11 } { incr a } {
   $ns connect $udp($a) $null0
}



proc finish {} {
  global ns nf nt
  $ns flush-trace
  close $nf
  close $nt
  exec nam out.nam & 
  exit 0
}

$ns at 0.0 "$cbr(1) start"
$ns at 0.0 "$cbr(2) start"
$ns at 0.0 "$cbr(3) start"
$ns at 0.4 "$cbr(4) start"
$ns at 0.6 "$cbr(5) start"
$ns at 0.8 "$cbr(6) start"
$ns at 1.0 "$cbr(7) start"
$ns at 1.2 "$cbr(8) start"
$ns at 1.4 "$cbr(9) start"
$ns at 1.6 "$cbr(10) start"



$ns at 2.0 "finish"
$ns run
