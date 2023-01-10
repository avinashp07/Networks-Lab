#Create a simulator object
set ns [new Simulator]

set namfile [open Exp03.nam w]
$ns namtrace-all $namfile

#Open trace files
set f [open out.tr w]
$ns trace-all $f
#Define a 'finish' procedure
proc finish {} {
	global ns
	$ns flush-trace
	exit 0
}
#Create four nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

#Create links between the nodes
$ns duplex-link $n2 $n0 1Mb 10ms DropTail
$ns duplex-link $n2 $n1 1Mb 10ms DropTail
$ns duplex-link $n2 $n3 1Mb 10ms SFQ
$ns duplex-link $n2 $n4 1Mb 10ms SFQ

#Orienting The nodes
$ns duplex-link-op $n2 $n0 orient left-up
$ns duplex-link-op $n2 $n1 orient left-down
$ns duplex-link-op $n2 $n3 orient left
$ns duplex-link-op $n2 $n4 orient right


#Create a UDP agent and attach it to node n0
set udp0 [new Agent/UDP]
$udp0 set class_ 0  # fid in trace file
$ns attach-agent $n0 $udp0

# Create a CBR traffic source and attach it to udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

#Create a UDP agent and attach it to node n1
set udp1 [new Agent/UDP]
$udp1 set class_ 1
$ns attach-agent $n1 $udp1

# Create a CBR traffic source and attach it to udp1
set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 200
$cbr1 set interval_ 0.005
$cbr1 attach-agent $udp1

#Create a UDP agent and attach it to node n1
set udp3 [new Agent/UDP]
$udp3 set class_ 3
$ns attach-agent $n3 $udp3

# Create a CBR traffic source and attach it to udp1
set cbr3 [new Application/Traffic/CBR]
$cbr3 set packetSize_ 100
$cbr3 set interval_ 0.005
$cbr3 attach-agent $udp3

#Create a Null agent (a traffic sink) and attach it to node n3
set null0 [new Agent/Null]
$ns attach-agent $n4 $null0

#Connect the traffic sources with the traffic sink
$ns connect $udp0 $null0
$ns connect $udp1 $null0
$ns connect $udp3 $null0

#Schedule events for the CBR agents
$ns at 0.5 "$cbr0 start"
$ns at 1.0 "$cbr1 start"
$ns at 1.5 "$cbr3 start"
$ns at 3.5 "$cbr3 stop"
$ns at 4.0 "$cbr1 stop"
$ns at 4.5 "$cbr0 stop"
#Call the finish procedure after 5 seconds of simulation time
$ns at 5.0 "finish"
#Run the simulation
$ns run


