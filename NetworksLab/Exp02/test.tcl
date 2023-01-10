set ns [new Simulator]

set tracefile [open test.tr w]
$ns trace-all $tracefile

set namfile [open test.nam w]
$ns namtrace-all $namfile

set n0 [$ns node]
set n1 [$ns node]

$ns duplex-link $n0 $n1 3mb 5ms DropTail
