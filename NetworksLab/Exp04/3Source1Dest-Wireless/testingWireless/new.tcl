# A simple example for wireless simulation or  simple.tr
# ======================================================================
# Define options
# ======================================================================
set val(chan)         Channel/WirelessChannel; #Channel type
set val(prop)         Propagation/TwoRayGround; #Radio propagation model
set val(netif)        Phy/WirelessPhy; #Network interface type
set val(mac)          Mac/802_11; #MAC
set val(ifq)          Queue/DropTail/PriQueue; #interface queue type
set val(ll)           LL; #link
set val(ant)          Antenna/OmniAntenna; #antenna model
set val(ifqlen)       50; #max packet in interface priority queue
set val(nn)           5; #number of mobilenodes
set val(rp)           AODV; #routing protocol
set val(x)            1000   ;# X dimension of the topography
set val(y)            1000   ;# Y dimension of the topography
set val(time)         20.0  ;# simulation time
set start_time        1.0   ;# simulation start time

proc finish {} {
global ns_ tracefile namfile
$ns_ flush-trace
close $tracefile
close $namfile
exec nam exp2.nam
exit 0
}

# Main Program
# Initialize Global Variables
set ns_ [new Simulator]


set tracefile [open exp2.tr w]
$ns_ use-newtrace
$ns_ trace-all $tracefile


set namfile [open exp2.nam w]
$ns_ namtrace-all-wireless $namfile $val(x) $val(y)

# set up topography object
set topo        [new Topography]
$topo load_flatgrid $val(x) $val(y)

# Create God
create-god $val(nn)
set chan [new $val(chan)]


$ns_ node-config -adhocRouting $val(rp) \
 -llType $val(ll) \
 -macType $val(mac) \
 -ifqType $val(ifq) \
 -ifqLen $val(ifqlen) \
 -antType $val(ant) \
 -propType $val(prop) \
 -phyType $val(netif) \
 -topoInstance $topo \
 -agentTrace ON \
 -routerTrace ON \
 -macTrace ON \
 -movementTrace ON \
 -channel $chan

for {set i 0} {$i< $val(nn) } {incr i} {
    set node_($i) [$ns_ node]
    $node_($i) random-motion 0 ;# disable random motion
}


# Provide initial (X,Y, for now Z=0) co-ordinates for mobilenodes
# and produce some simple node movements





for {set i 0} {$i< $val(nn)-1 } {incr i} {
    $ns_ initial_node_pos $node_($i) 30
}



#for {set i 0} {$i< $val(nn) } {incr i} {
#$ns_ at 0.0 "$node_($i) setdest 10.0 10.0 0.0"
#}


set udp_(0) [new Agent/UDP]
$udp_(0) set fid_ 0
$ns_ attach-agent $node_(0) $udp_(0)

set udp_(1) [new Agent/UDP]
$udp_(1) set fid_ 1
$ns_ attach-agent $node_(1) $udp_(1)

set udp_(2) [new Agent/UDP]
$udp_(2) set fid_ 2
$ns_ attach-agent $node_(2) $udp_(2)


# Null Agent to receive Packets for Node 0
set null_(0) [new Agent/Null]
$null_(0) set fid_ 3
$ns_ attach-agent $node_(3) $null_(0)

# Constant Bit rate traffic generator
set cbr_(0) [new Application/Traffic/CBR]
$cbr_(0) set packetSize_ 512
$cbr_(0) set interval_ 0.02
$cbr_(0) set random_ 0
$cbr_(0) set maxpkts_ 10000
$cbr_(0) attach-agent $udp_(0)

set cbr_(1) [new Application/Traffic/CBR]
$cbr_(1) set packetSize_ 512
$cbr_(1) set interval_ 0.02
$cbr_(1) set random_ 0
$cbr_(1) set maxpkts_ 10000
$cbr_(1) attach-agent $udp_(1)

set cbr_(2) [new Application/Traffic/CBR]
$cbr_(2) set packetSize_ 512
$cbr_(2) set interval_ 0.02
$cbr_(2) set random_ 0
$cbr_(2) set maxpkts_ 10000
$cbr_(2) attach-agent $udp_(2)

$ns_ connect $udp_(0) $null_(0)
$ns_ at $start_time "$cbr_(0) start"

$ns_ connect $udp_(1) $null_(0)
$ns_ at $start_time "$cbr_(1) start"

$ns_ connect $udp_(2) $null_(0)
$ns_ at $start_time "$cbr_(2) start"



# Tell nodes when the simulation ends
for {set i 0} {$i< $val(nn) } {incr i} {
    $ns_ at $val(time) "$node_($i) reset";
}

$ns_ at $val(time) "finish"
$ns_ at [expr $val(time) + 0.01] "puts \"NS EXITING...\"; $ns_ halt"
puts "Starting Simulation..."
$ns_ run

