set ns [new Simulator]

set tracefile [open Reno.tr w]
$ns trace-all $tracefile

set namfile [open Reno.nam w]
$ns namtrace-all $namfile

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]


$ns duplex-link $n0 $n1 5Mb 5ms DropTail
$ns duplex-link $n2 $n1 5Mb 5ms DropTail
$ns duplex-link $n3 $n1 5Mb 5ms DropTail

$ns queue-limit $n0 $n1 2
$ns queue-limit $n2 $n1 2
$ns queue-limit $n3 $n1 2

set tcp0 [new Agent/TCP/Reno]
$ns attach-agent $n0 $tcp0
$tcp0 set packetSize_ 10000
$tcp0 set interval_ 0.005

set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $tcp0

set tcp1 [new Agent/TCP/Reno]
$ns attach-agent $n2 $tcp1
$tcp1 set packetSize_ 10000
$tcp1 set interval_ 0.005

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $tcp1

set tcp3 [new Agent/TCP/Reno]
$ns attach-agent $n3 $tcp3
$tcp3 set packetSize_ 10000
$tcp3 set interval_ 0.005

set cbr3 [new Application/Traffic/CBR]
$cbr3 attach-agent $tcp3


set null0 [new Agent/TCPSink]
$ns attach-agent $n1 $null0

set null1 [new Agent/TCPSink]
$ns attach-agent $n1 $null1

set null2 [new Agent/TCPSink]
$ns attach-agent $n1 $null2

$ns connect $tcp0 $null0 
$ns connect $tcp1 $null1
$ns connect $tcp3 $null2

proc finish {} {
	global ns tracefile namfile
	$ns flush-trace
	close $tracefile
	close $namfile
	exit 0
}

$ns at 1.0 "$cbr0 start"
$ns at 2.0 "$cbr1 start"
$ns at 3.0 "$cbr3 start"
$ns at 6.0 "$cbr3 stop"
$ns at 7.0 "$cbr1 stop"
$ns at 8.0 "$cbr0 stop"

$ns at 10.0 "finish"
$ns run


